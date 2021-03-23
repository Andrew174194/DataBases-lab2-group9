CREATE TABLE IF NOT EXISTS accounts (
   account_id serial PRIMARY KEY,
   account_name VARCHAR ( 255 ) UNIQUE NOT NULL,
   account_credit integer NOT NULL
);


insert into accounts(account_name, account_credit) values ('Vladimir', 1000);

insert into accounts(account_name, account_credit) values ('German', 1000);

insert into accounts(account_name, account_credit) values ('Andrey', 1000);

-- transaction T1

BEGIN;

SAVEPOINT T1;

UPDATE accounts 
SET account_credit = account_credit - 500
WHERE account_id = 1;

UPDATE accounts 
SET account_credit = account_credit + 500
WHERE account_id = 3;

SELECT * from accounts;

ROLLBACK TO T1;

COMMIT;

-- transaction T2

BEGIN;

SAVEPOINT T2;

UPDATE accounts 
SET account_credit = account_credit - 700
WHERE account_id = 2;

UPDATE accounts 
SET account_credit = account_credit + 700
WHERE account_id = 1;

SELECT * from accounts;

ROLLBACK TO T2;

COMMIT;

-- transaction T3

BEGIN;

SAVEPOINT T3;

UPDATE accounts 
SET account_credit = account_credit - 200
WHERE account_id = 2;

UPDATE accounts 
SET account_credit = account_credit + 200
WHERE account_id = 3;

SELECT * from accounts;

ROLLBACK TO T3;

COMMIT;
