/* 
ФАЙЛ 05: ПРОДВИНУТАЯ АНАЛИТИКА (WINDOW FUNCTIONS & KPI)
Цель: Анализ динамики потребления и дисциплины маршрутов.
*/
-- 1. АНАЛИЗ ДИНАМИКИ ЗАТРАТ НА ГСМ (LAG)
-- Сравниваем стоимость заправки текущего рейса с предыдущим по той же машине.
SELECT 
    vehicle_id,
    trip_date,
    fuel_cost,
    LAG(fuel_cost) OVER(PARTITION BY vehicle_id ORDER BY trip_date) as prev_trip_cost,
    ROUND(fuel_cost - LAG(fuel_cost) OVER(PARTITION BY vehicle_id ORDER BY trip_date), 2) as delta_cost
FROM trips;


-- 2. РЕЙТИНГ ВОДИТЕЛЕЙ ПО ЭФФЕКТИВНОСТИ (DENSE_RANK)
-- Кто тратит меньше денег на 100 км пробега.
SELECT 
    driver_id,
    ROUND(AVG(fuel_cost / distance_km * 100), 2) as avg_cost_100km,
    DENSE_RANK() OVER(ORDER BY AVG(fuel_cost / distance_km * 100) ASC) as rank_position
FROM trips
WHERE distance_km > 0
GROUP BY driver_id;


-- 3. НАКОПИТЕЛЬНЫЙ ИТОГ ЗАТРАТ (SUM OVER)
-- Считаем, как рос общий расход бюджета на ГСМ в хронологическом порядке.
SELECT 
    trip_date,
    fuel_cost,
    SUM(fuel_cost) OVER(ORDER BY trip_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as running_total_cost
FROM trips;


-- 4. ПОДЗАПРОС: РЕЙСЫ С ЗАТРАТАМИ ВЫШЕ СРЕДНЕГО
-- Выделяем поездки, которые обошлись дороже, чем средний показатель по всему парку.
SELECT 
    trip_id, 
    vehicle_id, 
    fuel_cost
FROM trips
WHERE fuel_cost > (SELECT AVG(fuel_cost) FROM trips);
