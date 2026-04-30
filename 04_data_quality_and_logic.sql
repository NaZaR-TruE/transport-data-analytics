-- 1. Детектор "переливов": Поиск заправок, превышающих техническую емкость бака
SELECT f.trip_id, v.vehicle_name, f.fuel_liters, 'Внимание: Объем заправки подозрительно высок' as alert_type
FROM fuel_trips f
JOIN vehicles v ON f.vehicle_id = v.vehicle_id
WHERE f.fuel_liters > 150; -- Условный лимит бака


-- 2. Проверка логической целостности: Рейсы с пробегом, но без расхода топлива
SELECT trip_id, vehicle_id, distance_km, fuel_liters
FROM fuel_trips 
WHERE distance_km > 0 AND fuel_liters <= 0;


-- 3. Детектор дублей: Поиск идентичных записей в одну дату по одной машине
SELECT vehicle_id, fuel_date, distance_km, COUNT(*) as duplicate_count
FROM fuel_trips
GROUP BY vehicle_id, fuel_date, distance_km
HAVING COUNT(*) > 1;


-- 4. Поиск пропусков в мастер-данных (NULL check)
SELECT COUNT(*) as records_with_errors
FROM fuel_trips
WHERE vehicle_id IS NULL OR fuel_date IS NULL OR fuel_liters IS NULL;
