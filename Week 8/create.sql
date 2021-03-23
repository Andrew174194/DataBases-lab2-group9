CREATE TABLE IF NOT EXISTS accounts (
   account_id serial PRIMARY KEY,
   account_name VARCHAR ( 255 ) UNIQUE NOT NULL,
   account_credit integer NOT NULL
);


insert into accounts(account_name, account_credit) values ('Vladimir', 1000);

insert into accounts(account_name, account_credit) values ('German', 1000);

insert into accounts(account_name, account_credit) values ('Andrey', 1000);

-- transaction T1

BEGIN WORK;

UPDATE accounts 
SET account_credit = account_credit - 500
WHERE account_id = 1;

UPDATE accounts 
SET account_credit = account_credit + 500
WHERE account_id = 3;

COMMIT WORK;
