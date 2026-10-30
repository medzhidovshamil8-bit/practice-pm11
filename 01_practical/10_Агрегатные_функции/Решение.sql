PRAGMA foreign_keys=ON;
CREATE TABLE category(id INTEGER PRIMARY KEY,name TEXT NOT NULL UNIQUE);
CREATE TABLE supplier(id INTEGER PRIMARY KEY,name TEXT NOT NULL);
CREATE TABLE product(id INTEGER PRIMARY KEY,name TEXT NOT NULL,price REAL NOT NULL CHECK(price>=0),category_id INTEGER REFERENCES category(id),supplier_id INTEGER REFERENCES supplier(id),discount REAL);
INSERT INTO category VALUES(1,'Еда'),(2,'Быт'),(3,'Напитки'),(4,'Книги'),(5,'Канцелярия');
INSERT INTO supplier VALUES(1,'Продуктовый'),(2,'Хозтовары'),(3,'Прочее');
INSERT INTO product VALUES
(1,'Хлеб',40,1,1,NULL),(2,'Молоко',60,1,1,5),(3,'Сыр',200,1,1,NULL),
(4,'Мыло',80,2,2,10),(5,'Порошок',180,2,2,15),(6,'Чай',120,3,1,NULL),
(7,'Кофе',350,3,1,20),(8,'Морковь',30,1,1,NULL),(9,'Блокнот',90,NULL,3,NULL),
(10,'Масло',150,1,1,10);

-- 1 Количество
SELECT COUNT(*) AS total FROM product;

-- 2 Средняя цена
SELECT ROUND(AVG(price),2) AS average_price FROM product;

-- 3 Количество по категориям
SELECT c.name,COUNT(p.id) AS n FROM category c LEFT JOIN product p ON p.category_id=c.id GROUP BY c.id ORDER BY c.id;

-- 4 Сумма по категориям
SELECT c.name,COALESCE(SUM(p.price),0) AS sum_price FROM category c LEFT JOIN product p ON p.category_id=c.id GROUP BY c.id ORDER BY c.id;

-- 5 Больше двух
SELECT c.name,COUNT(p.id) AS n FROM category c JOIN product p ON p.category_id=c.id GROUP BY c.id HAVING COUNT(*)>2;

-- 6 Мин и макс
SELECT MIN(price) AS min_price,MAX(price) AS max_price FROM product;

-- 7 Средняя выше 100
SELECT c.name,ROUND(AVG(p.price),2) AS avg_price FROM category c JOIN product p ON p.category_id=c.id GROUP BY c.id HAVING AVG(p.price)>100 ORDER BY c.id;

-- 8 Выше средней
SELECT name,price FROM product WHERE price>(SELECT AVG(price) FROM product) ORDER BY id;

-- 9 Сводка
SELECT c.name,COUNT(p.id) AS n,ROUND(AVG(p.price),2) AS avg_price,MAX(p.price) AS max_price FROM category c LEFT JOIN product p ON p.category_id=c.id GROUP BY c.id ORDER BY avg_price DESC NULLS LAST;

-- Доп DISTINCT
SELECT COUNT(DISTINCT category_id) AS n FROM product;
