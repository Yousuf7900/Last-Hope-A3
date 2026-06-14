-- CREATE DATABASE football_ticket_booking;

-- DROP TABLES IF THEY ALREADY EXIST TO PREVENT CONFLICTS
DROP TABLE IF EXISTS Bookings;
DROP TABLE IF EXISTS Matches;
DROP TABLE IF EXISTS Users;

-- 1. CREATE USERS TABLE
CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('Football Fan', 'Ticket Manager')),
    phone_number VARCHAR(20)
);

-- 2. CREATE MATCHES TABLE
CREATE TABLE Matches (
    match_id INT PRIMARY KEY,
    fixture VARCHAR(255) NOT NULL,
    tournament_category VARCHAR(100) NOT NULL,
    base_ticket_price NUMERIC(10, 2) NOT NULL CHECK (base_ticket_price >= 0),
    match_status VARCHAR(20) NOT NULL CHECK (match_status IN ('Available', 'Selling Fast', 'Sold Out', 'Postponed'))
);

-- 3. CREATE BOOKINGS TABLE
CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY,
    user_id INT NOT NULL REFERENCES Users(user_id),
    match_id INT NOT NULL REFERENCES Matches(match_id),
    seat_number VARCHAR(20),
    payment_status VARCHAR(20) CHECK (payment_status IN ('Pending', 'Confirmed', 'Cancelled', 'Refunded') OR payment_status IS NULL),
    total_cost NUMERIC(10,2) CHECK (total_cost >= 0)
);

-- Query 1 --
SELECT match_id, fixture, base_ticket_price FROM Matches WHERE tournament_category = 'Champions League' AND match_status = 'Available';

-- Query 2 --
SELECT user_id, full_name, email FROM Users WHERE full_name ILIKE 'Tanvir%' OR full_name ILIKE '%Haque%';

-- Query 3 --
SELECT booking_id, user_id, match_id, COALESCE (payment_status, 'Action Required') AS systematic_status FROM Bookings WHERE payment_status IS NULL;

-- Query 4 --
SELECT b.booking_id, u.full_name, m.fixture, b.total_cost FROM Bookings b INNER JOIN Users u ON b.user_id = u.user_id INNER JOIN Matches m ON b.match_id = m.match_id;

-- Query 5 --
SELECT u.user_id, u.full_name, b.booking_id FROM Users u LEFT JOIN Bookings b ON u.user_id = b.user_id;

-- Query 6 --
SELECT booking_id, match_id, total_cost FROM Bookings WHERE total_cost > (SELECT AVG(total_cost) FROM Bookings);

-- Query 7 --
SELECT match_id, fixture, base_ticket_price FROM Matches ORDER BY base_ticket_price DESC LIMIT 2 OFFSET 1;