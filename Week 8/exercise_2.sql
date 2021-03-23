CREATE TABLE IF NOT EXISTS ledger (
   transaction_id serial PRIMARY KEY,
   from_id INTEGER,
   to_id INTEGER,
   fee INTEGER,
   amount INTEGER,
   transaction_time TIMESTAMP);

-- transaction 1

BEGIN;

SAVEPOINT T1;

UPDATE accounts
SET account_credit = account_credit - 500
WHERE account_id = 1;

UPDATE accounts
SET account_credit = account_credit + 500
WHERE account_id = 3;

UPDATE accounts
SET account_credit = account_credit + 0
WHERE account_id = 4;

SELECT * from accounts;

ROLLBACK TO T1;

INSERT INTO ledger(from_id, to_id, fee, amount, transaction_time) VALUES (1, 3, 0, 500, CURRENT_TIMESTAMP);

COMMIT;

-- transaction T2

BEGIN;

SAVEPOINT T2;

UPDATE accounts
SET account_credit = account_credit - 700 - 30
WHERE account_id = 2;

UPDATE accounts
SET account_credit = account_credit + 700
WHERE account_id = 1;

UPDATE accounts
SET account_credit = account_credit + 30
WHERE account_id = 4;

SELECT * from accounts;

ROLLBACK TO T2;

INSERT INTO ledger(from_id, to_id, fee, amount, transaction_time) VALUES (2, 1, 30, 700, CURRENT_TIMESTAMP);

COMMIT;

-- transaction T3

BEGIN;

SAVEPOINT T3;

UPDATE accounts
SET account_credit = account_credit - 100 - 30
WHERE account_id = 2;

UPDATE accounts
SET account_credit = account_credit + 100
WHERE account_id = 3;

UPDATE accounts
SET account_credit = account_credit + 30
WHERE account_id = 4;

SELECT * from accounts;

ROLLBACK TO T3;

INSERT INTO ledger(from_id, to_id, fee, amount, transaction_time) VALUES (2, 3, 30, 100, CURRENT_TIMESTAMP);

COMMIT;
