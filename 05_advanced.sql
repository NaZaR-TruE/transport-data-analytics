-- 1. Расчет разницы в литрах между текущей и предыдущей заправкой (Функция LAG)
-- Позволяет мгновенно увидеть резкие скачки потребления в рамках одной машины.
SELECT 
    vehicle_id,
    fuel_date,
    fuel_liters,
    LAG(fuel_liters) OVER(PARTITION BY vehicle_id ORDER BY fuel_date) as previous_refill,
    fuel_liters - LAG(fuel_liters) OVER(PARTITION BY vehicle_id ORDER BY fuel_date) as fuel_change
FROM fuel_trips;


-- 2. Ранжирование водителей по экономичности (Функция DENSE_RANK)
-- Присваивает места: кто возит грузы с наименьшим удельным расходом.
SELECT 
    vehicle_id,
    AVG(fuel_liters / distance_km * 100) as avg_consumption,
    DENSE_RANK() OVER(ORDER BY AVG(fuel_liters / distance_km * 100) ASC) as efficiency_rating
FROM fuel_trips
WHERE distance_km > 0
GROUP BY vehicle_id;


-- 3. Накопительный итог расхода ГСМ по месяцам (Функция SUM OVER)
-- Позволяет отслеживать исполнение бюджета подразделения в реальном времени.
SELECT 
    fuel_date,
    fuel_liters,
    SUM(fuel_liters) OVER(ORDER BY fuel_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as cumulative_total
FROM fuel_trips;


-- 4. Использование ПОДЗАПРОСОВ (Subqueries)
-- Задача: Найти рейсы, расход в которых выше среднего расхода ПО ВСЕМУ автопарку.
SELECT 
    trip_id,
    vehicle_id,
    fuel_liters
FROM fuel_trips
WHERE fuel_liters > (
    -- Внутренний подзапрос: вычисляет среднее значение
    SELECT AVG(fuel_liters) 
    FROM fuel_trips
);
