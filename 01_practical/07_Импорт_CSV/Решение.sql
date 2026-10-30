PRAGMA foreign_keys=ON;
CREATE TABLE raw_product(name TEXT,price TEXT,category TEXT,source_date TEXT);
CREATE TABLE product(id INTEGER PRIMARY KEY,name TEXT NOT NULL,price REAL NOT NULL CHECK(price>=0),category TEXT NOT NULL,event_date TEXT NOT NULL);
-- Сначала импортируйте грязные_данные_10.csv в raw_product через DB Browser:
-- File → Import → Table from CSV, первая строка = имена столбцов; дату поместить в source_date.
-- Затем выполнить перенос и проверку:
INSERT INTO product(name,price,category,event_date)
SELECT TRIM(name),CAST(TRIM(price) AS REAL),LOWER(TRIM(category)),
       substr(source_date,7,4)||'-'||substr(source_date,4,2)||'-'||substr(source_date,1,2)
FROM raw_product
WHERE TRIM(name)<>'' AND TRIM(price)<>'' AND CAST(TRIM(price) AS REAL)>=0
  AND source_date GLOB '[0-3][0-9].[0-1][0-9].[1-2][0-9][0-9][0-9]';
-- Искомые некорректные строки:
SELECT * FROM raw_product WHERE TRIM(name)='' OR TRIM(price)='' OR CAST(TRIM(price) AS REAL)<0;
DROP TABLE raw_product;
SELECT COUNT(*) AS imported_count FROM product;
