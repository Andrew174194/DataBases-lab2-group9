-- step I
-- terminal 1
begin;
set transaction isolation level read committed;
select * from test_table;

-- step II
-- terminal 2
begin;
set transaction isolation level read committed;
update test_table set username = 'ajones' where fullname = 'Alice Jones';

-- step III
-- terminal 1 output:
postgres=*# select * from test_table;
 id | username |     fullname     | balance | group_id 
----+----------+------------------+---------+----------
  1 | jones    | Alice Jones      |      82 |        1
  2 | bitdiddl | Ben Bitdiddle    |      65 |        1
  3 | mike     | Michael Dole     |      73 |        2
  4 | alyssa   | Alyssa P. Hacker |      79 |        3
  5 | bbrown   | Bob Brown        |     100 |        3
(5 rows)

-- step IV
-- terminal 2 output:
postgres=*# select * from test_table;
 id | username |     fullname     | balance | group_id 
----+----------+------------------+---------+----------
  2 | bitdiddl | Ben Bitdiddle    |      65 |        1
  3 | mike     | Michael Dole     |      73 |        2
  4 | alyssa   | Alyssa P. Hacker |      79 |        3
  5 | bbrown   | Bob Brown        |     100 |        3
  1 | ajones   | Alice Jones      |      82 |        1
(5 rows)

-- step V
-- terminal 1 && 2 output:
postgres=# select * from test_table;
 id | username |     fullname     | balance | group_id 
----+----------+------------------+---------+----------
  2 | bitdiddl | Ben Bitdiddle    |      65 |        1
  3 | mike     | Michael Dole     |      73 |        2
  4 | alyssa   | Alyssa P. Hacker |      79 |        3
  5 | bbrown   | Bob Brown        |     100 |        3
  1 | ajones   | Alice Jones      |      82 |        1
(5 rows)

