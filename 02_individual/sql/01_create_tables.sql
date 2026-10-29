PRAGMA foreign_keys = ON;
BEGIN;
CREATE TABLE client (
 client_id INTEGER PRIMARY KEY,
 full_name TEXT NOT NULL CHECK(length(trim(full_name))>0),
 phone TEXT NOT NULL UNIQUE,
 email TEXT UNIQUE
) STRICT;
CREATE TABLE employee (
 employee_id INTEGER PRIMARY KEY,
 full_name TEXT NOT NULL,
 email TEXT NOT NULL UNIQUE
) STRICT;
CREATE TABLE tour_operator (
 operator_id INTEGER PRIMARY KEY,
 name TEXT NOT NULL UNIQUE,
 phone TEXT NOT NULL
) STRICT;
CREATE TABLE destination (
 destination_id INTEGER PRIMARY KEY,
 country TEXT NOT NULL,
 city TEXT NOT NULL,
 UNIQUE(country,city)
) STRICT;
CREATE TABLE tour (
 tour_id INTEGER PRIMARY KEY,
 operator_id INTEGER NOT NULL REFERENCES tour_operator(operator_id) ON DELETE RESTRICT,
 destination_id INTEGER NOT NULL REFERENCES destination(destination_id) ON DELETE RESTRICT,
 name TEXT NOT NULL,
 nights INTEGER NOT NULL CHECK(nights>0),
 UNIQUE(operator_id,name)
) STRICT;
CREATE TABLE departure (
 departure_id INTEGER PRIMARY KEY,
 tour_id INTEGER NOT NULL REFERENCES tour(tour_id) ON DELETE RESTRICT,
 start_date TEXT NOT NULL CHECK(date(start_date,'+0 days') IS NOT NULL AND date(start_date,'+0 days')=start_date),
 price_kopecks INTEGER NOT NULL CHECK(price_kopecks>0),
 capacity INTEGER NOT NULL CHECK(capacity>0),
 UNIQUE(tour_id,start_date)
) STRICT;
CREATE TABLE booking (
 booking_id INTEGER PRIMARY KEY,
 client_id INTEGER NOT NULL REFERENCES client(client_id) ON DELETE RESTRICT,
 employee_id INTEGER NOT NULL REFERENCES employee(employee_id) ON DELETE RESTRICT,
 departure_id INTEGER NOT NULL REFERENCES departure(departure_id) ON DELETE RESTRICT,
 booked_on TEXT NOT NULL CHECK(date(booked_on,'+0 days') IS NOT NULL AND date(booked_on,'+0 days')=booked_on),
 tourists INTEGER NOT NULL CHECK(tourists>0),
 total_kopecks INTEGER NOT NULL CHECK(total_kopecks>0),
 status TEXT NOT NULL DEFAULT 'new' CHECK(status IN ('new','confirmed','cancelled','completed'))
) STRICT;
CREATE TABLE payment (
 payment_id INTEGER PRIMARY KEY,
 booking_id INTEGER NOT NULL REFERENCES booking(booking_id) ON DELETE RESTRICT,
 paid_on TEXT NOT NULL CHECK(date(paid_on,'+0 days') IS NOT NULL AND date(paid_on,'+0 days')=paid_on),
 amount_kopecks INTEGER NOT NULL CHECK(amount_kopecks>0),
 method TEXT NOT NULL CHECK(method IN ('card','bank','cash')),
 reference TEXT NOT NULL UNIQUE
) STRICT;
COMMIT;
