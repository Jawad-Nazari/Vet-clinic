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

 /* Inside a transaction:
Update the animals table by setting the species column to digimon for all animals that have a name ending in mon.
Update the animals table by setting the species column to pokemon for all animals that don't have species already set.
Verify that changes were made.
Commit the transaction.
Verify that changes persist after commit. */
 BEGIN;

 UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';

 UPDATE animals SET species = 'pokemon' WHERE species is NULL;

 SELECT * FROM animals;

 COMMIT;

 SELECT * FROM animals;

 /*  Deleting all the transcations */

BEGIN;
DELETE from animals;
ROLLBACK;
SELECT * FROM animals;

/* Inside a transaction:
   Delete all animals born after Jan 1st, 2022.
   Create a savepoint for the transaction.
   Update all animals' weight to be their weight multiplied by -1.
   Rollback to the savepoint
   Update all animals' weights that are negative to be their weight multiplied by -1.
   Commit transaction */

BEGIN;
DELETE FROM animals WHERE  date_of_birth > '2022-01-01';
SAVEPOINT SP1;
UPDATE animals SET weight_kg = weight_kg * -1;
ROLLBACK TO SAVEPOINT SP1;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
COMMIT;

/* Write queries to answer the following questions:
   How many animals are there?
   How many animals have never tried to escape?
   What is the average weight of animals?
   Who escapes the most, neutered or not neutered animals?
   What is the minimum and maximum weight of each type of animal?
   What is the average number of escape attempts per animal type of those born between 1990 and 2000? */

SELECT COUNT(id) FROM animals;

SELECT COUNT(id) FROM animals WHERE escape_attempts = 0 ;

SELECT AVG(weight_kg) FROM animals;

SELECT neutered, MAX(escape_attempts) FROM animals GROUP BY neutered;

SELECT species, MAX(weight_kg), MIN(weight_kg) FROM animals GROUP BY species;

SELECT species, AVG(escape_attempts) FROM animals
WHERE EXTRACT(YEAR FROM date_of_birth) BETWEEN 1990 AND 2000 GROUP BY species;


 /* Write queries (using JOIN) to answer the following questions:
What animals belong to Melody Pond?
List of all animals that are pokemon (their type is Pokemon).
List all owners and their animals, remember to include those that don't own any animal.
How many animals are there per species?
List all Digimon owned by Jennifer Orwell.
List all animals owned by Dean Winchester that haven't tried to escape.
Who owns the most animals?
Remember all these should be written in queries.sql file.
Take a screenshot of the results of your queries. */

SELECT name FROM animals INNER 
JOIN owners ON animals.owner_id = owners.id
WHERE owners.full_name = 'Melody Pond';

SELECT animals.name FROM animals
JOIN species ON animals.species_id = species.id
WHERE species.name = 'Pokemon';

SELECT full_name, name FROM owners
LEFT JOIN animals ON owners.id = animals.owner_id;

SELECT species.name, COUNT(*) AS animal_count from animals
LEFT JOIN species ON animals.species_id = species.id GROUP BY species.name;

SELECT animals.name FROM animals
JOIN species ON animals.species_id = species.id
JOIN owners ON animals.owner_id = owners.id
WHERE owners.full_name = 'Jennifer Orwell' AND species.name = 'Digimon';

SELECT animals.name FROM animals
JOIN owners ON animals.owner_id = owners.id
WHERE owners.full_name = 'Dean Winchester' AND animals.escape_attempts = 0;

SELECT owners.full_name, COUNT(animals.id) AS animal_count FROM owners
JOIN animals ON owners.id = animals.owner_id
GROUP BY owners.full_name ORDER BY animal_count DESC LIMIT 1;
