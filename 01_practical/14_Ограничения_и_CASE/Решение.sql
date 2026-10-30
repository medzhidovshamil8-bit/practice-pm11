PRAGMA foreign_keys=ON;
CREATE TABLE product(id INTEGER PRIMARY KEY,name TEXT NOT NULL UNIQUE,price REAL NOT NULL DEFAULT 0 CHECK(price>=0),category_id INTEGER,discount REAL);
INSERT INTO product(id,name,price,category_id,discount) VALUES(1,'Хлеб',40,1,NULL),(2,'Мыло',80,NULL,10),(3,'Сыр',200,1,20),(4,'Вода',0,NULL,NULL);
INSERT INTO product(id,name) VALUES(5,'Товар по умолчанию');
-- Фактические тесты отрицательной цены и дубликата имени выполнены через rollback; см. Проверка_ограничений.json.

-- 3 Дорого/дешево
SELECT name,CASE WHEN price>100 THEN 'дорого' ELSE 'дёшево' END AS label FROM product ORDER BY id;

-- 4 COALESCE категории
SELECT name,COALESCE(category_id,0) AS category_id FROM product ORDER BY id;

-- 5 NULLIF
SELECT name,ROUND(100.0/NULLIF(price,0),2) AS ratio FROM product ORDER BY id;

-- 6 DEFAULT
SELECT name,price FROM product WHERE id=5;

-- 7 Три градации
SELECT name,price,CASE WHEN price<50 THEN 'дёшево' WHEN price<=100 THEN 'средне' ELSE 'дорого' END AS label FROM product ORDER BY id;

-- 8 Два COALESCE
SELECT name,COALESCE(price,0)+COALESCE(discount,0) AS sum_value FROM product ORDER BY id;

-- 9 CASE ORDER BY
SELECT name,price FROM product ORDER BY CASE WHEN price>100 THEN 1 WHEN price>=50 THEN 2 ELSE 3 END,price DESC;

-- Прогноз COALESCE
SELECT COALESCE(NULL,NULL,5) AS result;
