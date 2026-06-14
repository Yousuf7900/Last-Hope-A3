CREATE DATABASE football_ticket_booking;

-- DROP TABLES IF THEY ALREADY EXIST TO PREVENT CONFLICTS
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Bookings;
DROP TABLE IF EXISTS Matches;

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