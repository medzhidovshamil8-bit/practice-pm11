-- Q01. Каталог туров с направлениями
SELECT t.tour_id,t.name,d.country,d.city,t.nights FROM tour t JOIN destination d USING(destination_id) ORDER BY t.tour_id;

-- Q02. Выезды ноября по цене
SELECT departure_id,start_date,price_kopecks/100.0 AS price_rub FROM departure WHERE start_date BETWEEN '2026-11-01' AND '2026-11-30' ORDER BY price_kopecks,departure_id;

-- Q03. Клиенты без электронной почты
SELECT client_id,full_name,phone FROM client WHERE email IS NULL ORDER BY client_id;

-- Q04. Три самых дорогих выезда
SELECT departure_id,price_kopecks/100.0 AS price_rub FROM departure ORDER BY price_kopecks DESC,departure_id LIMIT 3;

-- Q05. Количество и стоимость активных бронирований
SELECT COUNT(*) AS bookings,SUM(tourists) AS tourists,SUM(total_kopecks)/100.0 AS contract_rub FROM booking WHERE status<>'cancelled';

-- Q06. Продажи по сотрудникам включая нулевые
SELECT e.employee_id,e.full_name,COUNT(b.booking_id) AS bookings,COALESCE(SUM(b.total_kopecks),0)/100.0 AS contract_rub FROM employee e LEFT JOIN booking b ON b.employee_id=e.employee_id AND b.status<>'cancelled' GROUP BY e.employee_id,e.full_name ORDER BY e.employee_id;

-- Q07. Повторные клиенты
SELECT c.client_id,c.full_name,COUNT(*) AS bookings FROM client c JOIN booking b USING(client_id) WHERE b.status<>'cancelled' GROUP BY c.client_id,c.full_name HAVING COUNT(*)>=2 ORDER BY c.client_id;

-- Q08. Подробности бронирований
SELECT b.booking_id,c.full_name AS client,e.full_name AS manager,t.name,d.start_date,b.status,b.total_kopecks/100.0 AS total_rub FROM booking b JOIN client c USING(client_id) JOIN employee e USING(employee_id) JOIN departure d USING(departure_id) JOIN tour t USING(tour_id) ORDER BY b.booking_id;

-- Q09. Остатки к оплате без удвоения сумм
WITH paid AS (SELECT booking_id,SUM(amount_kopecks) AS amount FROM payment GROUP BY booking_id) SELECT b.booking_id,b.total_kopecks/100.0 AS contract_rub,COALESCE(p.amount,0)/100.0 AS paid_rub,(b.total_kopecks-COALESCE(p.amount,0))/100.0 AS debt_rub FROM booking b LEFT JOIN paid p USING(booking_id) WHERE b.status<>'cancelled' ORDER BY b.booking_id;

-- Q10. Выезды дороже средней цены
SELECT departure_id,price_kopecks/100.0 AS price_rub FROM departure WHERE price_kopecks>(SELECT AVG(price_kopecks) FROM departure) ORDER BY departure_id;

-- Q11. Клиенты без бронирований
SELECT c.client_id,c.full_name FROM client c WHERE NOT EXISTS(SELECT 1 FROM booking b WHERE b.client_id=c.client_id) ORDER BY c.client_id;

-- Q12. Выезды без активных бронирований
SELECT d.departure_id,t.name,d.start_date FROM departure d JOIN tour t USING(tour_id) WHERE NOT EXISTS(SELECT 1 FROM booking b WHERE b.departure_id=d.departure_id AND b.status<>'cancelled') ORDER BY d.departure_id;

-- Q13. Поступления по способам оплаты
SELECT method,COUNT(*) AS payments,SUM(amount_kopecks)/100.0 AS paid_rub FROM payment GROUP BY method ORDER BY method;

-- Q14. Загрузка выездов и свободные места
SELECT d.departure_id,d.capacity,COALESCE(SUM(b.tourists),0) AS reserved,d.capacity-COALESCE(SUM(b.tourists),0) AS available FROM departure d LEFT JOIN booking b ON b.departure_id=d.departure_id AND b.status<>'cancelled' GROUP BY d.departure_id,d.capacity ORDER BY d.departure_id;

-- Q15. Классификация оплаты через CASE
WITH paid AS (SELECT booking_id,SUM(amount_kopecks) AS amount FROM payment GROUP BY booking_id) SELECT b.booking_id,CASE WHEN COALESCE(p.amount,0)=0 THEN 'Не оплачено' WHEN p.amount<b.total_kopecks THEN 'Частично' WHEN p.amount=b.total_kopecks THEN 'Оплачено' ELSE 'Переплата' END AS payment_state FROM booking b LEFT JOIN paid p USING(booking_id) WHERE b.status<>'cancelled' ORDER BY b.booking_id;
