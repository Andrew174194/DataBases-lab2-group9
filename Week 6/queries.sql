select title from film where ((rating='R' or rating='PG-13') and film_id in (select film_id from film_category where (category_id=11 or category_id=14)) and film_id in (select film_id from inventory where inventory_id in (select inventory_id from rental where return_date is NULL)));

select store_id, sum(amount) as "money" from payment left outer join customer using (customer_id) left outer join store using (store_id) where payment_date > '2007/04/14' and payment_date < '2007/05/14' group by store_id;


-- solution for first
create index


-- solution for second
create index on payment using btree(payment_date);
