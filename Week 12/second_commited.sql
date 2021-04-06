-- READ COMMITED

-- step I
-- terminal 1
begin;
set transaction isolation level read committed;

-- terminal 2
begin;
set transaction isolation level read committed;


-- step 2
-- terminal 1
select * from test_table where group_id = 2;

 id | username |   fullname   | balance | group_id 
----+----------+--------------+---------+----------
  3 | mike     | Michael Dole |      73 |        2
(1 row)

-- step 3
-- terminal 2
update test_table set group_id = 2 where username = 'bbrown';

-- step 4
-- terminal 1
select * from test_table where group_id = 2;

 id | username |   fullname   | balance | group_id 
----+----------+--------------+---------+----------
  3 | mike     | Michael Dole |      73 |        2
(1 row)

-- so i read only previous data

-- step 5
-- terminal 1
update test_table set balance = balance + 15 where group_id = 2;

-- step 6
-- terminal 1 && 2
commit;
selet * from test_table;

-- so we do not update Bob's balance
