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


 /* Create a table named vets with the following columns:
id: integer (set it as autoincremented PRIMARY KEY)
name: string
age: integer
date_of_graduation: date  */


CREATE TABLE vets (
     id SERIAL PRIMARY KEY, 
     name VARCHAR(50),
     age INT, 
     date_of_graduation DATE
    );

 /* There is a many-to-many relationship between the tables species and vets: 
a vet can specialize in multiple species, 
and a species can have multiple vets specialized in it. 
Create a "join table" called specializations to handle this relationship. */

CREATE TABLE specializations (
     vet_id INT, species_id INT, 
     PRIMARY KEY (vet_id , species_id) ,
     FOREIGN KEY (vet_id) REFERENCES vets (id), 
     FOREIGN KEY (species_id) REFERENCES species (id)
   );

 /* There is a many-to-many relationship between the tables animals and vets: 
an animal can visit multiple vets and one vet can be visited by multiple animals. 
Create a "join table" called visits to handle this relationship, 
it should also keep track of the date of the visit. */

CREATE TABLE visits (
    id serial primary key, animal_id INT, vet_id INT, visit_date DATE,
    FOREIGN KEY (animal_id) REFERENCES animals (id),
    FOREIGN KEY (vet_id) REFERENCES vets (id)
   );

ALTER TABLE owners ADD COLUMN email VARCHAR(120);

CREATE INDEX visits_animal_id_index ON visits (animal_id);
CREATE INDEX visits_vet_index on visits (vet_id DESC);
CREATE INDEX email_asc ON owners(email ASC);