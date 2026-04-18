-- ============================================================
-- Test Database Setup Script
-- Run this against your MySQL/PostgreSQL instance before
-- executing the database feature tests.
-- ============================================================

-- Create the test database (MySQL syntax)
CREATE DATABASE IF NOT EXISTS testdb;
USE testdb;

-- Users table
CREATE TABLE IF NOT EXISTS users (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(100)  NOT NULL,
    email      VARCHAR(150)  NOT NULL UNIQUE,
    phone      VARCHAR(30),
    website    VARCHAR(100),
    created_at TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Posts table
CREATE TABLE IF NOT EXISTS posts (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    user_id    INT           NOT NULL,
    title      VARCHAR(255)  NOT NULL,
    body       TEXT,
    created_at TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Comments table
CREATE TABLE IF NOT EXISTS comments (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    post_id    INT           NOT NULL,
    name       VARCHAR(150),
    email      VARCHAR(150),
    body       TEXT,
    created_at TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE
);

-- ============================================================
-- Seed data
-- ============================================================

INSERT INTO users (name, email, phone, website) VALUES
    ('Leanne Graham',    'leanne@example.com',    '1-770-736-8031', 'hildegard.org'),
    ('Ervin Howell',     'ervin@example.com',     '010-692-6593',   'anastasia.net'),
    ('Clementine Bauch', 'clementine@example.com', '1-463-123-4447', 'ramiro.info'),
    ('Patricia Lebsack', 'patricia@example.com',  '493-170-9623',   'kale.biz'),
    ('Chelsey Dietrich', 'chelsey@example.com',   '(254)954-1289',  'demarco.info');

INSERT INTO posts (user_id, title, body) VALUES
    (1, 'Introduction to Karate Testing',  'Karate is a powerful API testing framework.'),
    (1, 'Advanced Karate Features',         'Learn about data-driven testing and mocks.'),
    (2, 'Database Testing Best Practices',  'Combine API and DB validations for robust tests.'),
    (3, 'CI/CD Integration Guide',          'Run Karate tests in your CI/CD pipeline.');

INSERT INTO comments (post_id, name, email, body) VALUES
    (1, 'Alice',   'alice@example.com',   'Great introduction!'),
    (1, 'Bob',     'bob@example.com',     'Very helpful, thanks.'),
    (2, 'Charlie', 'charlie@example.com', 'Looking forward to more.'),
    (3, 'Diana',   'diana@example.com',   'This saved me a lot of time.');
