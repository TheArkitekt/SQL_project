SET SEARCH_path TO bookings

/*
*                       Задача 1
* Выведите названия самолётов, которые имеют менее 50 посадочных мест.
*/
SELECT a.model
FROM seats s
JOIN aircrafts a ON a.aircraft_code = s.aircraft_code 
GROUP BY a.aircraft_code
HAVING count(s.seat_no) < 50

/*
*  Задача 2
* Выведите процентное изменение ежемесячной суммы бронирования билетов, округленной до сотых.
*/
SELECT book_date,  book_sum, lag(book_sum) OVER(),
    round((book_sum - lag(book_sum) OVER(ORDER BY book_date)) / lag(book_sum) OVER(ORDER BY book_date) * 100, 2) AS percent_change
FROM (SELECT date_trunc('month', book_date) AS book_date,
sum(total_amount) AS book_sum
FROM bookings
GROUP BY date_trunc('month', book_date)) sums 



/*
*                       Задача 3
* Выведите названия самолётов без бизнес-класса. 
* Используйте в решении функцию array_agg.
*/

WITH cte AS (SELECT array_agg(DISTINCT s.aircraft_code)  code  --находим самолеты с бизнесом
		FROM seats s
		JOIN aircrafts a ON a.aircraft_code = s.aircraft_code
		WHERE fare_conditions = 'Business'),
		cte2 AS (SELECT ai.model
				FROM aircrafts ai
				WHERE ai.aircraft_code NOT IN (SELECT UNNEST(code) FROM cte)) 
SELECT *
FROM cte2


/*
 *                            Задача 4
 * Вывести количество рейсов со статусом "Вылетел"/"Departed". Используйте функцию 
 * Filter с условием для лучшей читаемости кода запроса к БД.
 */

SELECT count(flight_no) FILTER (WHERE status='Departed')
FROM flights
		
		
						  
/*
*                       Задача 5
* Найдите процентное соотношение перелётов по маршрутам от общего количества перелётов. 
* Выведите в результат названия аэропортов и процентное отношение.
*Используйте в решении оконную функцию.
*/
WITH t1 AS (SELECT f.departure_airport_name || '-' || f.arrival_airport_name AS routes,
COUNT(flight_id) OVER (PARTITION BY f.departure_airport_name || '-' || f.arrival_airport_name) AS routes_count
FROM  flights_v f)
SELECT routes, round((routes_count / SUM(routes_count) OVER()) * 100, 2) AS ratio_of_the_total
FROM t1
GROUP BY routes, routes_count


/*
*                        Задача 6
**Выведите количество пассажиров по каждому коду сотового оператора. 
*Код оператора – это три символа после +7
*/
SELECT code, COUNT(passenger_id) 
FROM(SELECT passenger_id, substring(CAST(contact_data -> 'phone' AS text) FROM 4 FOR 3) AS code
		FROM tickets) t1
GROUP BY code	
		
		
/*
 *                       Задача 7
 * Классифицируйте финансовые обороты (сумму стоимости перелетов) по маршрутам:
●	до 50 млн – low
●	от 50 млн включительно до 150 млн – middle
●	от 150 млн включительно – high
Выведите в результат количество маршрутов в каждом полученном классе.
 */

WITH t_main AS (SELECT *, 
CASE 
	WHEN routes_sum < 50000000 THEN 'low'
	WHEN (routes_sum >= 50000000) AND (routes_sum < 150000000) THEN 'medium'
	WHEN routes_sum >= 150000000 THEN 'high'
END pay_category
FROM (SELECT DISTINCT f.departure_airport || '-' || f.arrival_airport AS routes,
SUM(tf.amount) AS routes_sum 
FROM  ticket_flights tf
JOIN flights f ON f.flight_id = tf.flight_id
GROUP BY f.departure_airport, f.arrival_airport) t2)
SELECT pay_category, count(*)
FROM t_main
GROUP BY pay_category
ORDER BY 2 DESC



/*
*                       Задача 8 
* Вычислите медиану стоимости перелетов, медиану стоимости бронирования
*  и отношение медианы бронирования к медиане стоимости перелетов, результат округлите до сотых. 
*/

SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY amount) AS median_flight,
(SELECT PERCENTILE_CONT (0.5) WITHIN GROUP (ORDER BY total_amount) FROM bookings) AS median_booking,
round(((SELECT PERCENTILE_CONT (0.5) WITHIN GROUP (ORDER BY total_amount) FROM bookings) /
				PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY amount))::numeric, 2) AS ratio
FROM ticket_flights tf

