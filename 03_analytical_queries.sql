-- 1. Эффективность транспорта: выручка на 1 км пути
SELECT 
    v.reg_number, 
    v.model,
    ROUND(SUM(t.revenue) / SUM(t.distance_km), 2) AS revenue_per_km
FROM vehicles v
JOIN trips t ON v.vehicle_id = t.vehicle_id
GROUP BY v.reg_number, v.model;

-- 2. Расчет чистой прибыли по каждому рейсу
SELECT 
    trip_id, 
    trip_date, 
    (revenue - fuel_cost) AS net_profit
FROM trips
ORDER BY net_profit DESC;

-- 3. Поиск маршрутов без активности (для контроля Минтранса)
-- (Пример логики поиска простоев)
SELECT v.reg_number, v.model
FROM vehicles v
LEFT JOIN trips t ON v.vehicle_id = t.vehicle_id AND t.trip_date > CURRENT_DATE - INTERVAL '7 days'
WHERE t.trip_id IS NULL;