/* Database schema to keep the structure of entire database. */

CREATE DATABASE vet_clinic;

CREATE TABLE animals(
id INT PRIMARY KEY NOT NULL, name VARCHAR(50) NOT NULL, date_of_birth DATE, escape_attempts INT, neutered BOOLEAN, weight_kg DECIMAL
 );