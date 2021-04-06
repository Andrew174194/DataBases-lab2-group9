create table test_table (id serial primary key, username varchar not null, fullname varchar not null, balance int not null, group_id int not null);

insert into test_table (username, fullname, balance, group_id) values ('jones', 'Alice Jones', 82, 1);
insert into test_table (username, fullname, balance, group_id) values ('bitdiddl', 'Ben Bitdiddle', 65, 1);
insert into test_table (username, fullname, balance, group_id) values ('mike', 'Michael Dole', 73, 2);
insert into test_table (username, fullname, balance, group_id) values ('alyssa', 'Alyssa P. Hacker', 79, 3);
insert into test_table (username, fullname, balance, group_id) values ('bbrown', 'Bob Brown', 100, 3);
