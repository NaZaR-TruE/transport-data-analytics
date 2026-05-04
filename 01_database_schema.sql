-- Файл проекта: Аналитика пассажирских перевозок. Логика «неизбежности учета»
-- Создание таблицы автопарка
CREATE TABLE vehicles (vehicle_id SERIAL PRIMARY KEY,
		       model VARCHAR(50) NOT NULL,
		       reg_number VARCHAR(15) UNIQUE NOT NULL,
		       consumption_rate DECIMAL(4,2) -- расход топлива на 100 км
		      );
-- Создание таблицы водителей
CREATE TABLE drivers (driver_id SERIAL PRIMARY KEY,
    		      full_name VARCHAR(100) NOT NULL,
    		      license_category VARCHAR(10),
   		      hire_date DATE DEFAULT CURRENT_DATE
		     );

-- Создание таблицы рейсов
CREATE TABLE trips (trip_id SERIAL PRIMARY KEY,
    		    vehicle_id INTEGER REFERENCES vehicles(vehicle_id),
		    driver_id INTEGER REFERENCES drivers(driver_id),
		    trip_date DATE NOT NULL,
		    distance_km DECIMAL(6,2),
		    revenue DECIMAL(10,2), -- выручка за рейс
		    fuel_cost DECIMAL(10,2) -- затраты на топливо
		   );
