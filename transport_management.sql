DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS cancellations;
DROP TABLE IF EXISTS trip_seat_allocations;
DROP TABLE IF EXISTS seats;
DROP TABLE IF EXISTS maintenance_logs;
DROP TABLE IF EXISTS fares;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS passengers;
DROP TABLE IF EXISTS trips;
DROP TABLE IF EXISTS vehicles;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS routes;
DROP TABLE IF EXISTS locations;
DROP TABLE IF EXISTS operators;
DROP TABLE IF EXISTS vehicle_types;

CREATE TABLE vehicle_types (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(20) NOT NULL UNIQUE,
    description VARCHAR(100)
);

CREATE TABLE operators (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    contact_phone VARCHAR(20),
    contact_email VARCHAR(100),
    address VARCHAR(255)
);

CREATE TABLE staff (
    id INT AUTO_INCREMENT PRIMARY KEY,
    operator_id INT NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    role ENUM('DRIVER','ATTENDANT','MECHANIC','ADMIN') NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    license_no VARCHAR(50),
    status ENUM('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
    FOREIGN KEY (operator_id) REFERENCES operators(id) ON DELETE CASCADE
);

CREATE TABLE locations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    city VARCHAR(100),
    state VARCHAR(100),
    UNIQUE (name, city)
);

CREATE TABLE routes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(30) NOT NULL UNIQUE,
    origin_location_id INT NOT NULL,
    dest_location_id INT NOT NULL,
    distance_km DECIMAL(6,2) DEFAULT 0.00,
    estimated_time_minutes INT DEFAULT 0,
    CHECK (origin_location_id <> dest_location_id),
    FOREIGN KEY (origin_location_id) REFERENCES locations(id) ON DELETE RESTRICT,
    FOREIGN KEY (dest_location_id) REFERENCES locations(id) ON DELETE RESTRICT
);

CREATE TABLE vehicles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_no VARCHAR(50) NOT NULL UNIQUE,
    type_id INT NOT NULL,
    operator_id INT NOT NULL,
    capacity INT NOT NULL CHECK (capacity > 0),
    model VARCHAR(100),
    year SMALLINT,
    status ENUM('ACTIVE','IN_SERVICE','MAINTENANCE','RETIRED') DEFAULT 'ACTIVE',
    license_details VARCHAR(255),
    FOREIGN KEY (type_id) REFERENCES vehicle_types(id) ON DELETE RESTRICT,
    FOREIGN KEY (operator_id) REFERENCES operators(id) ON DELETE CASCADE
);

CREATE TABLE maintenance_logs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    vehicle_id INT NOT NULL,
    staff_id INT,
    maintenance_date DATE NOT NULL,
    description TEXT,
    cost DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES staff(id) ON DELETE SET NULL
);

CREATE TABLE seats (
    id INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_id INT NOT NULL,
    seat_no VARCHAR(10) NOT NULL,
    seat_type ENUM('REGULAR','WINDOW','AISLE','PREMIUM') DEFAULT 'REGULAR',
    UNIQUE (vehicle_id, seat_no),
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE
);

CREATE TABLE trips (
    id INT AUTO_INCREMENT PRIMARY KEY,
    route_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    staff_driver_id INT,
    departure_datetime DATETIME NOT NULL,
    arrival_datetime DATETIME,
    base_fare DECIMAL(9,2) NOT NULL CHECK (base_fare >= 0),
    seats_available INT NOT NULL CHECK (seats_available >= 0),
    status ENUM('SCHEDULED','ONGOING','COMPLETED','CANCELLED') DEFAULT 'SCHEDULED',
    UNIQUE (vehicle_id, departure_datetime),
    FOREIGN KEY (route_id) REFERENCES routes(id) ON DELETE RESTRICT,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE RESTRICT,
    FOREIGN KEY (staff_driver_id) REFERENCES staff(id) ON DELETE SET NULL
);

CREATE TABLE fares (
    id INT AUTO_INCREMENT PRIMARY KEY,
    route_id INT NOT NULL,
    vehicle_type_id INT NOT NULL,
    base_rate DECIMAL(10,2) NOT NULL,
    surge_multiplier DECIMAL(4,2) DEFAULT 1.00,
    effective_from DATE NOT NULL,
    effective_to DATE,
    FOREIGN KEY (route_id) REFERENCES routes(id),
    FOREIGN KEY (vehicle_type_id) REFERENCES vehicle_types(id)
);

CREATE TABLE passengers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE bookings (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    trip_id INT NOT NULL,
    passenger_id INT NOT NULL,
    booking_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    seats_booked INT NOT NULL CHECK (seats_booked > 0),
    total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0),
    status ENUM('CONFIRMED','PENDING','CANCELLED','REFUNDED') DEFAULT 'PENDING',
    reference_no VARCHAR(50) NOT NULL UNIQUE,
    FOREIGN KEY (trip_id) REFERENCES trips(id) ON DELETE CASCADE,
    FOREIGN KEY (passenger_id) REFERENCES passengers(id) ON DELETE CASCADE
);

CREATE TABLE trip_seat_allocations (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    booking_id BIGINT NOT NULL,
    seat_id INT NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE,
    FOREIGN KEY (seat_id) REFERENCES seats(id) ON DELETE CASCADE,
    UNIQUE (booking_id, seat_id)
);

CREATE TABLE cancellations (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    booking_id BIGINT NOT NULL,
    cancelled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reason VARCHAR(255),
    refund_amount DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE
);

CREATE TABLE payments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    booking_id BIGINT NOT NULL,
    paid_amount DECIMAL(10,2) NOT NULL CHECK (paid_amount >= 0),
    paid_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('CASH','CARD','UPI','WALLET','NETBANKING') DEFAULT 'CARD',
    payment_status ENUM('SUCCESS','FAILED','PENDING') DEFAULT 'SUCCESS',
    transaction_id VARCHAR(100),
    FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE
);

CREATE TABLE reviews (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    booking_id BIGINT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comments TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE
);

INSERT INTO vehicle_types (code, description) VALUES
('BUS','Large passenger bus'),
('CAB','Taxi / cab'),
('VAN','Passenger van');

INSERT INTO operators (name, contact_phone, contact_email) VALUES
('GreenField Transports','+911234567890','info@greenfield.example'),
('QuickCabs Pvt Ltd','+919876543210','support@quickcabs.example');

INSERT INTO locations (name, city, state) VALUES
('Central Bus Station','Pune','Maharashtra'),
('Airport Terminal','Pune','Maharashtra'),
('Main City Square','Mumbai','Maharashtra');

INSERT INTO routes (code, origin_location_id, dest_location_id, distance_km, estimated_time_minutes)
VALUES
('PUN_MUM_01', 1, 3, 150.50, 180),
('PUN_AIR_01', 1, 2, 20.00, 40);

INSERT INTO vehicles (vehicle_no, type_id, operator_id, capacity, model, year)
VALUES ('MH12AB1234', 1, 1, 45, 'Volvo B11R', 2018);

INSERT INTO trips (route_id, vehicle_id, departure_datetime, arrival_datetime, base_fare, seats_available)
VALUES (1, 1, '2025-11-20 06:00:00', '2025-11-20 09:00:00', 599.00, 45);
