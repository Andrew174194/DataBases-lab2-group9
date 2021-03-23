-- PART II

ALTER TABLE accounts
ADD COLUMN account_bank VARCHAR ( 255 );

update accounts set account_bank = 'SpearBank' WHERE account_id=1;

update accounts set account_bank = 'Tinkoff' WHERE account_id=2;

update accounts set account_bank = 'SpearBank' WHERE account_id=3;
