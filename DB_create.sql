DROP DATABASE IF EXISTS movie;

CREATE DATABASE movie;

\c movie

CREATE TABLE IF NOT EXISTS movie (
  movie_id serial PRIMARY KEY,
  title VARCHAR ( 255 ) NOT NULL,
  release TIMESTAMP NOT NULL,
  length int,
  company int NOT NULL,
  outline VARCHAR ( 255 ) UNIQUE NOT NULL,
  genre VARCHAR ( 255 ) NOT NULL
);

CREATE TABLE IF NOT EXISTS actor (
  actor_id serial PRIMARY KEY,
  role VARCHAR ( 255 ) NOT NULL,
  person_id int,
  movie_id int
);

CREATE TABLE IF NOT EXISTS director (
  director_id serial PRIMARY KEY,
  person_id int,
  movie_id int
);

CREATE TABLE IF NOT EXISTS person (
  person_id serial PRIMARY KEY,
  name VARCHAR ( 255 ) NOT NULL,
  birth_date TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS quote (
  quote_id serial PRIMARY KEY,
  text VARCHAR ( 255 ) NOT NULL,
  movie_id int,
  actor_id int
);

CREATE TABLE IF NOT EXISTS company (
  company_id serial PRIMARY KEY,
  name varchar ( 255 ) UNIQUE NOT NULL,
  address varchar ( 255 ) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS genre (
  genre_id serial PRIMARY KEY,
  name varchar ( 255 ) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS has_genre (
  genre_id int,
  movie_id int
);

ALTER TABLE "movie" ADD FOREIGN KEY (company) REFERENCES company (company_id);

ALTER TABLE "actor" ADD FOREIGN KEY (person_id) REFERENCES person (person_id);
ALTER TABLE "actor" ADD FOREIGN KEY (movie_id) REFERENCES movie (movie_id);

ALTER TABLE "director" ADD FOREIGN KEY (person_id) REFERENCES person (person_id);
ALTER TABLE "director" ADD FOREIGN KEY (movie_id) REFERENCES movie (movie_id);

ALTER TABLE "quote" ADD FOREIGN KEY (actor_id) REFERENCES actor (actor_id);
ALTER TABLE "quote" ADD FOREIGN KEY (movie_id) REFERENCES movie (movie_id);

ALTER TABLE "has_genre" ADD FOREIGN KEY (genre_id) REFERENCES genre (genre_id);
ALTER TABLE "has_genre" ADD FOREIGN KEY (movie_id) REFERENCES movie (movie_id);


INSERT INTO person (name, birth_date) VALUES ('Rami Malek', '1981-05-12 00:00:00-00');
INSERT INTO person (name, birth_date) VALUES ('Carly Chaikin', '1990-03-26 00:00:00-00');
INSERT INTO person (name, birth_date) VALUES ('Sam Esmail', '1977-09-17 00:00:00-00');

INSERT INTO company (name, address) VALUES ('E Corp', 'Universitetskya 1, 414');

INSERT INTO genre (name) VALUES ('Drama');

INSERT INTO movie (title, release, length, company, outline, genre) VALUES ('Mr. Robot', '2015-01-03 00:00:00-00', '64', 1, 'Hack the planet', 'Drama');

INSERT INTO actor (role, person_id, movie_id) VALUES ('Elliot Alderson', 1, 1);

INSERT INTO director (person_id, movie_id) VALUES (3, 1);

INSERT INTO quote (text, movie_id, actor_id) VALUES ('I wanted to save the world.', 1, 1);
