/* Database schema to keep the structure of entire database. */

CREATE DATABASE vet_clinic;

CREATE TABLE animals(
id INT PRIMARY KEY NOT NULL, 
name VARCHAR(50) NOT NULL, 
date_of_birth DATE, 
escape_attempts INT, 
neutered BOOLEAN, 
weight_kg DECIMAL
 );

/*  Updated animals table by adding species column   */
   ALTER TABLE animals ADD COLUMN species VARCHAR(50);  

   
 /* Create a table named owners with the following columns:
id: integer (set it as autoincremented PRIMARY KEY)
full_name: string
age: integer  */

CREATE TABLE owners ( id SERIAL PRIMARY KEY NOT NULL, full_name VARCHAR(50) NOT NULL, age INT);


/* Create a table named species with the following columns:
id: integer (set it as autoincremented PRIMARY KEY)
name: string */

CREATE TABLE species (id SERIAL PRIMARY KEY NOT NULL, name VARCHAR(50));

/* Modify animals table:
Make sure that id is set as autoincremented PRIMARY KEY
Remove column species
Add column species_id which is a foreign key referencing species table
Add column owner_id which is a foreign key referencing the owners table
Remember all this goes in schema.sql file.*/

ALTER TABLE animals ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY;

ALTER TABLE animals DROP COLUMN species;

ALTER TABLE animals ADD COLUMN species_id INT REFERENCES species(id);

ALTER TABLE animals ADD COLUMN owner_id INT REFERENCES owners(id);