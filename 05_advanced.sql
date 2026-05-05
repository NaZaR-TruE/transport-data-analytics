/* 
ФАЙЛ 05: ПРОДВИНУТАЯ АНАЛИТИКА (WINDOW FUNCTIONS & KPI)
Цель: Анализ динамики потребления и дисциплины маршрутов.
*/

-- 1. АНАЛИЗ ДИНАМИКИ РАСХОДА (LAG)
-- Сравниваем расход текущего рейса с предыдущим по той же машине.
SELECT 
    vehicle_id,
    trip_date,
    fuel_consumed,
    LAG(fuel_consumed) OVER(PARTITION BY vehicle_id ORDER BY trip_date) as prev_fuel,
    fuel_consumed - LAG(fuel_consumed) OVER(PARTITION BY vehicle_id ORDER BY trip_date) as delta_fuel
FROM trips;


-- 2. РЕЙТИНГ ВОДИТЕЛЕЙ ПО ЭФФЕКТИВНОСТИ (DENSE_RANK)
-- Присваиваем места на основе среднего расхода на 100 км.
SELECT 
    driver_id,
    ROUND(AVG(fuel_consumed / distance_km * 100), 2) as avg_consumption,
    DENSE_RANK() OVER(ORDER BY AVG(fuel_consumed / distance_km * 100) ASC) as rank_position
FROM trips
WHERE distance_km > 0
GROUP BY driver_id;


-- 3. АНАЛИЗ ГРАФИКА ДВИЖЕНИЯ (Среднее время рейса)
-- Находим рейсы, которые длились дольше среднего по маршруту.
SELECT 
    trip_id,
    route_id,
    EXTRACT(EPOCH FROM (actual_end_time - actual_start_time))/60 as duration_min,
    AVG(EXTRACT(EPOCH FROM (actual_end_time - actual_start_time))/60) OVER(PARTITION BY route_id) as route_avg_min
FROM trips;


-- 4. ПОДЗАПРОС: ПОИСК АНОМАЛЬНО ДОРОГИХ РЕЙСОВ
-- Рейсы, затраты на ГСМ в которых выше среднего по всему автопарку.
SELECT 
    trip_id, vehicle_id, fuel_consumed
FROM trips
WHERE fuel_consumed > (SELECT AVG(fuel_consumed) FROM trips);
