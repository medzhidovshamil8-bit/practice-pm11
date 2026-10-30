PRAGMA foreign_keys=ON;
CREATE TABLE student (id INTEGER PRIMARY KEY, fio TEXT NOT NULL, birth_date TEXT NOT NULL, average_grade REAL CHECK(average_grade BETWEEN 2 AND 5));
INSERT INTO student VALUES (1,'Иванов И.И.','2007-05-14',4.5),(2,'Петров П.П.','2006-11-03',3.8),(3,'Сидоров С.С.','2007-01-20',4.9);
CREATE TABLE teacher (id INTEGER PRIMARY KEY, fio TEXT NOT NULL, subject TEXT NOT NULL, experience_years INTEGER NOT NULL CHECK(experience_years>=0));
INSERT INTO teacher VALUES (1,'Алексеева Н.Н.','Математика',12),(2,'Волков А.А.','Физика',3),(3,'Громова Е.С.','Информатика',8),(4,'Денисов М.П.','История',6),(5,'Егорова Т.В.','Биология',2);
CREATE TABLE attachment (id INTEGER PRIMARY KEY, file_name TEXT NOT NULL, content BLOB);
INSERT INTO attachment VALUES (1,'note.txt',x'48656C6C6F');
CREATE TABLE audit_log (id INTEGER PRIMARY KEY, created_on TEXT NOT NULL DEFAULT (date('now')), action TEXT NOT NULL);
INSERT INTO audit_log (action) VALUES ('Создание учебной базы');

-- Все студенты
SELECT * FROM student ORDER BY id;
-- Стаж больше 5
SELECT fio,experience_years FROM teacher WHERE experience_years>5 ORDER BY id;
-- BLOB
SELECT file_name,length(content) AS bytes,hex(content) AS hex FROM attachment;
-- DEFAULT дата
SELECT created_on,created_on=date('now') AS today FROM audit_log;
-- Версия SQLite
SELECT sqlite_version() AS version;
