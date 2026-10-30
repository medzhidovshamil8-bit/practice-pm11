PRAGMA foreign_keys=ON;
CREATE TABLE category(id INTEGER PRIMARY KEY,name TEXT NOT NULL UNIQUE);
CREATE TABLE product(id INTEGER PRIMARY KEY,name TEXT NOT NULL,price REAL NOT NULL CHECK(price>0),category_id INTEGER NOT NULL REFERENCES category(id));
CREATE TABLE supplier(id INTEGER PRIMARY KEY,name TEXT NOT NULL,phone TEXT UNIQUE,email TEXT UNIQUE);
CREATE TABLE shipment(id INTEGER PRIMARY KEY,product_id INTEGER NOT NULL REFERENCES product(id),supplier_id INTEGER NOT NULL REFERENCES supplier(id),quantity INTEGER NOT NULL CHECK(quantity>0),shipment_date TEXT NOT NULL DEFAULT CURRENT_DATE,UNIQUE(product_id,supplier_id));
CREATE TABLE dated_event(id INTEGER PRIMARY KEY,event_date TEXT NOT NULL CHECK(event_date>='2020-01-01'));
INSERT INTO category VALUES (1,'Еда'),(2,'Быт');
INSERT INTO product VALUES (1,'Хлеб',40,1),(2,'Мыло',80,2);
INSERT INTO supplier VALUES (1,'Поставщик Еды','111','food@example.test'),(2,'Поставщик Быта','222','home@example.test');
INSERT INTO shipment(id,product_id,supplier_id,quantity) VALUES (1,1,1,10),(2,2,2,8);
INSERT INTO dated_event VALUES(1,'2024-01-01');

-- Контрольные запросы см. Результаты.json.
