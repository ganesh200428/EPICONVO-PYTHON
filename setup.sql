-- Create Database
CREATE DATABASE IF NOT EXISTS chatbot;
USE chatbot;

-- Create chat history table
CREATE TABLE IF NOT EXISTS chat_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_message TEXT NOT NULL,
    ai_response TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create MySQL user and grant permissions
DROP USER IF EXISTS '1628Ganesh'@'localhost';
CREATE USER '1628Ganesh'@'localhost' IDENTIFIED BY 'ganesh16';
GRANT ALL PRIVILEGES ON chatbot.* TO '1628Ganesh'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;

-- Verify setup
SHOW TABLES;
SELECT * FROM chat_history;
