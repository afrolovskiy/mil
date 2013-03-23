CREATE DATABASE `medicines` CAHARACTER SET utf8;

CREATE TABLE `makers` (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(255) NOT NULL,
	created_at TIMESTAMP DEFAULT NOW(),
	country VARCHAR(255)
);

CREATE TABLE `medicines` (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(255) NOT NULL,
	is_recipe BOOLEAN NOT NULL DEFAULT 0,
	route TEXT 
);

CREATE TABLE `pharmacies` (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(255) NOT NULL,
	address VARCHAR(255) NOT NULL,
	start_at TIMESTAMP NOT NULL,
	end_at TIMESTAMP NOT NULL
);

CREATE TABLE `medicines_makers` (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	medicine_id INT NOT NULL,
	maker_id INT NOT NULL
);

CREATE TABLE `medicines_makers_pharmacies` (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	medicine_id INT NOT NULL,
	maker_id INT NOT NULL,
	pharmacy_id INT NOT NULL,
	cost INT NOT NULL,
);

