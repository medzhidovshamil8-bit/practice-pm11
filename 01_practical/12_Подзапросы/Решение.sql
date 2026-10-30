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

-- 1 Дороже средней
SELECT name,price FROM product WHERE price>(SELECT AVG(price) FROM product) ORDER BY id;

-- 2 Еда через IN
SELECT name FROM product WHERE category_id IN (SELECT id FROM category WHERE name='Еда') ORDER BY id;

-- 3 Есть товары
SELECT name FROM category c WHERE EXISTS(SELECT 1 FROM product p WHERE p.category_id=c.id) ORDER BY id;

-- 4 Нет товаров
SELECT name FROM category c WHERE NOT EXISTS(SELECT 1 FROM product p WHERE p.category_id=c.id) ORDER BY id;

-- 5 Самая дорогая
SELECT name,price FROM product WHERE price=(SELECT MAX(price) FROM product);

-- 6 Выше средней своей категории
SELECT p.name,p.price FROM product p WHERE p.category_id IS NOT NULL AND p.price>(SELECT AVG(q.price) FROM product q WHERE q.category_id=p.category_id) ORDER BY p.id;

-- 7 Выше max категории 2
SELECT name,price FROM product WHERE price>(SELECT MAX(price) FROM product WHERE category_id=2) ORDER BY id;

-- 8 Категории со средней >100
SELECT c.name FROM category c WHERE (SELECT AVG(p.price) FROM product p WHERE p.category_id=c.id)>100 ORDER BY c.id;

-- Доп два CTE
WITH a AS(SELECT category_id,AVG(price) AS avg_p FROM product GROUP BY category_id),m AS(SELECT category_id,MAX(price) AS max_p FROM product GROUP BY category_id) SELECT c.name,ROUND(a.avg_p,2),m.max_p FROM category c JOIN a ON a.category_id=c.id JOIN m ON m.category_id=c.id ORDER BY c.id;
