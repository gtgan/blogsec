-- Set up the database with this, and refer to it to hack the site.
-- I'll change the password, mind you.

CREATE DATABASE IF NOT EXISTS blogsec;
USE blogsec;

CREATE USER IF NOT EXISTS 'sec'@'localhost' IDENTIFIED BY 'password';
GRANT INSERT, DELETE, SELECT, UPDATE ON blogsec.* to 'sec'@'localhost';
FLUSH PRIVILEGES;

CREATE TABLE IF NOT EXISTS Users (
    email       varchar(255) NOT NULL PRIMARY KEY,
    first_name  varchar(255),
    last_name   varchar(255),
    pwd_hash    char(128) NOT NULL,
    salt        char(128) NOT NULL,
    bio         text,
    privilege   enum('none', 'user', 'admin') NOT NULL DEFAULT 'none'
);
CREATE TABLE IF NOT EXISTS Posts (
    post_id     bigint NOT NULL AUTO_INCREMENT PRIMARY KEY,
    email       varchar(255) NOT NULL,
    content     text,
    title       varchar(255) NOT NULL,
    created     timestamp DEFAULT CURRENT_TIMESTAMP,
    modified    timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (email) REFERENCES Users(email)
);
CREATE TABLE IF NOT EXISTS Replies (
    reply_id    bigint NOT NULL AUTO_INCREMENT PRIMARY KEY,
    email       varchar(255) NOT NULL,
    post_id     bigint NOT NULL,
    content     text,
    created     timestamp DEFAULT CURRENT_TIMESTAMP,
    modified    timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (email) REFERENCES Users(email),
    FOREIGN KEY (post_id) REFERENCES Posts(post_id)
);
CREATE TABLE IF NOT EXISTS Vulnerable (
    id          bigint NOT NULL AUTO_INCREMENT PRIMARY KEY,
    value       text,
    email       varchar(255) NOT NULL,
    modified    timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (email) REFERENCES Users(email)
);
