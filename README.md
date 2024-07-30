# SQL_project
Аналитический проект из ad-hoc запросов к базе данных с данными об авиаперевозках.

Cписок задач:

1. Вывести название самолетов, которые имеют менее 50 посадочных мест?
2. Вывести процентное изменение ежемесячной суммы бронирования билетов, округленной до сотых.
3. Вывести названия самолетов не имеющих бизнес - класс. Решение должно быть через функцию array_agg.
4. Вывести количество рейсов со статусом "Вылетел"/"Departed". Используйте функцию Filter с условием для лучшей читаемости кода запроса к БД.
5. Найти процентное соотношение перелетов по маршрутам от общего количества перелетов.
 Выведите в результат названия аэропортов и процентное отношение.
 Решение должно быть через оконную функцию.
6. Выведите количество пассажиров по каждому коду сотового оператора, если учесть, что код оператора - это три символа после +7
7. Классифицируйте финансовые обороты (сумма стоимости перелетов) по маршрутам:
 До 50 млн - low
 От 50 млн включительно до 150 млн - middle
 От 150 млн включительно - high
 Выведите в результат количество маршрутов в каждом полученном классе
8. Вычислите медиану стоимости перелетов, медиану размера бронирования и отношение медианы бронирования к медиане стоимости перелетов, округленной до сотых

Пояснения:

Перелет, рейс - разовое перемещение самолета из аэропорта А в аэропорт Б.
Маршрут - формируется двумя аэропортами А и Б. При этом А - Б и Б - А - это разные маршруты.

![ER-diagram bookings](https://github.com/user-attachments/assets/558d09a2-f2a3-4117-9312-ddd19a0ce9b8)
