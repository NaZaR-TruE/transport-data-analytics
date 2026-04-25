-- Наполнение данными для демонстрации
INSERT INTO vehicles (model, reg_number, consumption_rate) VALUES
('Mercedes-Benz Sprinter', 'А123БВ26', 11.5),
('Ford Transit', 'Е456ЁХ26', 12.0),
('Газель Next', 'О789РЖ26', 14.5);

INSERT INTO drivers (full_name, license_category, hire_date) VALUES
('Иванов Иван Иванович', 'D', '2020-05-15'),
('Петров Петр Петрович', 'D', '2021-02-10');

INSERT INTO trips (vehicle_id, driver_id, trip_date, distance_km, revenue, fuel_cost) VALUES
(1, 1, '2026-04-01', 350.0, 15000.0, 4200.0),
(2, 2, '2026-04-01', 420.0, 18500.0, 5100.0),
(1, 1, '2026-04-02', 310.0, 13200.0, 3800.0);