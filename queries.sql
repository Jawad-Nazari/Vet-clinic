/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';

SELECT name FROM animals WHERE date_of_birth BETWEEN DATE '2016-01-01' AND DATE '2019-12-31';

SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;

SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');

SELECT name, escape_attempts FROM animals WHERE weight_kg > '10.5';

SELECT * FROM animals WHERE neutered = true;

SELECT * FROM animals WHERE name <> 'Gabumon';

SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

/* Inside a transaction update the animals table by setting the species column to unspecified. Verify that change was made. 
 Then roll back the change and verify that the species columns went back to the state before the transaction. */

BEGIN;

UPDATE animals set species = 'unspecified';

SELECT * FROM animals;

ROLLBACK;

SELECT * FROM animals;