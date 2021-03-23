CREATE TABLE IF NOT EXISTS accounts (
   account_id serial PRIMARY KEY,
   account_name VARCHAR ( 255 ) UNIQUE NOT NULL,
   account_credit integer NOT NULL
);
