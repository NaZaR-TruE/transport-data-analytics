/* 
ФАЙЛ 04: КОНТРОЛЬ КАЧЕСТВА ДАННЫХ И ВЫЯВЛЕНИЕ АНОМАЛИЙ (DATA QUALITY)
Цель: Поиск технических ошибок и выявление «скрытых потерь» (бегемотов).
*/

-- 1. ДЕТЕКТОР "ПЕРЕЛИВОВ" И ФИЗИЧЕСКИХ ЛИМИТОВ
-- Ищем заправки, превышающие техническую емкость бака.
SELECT 
    f.trip_id, 
    v.vehicle_name, 
    f.fuel_liters,
    v.tank_capacity as limit_liters,
    'Внимание: Объем заправки превышает емкость бака' as alert_type
FROM fuel_trips f
JOIN vehicles v ON f.vehicle_id = v.vehicle_id
WHERE f.fuel_liters > v.tank_capacity; 


-- 2. ДЕТЕКТОР "БЕГЕМОТОВ" (Скрытые неисправности/Перерасход)
-- Ищем отклонение фактического расхода от нормы более чем на 15%.
-- Это выявляет забитые форсунки, свечи или "масложор".
SELECT 
    v.vehicle_name,
    f.fuel_date,
    v.consumption_rate as norm_rate,
    ROUND((f.fuel_liters / f.distance_km) * 100, 2) as actual_rate,
    ROUND(((f.fuel_liters / f.distance_km) * 100 - v.consumption_rate) / v.consumption_rate * 100, 1) as delta_percent
FROM fuel_trips f
JOIN vehicles v ON f.vehicle_id = v.vehicle_id
WHERE f.distance_km > 0 
  AND ((f.fuel_liters / f.distance_km) * 100 - v.consumption_rate) / v.consumption_rate * 100 > 15.0;


-- 3. ПРОВЕРКА ЛОГИЧЕСКОЙ ЦЕЛОСТНОСТИ
-- Рейсы с пробегом, но без расхода топлива (сбои датчиков).
SELECT 
    trip_id, vehicle_id, distance_km, fuel_liters
FROM fuel_trips 
WHERE distance_km > 0 AND fuel_liters <= 0;


-- 4. ДЕТЕКТОР ДУБЛЕЙ
-- Исключаем задвоение данных в финансовой отчетности.
SELECT 
    vehicle_id, fuel_date, distance_km, COUNT(*) as duplicate_count
FROM fuel_trips
GROUP BY vehicle_id, fuel_date, distance_km
HAVING COUNT(*) > 1;


-- 5. КОНТРОЛЬ МАСТЕР-ДАННЫХ (NULL check)
SELECT COUNT(*) as records_with_errors
FROM fuel_trips
WHERE vehicle_id IS NULL OR fuel_date IS NULL OR fuel_liters IS NULL;
