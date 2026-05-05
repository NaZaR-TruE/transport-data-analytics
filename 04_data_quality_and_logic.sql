/* 
ФАЙЛ 04: КОНТРОЛЬ КАЧЕСТВА ДАННЫХ И ВЫЯВЛЕНИЕ АНОМАЛИЙ (DATA QUALITY)
Цель: Поиск технических ошибок и выявление «скрытых потерь» (бегемотов).
*/

-- 1. ДЕТЕКТОР АНОМАЛЬНЫХ ЗАТРАТ (Вместо перелива бака)
-- Ищем рейсы, где затраты на топливо подозрительно высоки (например, более 5000 руб за рейс)
SELECT 
    t.trip_id, 
    v.model, 
    v.reg_number,
    t.fuel_cost,
    'Внимание: Затраты на ГСМ выше лимита' as alert_type
FROM trips t
JOIN vehicles v ON t.vehicle_id = v.vehicle_id
WHERE t.fuel_cost > 5000; 


-- 2. ДЕТЕКТОР "БЕГЕМОТОВ" (Анализ через стоимость 100 км пути)
-- Вычисляем стоимость ГСМ на 100 км. Если она резко выше нормы — это аномалия.
-- Предположим, средняя стоимость 100 км пути — 1200 руб. Ищем отклонения.
SELECT 
    v.model,
    v.reg_number,
    t.trip_date,
    ROUND((t.fuel_cost / t.distance_km) * 100, 2) as cost_per_100km
FROM trips t
JOIN vehicles v ON t.vehicle_id = v.vehicle_id
WHERE t.distance_km > 0 
  AND (t.fuel_cost / t.distance_km) * 100 > 1500; -- Порог аномалии в рублях


-- 3. ПРОВЕРКА ЛОГИЧЕСКОЙ ЦЕЛОСТНОСТИ
-- Рейсы с пробегом, но с нулевыми затратами на ГСМ (ошибка учета или "левая" заправка)
SELECT 
    trip_id, vehicle_id, distance_km, fuel_cost
FROM trips 
WHERE distance_km > 0 AND fuel_cost <= 0;


-- 4. ДЕТЕКТОР ДУБЛЕЙ
-- Поиск идентичных записей по машине и дате
SELECT 
    vehicle_id, trip_date, distance_km, COUNT(*) as duplicate_count
FROM trips
GROUP BY vehicle_id, trip_date, distance_km
HAVING COUNT(*) > 1;
