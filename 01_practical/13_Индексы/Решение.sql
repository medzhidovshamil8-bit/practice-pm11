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

CREATE INDEX idx_product_price ON product(price);
CREATE INDEX idx_product_name ON product(name);
CREATE INDEX idx_product_category_price ON product(category_id,price);
CREATE INDEX idx_product_temporary ON product(supplier_id);
DROP INDEX idx_product_temporary;
CREATE UNIQUE INDEX idx_product_unique_name ON product(name);
CREATE INDEX idx_product_name_category ON product(name,category_id);
CREATE INDEX idx_product_lower_name ON product(LOWER(name));
EXPLAIN QUERY PLAN SELECT id,price FROM product WHERE price>100;
EXPLAIN QUERY PLAN SELECT id FROM product WHERE LOWER(name)='хлеб';
