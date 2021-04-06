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
select * from test_table;

-- terminal 1 && 2 output:
 id | username |     fullname     | balance | group_id 
----+----------+------------------+---------+----------
  1 | jones    | Alice Jones      |      82 |        1
  2 | bitdiddl | Ben Bitdiddle    |      65 |        1
  4 | alyssa   | Alyssa P. Hacker |      79 |        3
  5 | bbrown   | Bob Brown        |     100 |        2
  3 | mike     | Michael Dole     |      88 |        2
(5 rows)

-- so we do not update Bob's balance
-- we only move Bob to second group and increase Mike account balance
