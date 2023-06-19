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

 /* Write queries to answer the following:
Who was the last animal seen by William Tatcher?
How many different animals did Stephanie Mendez see?
List all vets and their specialties, including vets with no specialties.
List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
What animal has the most visits to vets?
Who was Maisy Smith's first visit?
Details for most recent visit: animal information, vet information, and date of visit.
How many visits were with a vet that did not specialize in that animal's species?
What specialty should Maisy Smith consider getting? Look for the species she gets the most. */

SELECT animals.name FROM animals
JOIN visits ON animals.id = visits.animal_id
JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'William Tatcher'
ORDER BY visits.visit_date DESC LIMIT 1;

SELECT COUNT(DISTINCT animals.name) AS animal_count from animals
JOIN visits ON animals.id = visits.animal_id
JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'Stephanie Mendez';

SELECT vets.name as Vet_Name , species.name as specialized_in FROM vets 
LEFT JOIN specializations ON vets.id = specializations.vet_id
LEFT JOIN species ON specializations.species_id = species.id;


SELECT animals.name from animals
JOIN visits ON animals.id = visits.animal_id
JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'Stephanie Mendez'
AND visits.visit_date >= '2020-04-01'
AND visits.visit_date <= '2020-08-30';


SELECT animals.name AS Animal_Name, COUNT(visits.animal_id) AS Visit_Count FROM animals
JOIN visits ON animals.id = visits.animal_id
GROUP BY animals.name ORDER BY visit_count DESC LIMIT 1;


SELECT animals.name AS Animal_Name from animals
JOIN visits ON animals.id = visits.animal_id
JOIN vets ON visits.vet_id = vets.id
JOIN owners ON animals.owner_id = owners.id
WHERE owners.full_name = 'Maisy Smith'
ORDER BY visits.visit_date ASC LIMIT 1;


SELECT animals.name AS Animal_Name, vets.name AS Checked_by, visits.visit_date FROM animals
JOIN visits ON animals.id = visits.animal_id
JOIN vets ON visits.vet_id = vets.id
ORDER BY visits.visit_date DESC LIMIT 1;


SELECT COUNT(*) AS visit_count
FROM visits v
JOIN vets ve ON ve.id = v.vet_id
JOIN animals a ON a.id = v.animal_id
LEFT JOIN specializations s ON s.vet_id = ve.id AND s.species_id = a.species_id
WHERE s.vet_id IS NULL OR s.species_id IS NULL;


SELECT species.name AS species, COUNT(species.id) AS visit_count
FROM vets
JOIN visits ON vets.id = visits.vet_id
JOIN animals ON animals.id = visits.animal_id
JOIN species ON species.id = animals.species_id
WHERE vets.name = 'Maisy Smith'
GROUP BY species.id
ORDER BY visit_count DESC
LIMIT 1;

/* Queries used to check the performance before and after performance optimization. */

explain analyze SELECT COUNT(*) FROM visits where animal_id = 4;

explain analyze SELECT * FROM visits where vet_id = 2;

explain analyze SELECT * FROM owners where email = 'owner_18327@mail.com';