-- Create Database
CREATE DATABASE IF NOT EXISTS local_business_review;
USE local_business_review;

-- Users Table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role ENUM('admin', 'business_owner', 'user') DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('active', 'inactive') DEFAULT 'active',
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_role (role)
);

-- Categories Table
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_category_name (category_name)
);

-- Businesses Table
CREATE TABLE businesses (
    business_id INT AUTO_INCREMENT PRIMARY KEY,
    business_name VARCHAR(200) NOT NULL,
    category_id INT,
    location VARCHAR(200) NOT NULL,
    address TEXT NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    description TEXT,
    owner_id INT NOT NULL,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE SET NULL,
    FOREIGN KEY (owner_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_business_name (business_name),
    INDEX idx_location (location),
    INDEX idx_status (status),
    INDEX idx_category (category_id)
);

-- Reviews Table
CREATE TABLE reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    business_id INT NOT NULL,
    user_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'approved',
    FOREIGN KEY (business_id) REFERENCES businesses(business_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_business (user_id, business_id),
    INDEX idx_business (business_id),
    INDEX idx_user (user_id),
    INDEX idx_status (status)
);

-- Insert Sample Data

-- Admin User (password: Admin123)
INSERT INTO users (username, password, email, full_name, role, status) VALUES
('admin', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'admin@localreview.com', 'System Administrator', 'admin', 'active'),
('john_doe', '5994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5', 'john@example.com', 'John Doe', 'business_owner', 'active'),
('jane_smith', '5994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5', 'jane@example.com', 'Jane Smith', 'user', 'active'),
('bob_wilson', '5994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5', 'bob@example.com', 'Bob Wilson', 'business_owner', 'active'),
('alice_brown', '5994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5', 'alice@example.com', 'Alice Brown', 'user', 'active');

-- Categories
INSERT INTO categories (category_name, description) VALUES
('Restaurant', 'Dining establishments, cafes, and eateries'),
('Shopping', 'Retail stores and shopping centers'),
('Services', 'Professional and personal services'),
('Healthcare', 'Medical facilities and health services'),
('Entertainment', 'Entertainment venues and activities'),
('Education', 'Educational institutions and training centers'),
('Automotive', 'Car services and automotive businesses'),
('Beauty & Spa', 'Beauty salons and spa services');

-- Businesses
INSERT INTO businesses (business_name, category_id, location, address, phone, email, description, owner_id, status) VALUES
('The Golden Fork', 1, 'New York', '123 Main Street, New York, NY 10001', '555-0101', 'info@goldenfork.com', 'Fine dining restaurant serving contemporary American cuisine with a focus on locally sourced ingredients.', 2, 'approved'),
('Tech Haven', 2, 'San Francisco', '456 Market Street, San Francisco, CA 94102', '555-0102', 'contact@techhaven.com', 'Your one-stop shop for all things technology - computers, gadgets, and accessories.', 4, 'approved'),
('City Dental Care', 4, 'Los Angeles', '789 Health Avenue, Los Angeles, CA 90001', '555-0103', 'appointments@citydentalcare.com', 'Complete dental care for the whole family in a comfortable, modern setting.', 2, 'approved'),
('Bella Spa & Wellness', 8, 'Miami', '321 Ocean Drive, Miami, FL 33139', '555-0104', 'info@bellaspa.com', 'Luxury spa offering massages, facials, and wellness treatments.', 4, 'approved'),
('QuickFix Auto', 7, 'Chicago', '555 Auto Lane, Chicago, IL 60601', '555-0105', 'service@quickfixauto.com', 'Professional auto repair and maintenance services with certified technicians.', 2, 'approved'),
('Sunrise Cafe', 1, 'Seattle', '100 Pike Place, Seattle, WA 98101', '555-0106', 'hello@sunrisecafe.com', 'Cozy neighborhood cafe serving artisan coffee and fresh pastries.', 4, 'pending');

-- Reviews
INSERT INTO reviews (business_id, user_id, rating, comment, status) VALUES
(1, 3, 5, 'Absolutely fantastic experience! The food was exquisite and the service was impeccable.', 'approved'),
(1, 5, 4, 'Great ambiance and delicious food. Slightly pricey but worth it for special occasions.', 'approved'),
(2, 3, 5, 'Very knowledgeable staff. They helped me find exactly what I needed.', 'approved'),
(3, 5, 5, 'Dr. Smith is wonderful! Very gentle and professional. Highly recommend.', 'approved'),
(4, 3, 4, 'Relaxing atmosphere and skilled therapists. The massage was heavenly.', 'approved'),
(5, 5, 3, 'Good service but had to wait longer than expected. Work quality was solid though.', 'approved'),
(2, 5, 5, 'Best tech store in the city! Great prices and excellent customer service.', 'approved');