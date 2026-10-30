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

-- 1 Товары дороже 100
SELECT name,price FROM product WHERE price>100 ORDER BY id;

-- 2 Диапазон 50–200
SELECT name,price FROM product WHERE price BETWEEN 50 AND 200 ORDER BY id;

-- 3 Начинаются на Х
SELECT name FROM product WHERE name LIKE 'Х%' ORDER BY id;

-- 4 Без категории
SELECT name FROM product WHERE category_id IS NULL;

-- 5 По цене убывание
SELECT name,price FROM product ORDER BY price DESC,name;

-- 6 Первые три
SELECT name FROM product ORDER BY id LIMIT 3;

-- 7 Цена оканчивается нулем
SELECT name,price FROM product WHERE CAST(price AS INTEGER)%10=0 ORDER BY id;

-- 8 Содержат о
SELECT name FROM product WHERE name LIKE '%о%' ORDER BY id;

-- 9 Выше средней и с категорией
SELECT name,price FROM product WHERE price>(SELECT AVG(price) FROM product) AND category_id IS NOT NULL ORDER BY price DESC LIMIT 5;

-- Доп LOWER
SELECT name FROM product WHERE LOWER(name) LIKE 'м%' ORDER BY id;
