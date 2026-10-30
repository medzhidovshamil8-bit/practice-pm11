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

-- 1 INNER
SELECT p.name,c.name AS category FROM product p INNER JOIN category c ON p.category_id=c.id ORDER BY p.id;

-- 2 Все категории LEFT
SELECT c.name,COUNT(p.id) AS n FROM category c LEFT JOIN product p ON p.category_id=c.id GROUP BY c.id ORDER BY c.id;

-- 3 Без категории
SELECT p.name FROM product p LEFT JOIN category c ON p.category_id=c.id WHERE c.id IS NULL ORDER BY p.id;

-- 4 Количество по категориям
SELECT c.name,COUNT(p.id) AS n FROM category c LEFT JOIN product p ON p.category_id=c.id GROUP BY c.id ORDER BY c.id;

-- 5 FULL
SELECT p.name,c.name AS category FROM product p FULL JOIN category c ON p.category_id=c.id ORDER BY c.id,p.id;

-- 6 Категории без товаров
SELECT c.name FROM category c LEFT JOIN product p ON p.category_id=c.id WHERE p.id IS NULL ORDER BY c.id;

-- 7 Три таблицы
SELECT p.name,c.name AS category,s.name AS supplier FROM product p JOIN category c ON p.category_id=c.id JOIN supplier s ON p.supplier_id=s.id ORDER BY p.id;

-- 8 Категория на Е
SELECT p.name FROM product p JOIN category c ON p.category_id=c.id WHERE c.name LIKE 'Е%' ORDER BY p.id;

-- 9 Пары в одной категории
SELECT a.name AS first_product,b.name AS second_product FROM product a JOIN product b ON a.category_id=b.category_id AND a.id<b.id ORDER BY a.id,b.id;

-- Доп RIGHT через LEFT
SELECT c.name,p.name FROM category c LEFT JOIN product p ON p.category_id=c.id ORDER BY c.id,p.id;
