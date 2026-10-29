"""Пересоздание учебной БД. Требуется Python 3.10+ и SQLite 3.37+."""
from pathlib import Path
import sqlite3,csv,json,re,argparse
p=Path(__file__).resolve().parents[1]
a=argparse.ArgumentParser();a.add_argument('--force',action='store_true');args=a.parse_args()
target=p/'travel_agency.db'
if target.exists():
 if not args.force: raise SystemExit('БД уже существует. Для пересоздания используйте --force.')
 target.unlink()
c=sqlite3.connect(target);c.execute('PRAGMA foreign_keys=ON')
c.executescript((p/'sql/01_create_tables.sql').read_text(encoding='utf-8'))
order=['client','employee','tour_operator','destination','tour','departure','booking','payment']
log=[]
try:
 with c:
  for t in order:
   with (p/'csv'/f'{t}.csv').open(encoding='utf-8-sig',newline='') as f:
    reader=csv.DictReader(f); cols=reader.fieldnames
    expected=[r[1] for r in c.execute(f'PRAGMA table_info({t})')]
    if cols!=expected: raise ValueError(f'Неверные столбцы {t}: {cols}')
    rows=[[None if v=='' else v for v in row.values()] for row in reader]
    c.executemany(f'INSERT INTO {t} VALUES ({",".join("?" for _ in cols)})',rows)
    log.append({'table':t,'inserted':len(rows)})
except Exception:
 c.close();target.unlink();raise
errors=[]
with (p/'csv/booking_invalid.csv').open(encoding='utf-8',newline='') as f:
 reader=csv.DictReader(f)
 for line,row in enumerate(reader,2):
  c.execute('SAVEPOINT bad_row')
  try:
   c.execute('INSERT INTO booking VALUES (?,?,?,?,?,?,?,?)',list(row.values()))
  except sqlite3.IntegrityError as ex:
   errors.append({'line':line,'error':str(ex)})
  else: raise AssertionError(f'Ошибочная строка {line} принята')
  finally:
   c.execute('ROLLBACK TO bad_row');c.execute('RELEASE bad_row')
before=[r[3] for r in c.execute("EXPLAIN QUERY PLAN SELECT * FROM departure WHERE start_date='2026-11-10'")]
c.executescript((p/'sql/02_indexes.sql').read_text(encoding='utf-8'))
after=[r[3] for r in c.execute("EXPLAIN QUERY PLAN SELECT * FROM departure WHERE start_date='2026-11-10'")]
plan2=[r[3] for r in c.execute("EXPLAIN QUERY PLAN SELECT * FROM booking WHERE client_id=1 AND booked_on>='2026-10-01'")]
assert any('idx_departure_date' in x for x in after)
assert any('idx_booking_client_date' in x for x in plan2)
results=[]
text=(p/'sql/03_queries.sql').read_text(encoding='utf-8')
for title,sql in re.findall(r'-- (Q\d+\. [^\n]+)\n(.*?);',text,re.S):
 cur=c.execute(sql);results.append({'query':title,'sql':sql,'columns':[d[0] for d in cur.description],'rows':cur.fetchall()})
assert len(results)==15
assert results[4]['rows']==[(9,16,980000.0)]
assert sum(r[3] for r in results[8]['rows'])==435000.0
assert results[10]['rows'][0][0]==6
assert c.execute('PRAGMA integrity_check').fetchone()[0]=='ok'
assert c.execute('PRAGMA foreign_key_check').fetchall()==[]
assert len(errors)==5
# Проверка RESTRICT в обратимой транзакции
c.execute('SAVEPOINT restrict_test')
try:
 c.execute('DELETE FROM client WHERE client_id=1')
 raise AssertionError('RESTRICT не сработал')
except sqlite3.IntegrityError: pass
finally:
 c.execute('ROLLBACK TO restrict_test');c.execute('RELEASE restrict_test')
c.commit()
report={'sqlite_version':sqlite3.sqlite_version,'import':log,'rejected':errors,'integrity':'ok','foreign_key_errors':0,'index_before':before,'index_after':after,'index_booking':plan2,'queries_passed':15,'business_checks':'9 активных бронирований, 16 туристов, 980000 руб.; долг 435000 руб.; клиент 6 без бронирований; удаление клиента 1 запрещено'}
(p/'results').mkdir(exist_ok=True)
(p/'results/validation.json').write_text(json.dumps(report,ensure_ascii=False,indent=2),encoding='utf-8')
(p/'results/query_results.json').write_text(json.dumps(results,ensure_ascii=False,indent=2),encoding='utf-8')
with (p/'results/query_results.md').open('w',encoding='utf-8') as f:
 for r in results:
  f.write('\n## '+r['query']+'\n\n| '+' | '.join(r['columns'])+' |\n| '+' | '.join('---' for _ in r['columns'])+' |\n')
  for row in r['rows']: f.write('| '+' | '.join(str(x) for x in row)+' |\n')
c.close();print(json.dumps(report,ensure_ascii=False,indent=2))
