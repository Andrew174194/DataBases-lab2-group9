# First query

# Before creation of index:

```sql
explain (verbose, analyze) select title from film where ((rating='R' or rating='PG-13') and film_id in (select film_id from film_category where (category_id=11 or category_id=14)) and film_id not in (select film_id from inventory where inventory_id in (select inventory_id from rental where return_date is NULL)));
```

```sql
 Hash Semi Join  (cost=421.40..493.62 rows=21 width=15) (actual time=3.125..3.529 rows=54 loops=1)                                                        
   Output: film.title                                                                                                                                     
   Hash Cond: (film.film_id = film_category.film_id)                                                                                                      
   ->  Seq Scan on public.film  (cost=398.97..470.47 rows=187 width=19) (actual time=2.977..3.339 rows=354 loops=1)                                       
         Output: film.film_id, film.title, film.description, film.release_year, film.language_id, film.rental_duration, film.rental_rate, film.length, fil
m.replacement_cost, film.rating, film.last_update, film.special_features, film.fulltext
         Filter: ((NOT (hashed SubPlan 1)) AND ((film.rating = 'R'::mpaa_rating) OR (film.rating = 'PG-13'::mpaa_rating)))
         Rows Removed by Filter: 646
         SubPlan 1
           ->  Hash Semi Join  (cost=312.73..398.51 rows=183 width=2) (actual time=1.737..2.895 rows=183 loops=1)
                 Output: inventory.film_id
                 Hash Cond: (inventory.inventory_id = rental.inventory_id)
                 ->  Seq Scan on public.inventory  (cost=0.00..70.81 rows=4581 width=6) (actual time=0.006..0.450 rows=4581 loops=1)
                       Output: inventory.inventory_id, inventory.film_id, inventory.store_id, inventory.last_update
                 ->  Hash  (cost=310.44..310.44 rows=183 width=4) (actual time=1.722..1.722 rows=183 loops=1)
                       Output: rental.inventory_id
                       Buckets: 1024  Batches: 1  Memory Usage: 15kB
                       ->  Seq Scan on public.rental  (cost=0.00..310.44 rows=183 width=4) (actual time=1.015..1.625 rows=183 loops=1)
                             Output: rental.inventory_id
                             Filter: (rental.return_date IS NULL)
                             Rows Removed by Filter: 15861
   ->  Hash  (cost=21.00..21.00 rows=114 width=2) (actual time=0.138..0.139 rows=117 loops=1)
         Output: film_category.film_id
         Buckets: 1024  Batches: 1  Memory Usage: 12kB
         ->  Seq Scan on public.film_category  (cost=0.00..21.00 rows=114 width=2) (actual time=0.014..0.116 rows=117 loops=1)
               Output: film_category.film_id
               Filter: ((film_category.category_id = 11) OR (film_category.category_id = 14))
               Rows Removed by Filter: 883
 Planning Time: 2.181 ms
 Execution Time: 3.578 ms
(29 rows)
```

# After creation of index:

```sql
create index on rental using btree (return_date) where return_date is NULL;
```

```sql
 Hash Semi Join  (cost=148.40..220.63 rows=21 width=15) (actual time=1.422..2.015 rows=54 loops=1)
   Output: film.title
   Hash Cond: (film.film_id = film_category.film_id)
   ->  Seq Scan on public.film  (cost=125.98..197.48 rows=187 width=19) (actual time=1.278..1.812 rows=354 loops=1)
         Output: film.film_id, film.title, film.description, film.release_year, film.language_id, film.rental_duration, film.rental_rate, film.length, fil
m.replacement_cost, film.rating, film.last_update, film.special_features, film.fulltext
         Filter: ((NOT (hashed SubPlan 1)) AND ((film.rating = 'R'::mpaa_rating) OR (film.rating = 'PG-13'::mpaa_rating)))
         Rows Removed by Filter: 646
         SubPlan 1
           ->  Hash Semi Join  (cost=39.74..125.52 rows=183 width=2) (actual time=0.162..1.222 rows=183 loops=1)
                 Output: inventory.film_id
                 Hash Cond: (inventory.inventory_id = rental.inventory_id)
                 ->  Seq Scan on public.inventory  (cost=0.00..70.81 rows=4581 width=6) (actual time=0.006..0.462 rows=4581 loops=1)
                       Output: inventory.inventory_id, inventory.film_id, inventory.store_id, inventory.last_update
                 ->  Hash  (cost=37.45..37.45 rows=183 width=4) (actual time=0.138..0.139 rows=183 loops=1)
                       Output: rental.inventory_id
                       Buckets: 1024  Batches: 1  Memory Usage: 15kB
                       ->  Index Scan using rental_return_date_idx on public.rental  (cost=0.14..37.45 rows=183 width=4) (actual time=0.031..0.107 rows=18
3 loops=1)
                             Output: rental.inventory_id
   ->  Hash  (cost=21.00..21.00 rows=114 width=2) (actual time=0.137..0.138 rows=117 loops=1)
         Output: film_category.film_id
         Buckets: 1024  Batches: 1  Memory Usage: 12kB
         ->  Seq Scan on public.film_category  (cost=0.00..21.00 rows=114 width=2) (actual time=0.016..0.119 rows=117 loops=1)
               Output: film_category.film_id
               Filter: ((film_category.category_id = 11) OR (film_category.category_id = 14))
               Rows Removed by Filter: 883
 Planning Time: 1.421 ms
 Execution Time: 2.060 ms
(27 rows)
```

# Second query

# Before creation of index:

```sql
explain (verbose, analyze) select store_id, sum(amount) as "money" from payment left outer join customer using (customer_id) left outer join store using (store_id) where payment_date > '2007/04/14' and payment_date < '2007/05/14' group by store_id;
```

```sql
 HashAggregate  (cost=383.07..383.10 rows=2 width=36) (actual time=5.560..5.563 rows=2 loops=1)
   Output: ((customer.store_id)::integer), sum(payment.amount)
   Group Key: (customer.store_id)::integer
   Batches: 1  Memory Usage: 24kB
   ->  Hash Left Join  (cost=22.48..366.48 rows=3317 width=10) (actual time=1.253..3.996 rows=3300 loops=1)
         Output: customer.store_id, payment.amount
         Inner Unique: true
         Hash Cond: (payment.customer_id = customer.customer_id)
         ->  Seq Scan on public.payment  (cost=0.00..326.94 rows=3317 width=8) (actual time=0.982..2.560 rows=3300 loops=1)
               Output: payment.payment_id, payment.customer_id, payment.staff_id, payment.rental_id, payment.amount, payment.payment_date
               Filter: ((payment.payment_date > '2007-04-14 00:00:00'::timestamp without time zone) AND (payment.payment_date < '2007-05-14 00:00:00'::tim
estamp without time zone))
               Rows Removed by Filter: 11296
         ->  Hash  (cost=14.99..14.99 rows=599 width=6) (actual time=0.259..0.260 rows=599 loops=1)
               Output: customer.store_id, customer.customer_id
               Buckets: 1024  Batches: 1  Memory Usage: 32kB
               ->  Seq Scan on public.customer  (cost=0.00..14.99 rows=599 width=6) (actual time=0.012..0.139 rows=599 loops=1)
                     Output: customer.store_id, customer.customer_id
 Planning Time: 1.913 ms
 Execution Time: 5.615 ms
(19 rows)
```

# After creation of index:

```sql
create index on payment using btree(payment_date);
```

```sql
 HashAggregate  (cost=287.96..287.99 rows=2 width=36) (actual time=3.031..3.033 rows=2 loops=1)
   Output: ((customer.store_id)::integer), sum(payment.amount)
   Group Key: (customer.store_id)::integer
   Batches: 1  Memory Usage: 24kB
   ->  Hash Left Join  (cost=96.70..271.40 rows=3311 width=10) (actual time=0.623..2.167 rows=3300 loops=1)
         Output: customer.store_id, payment.amount
         Inner Unique: true
         Hash Cond: (payment.customer_id = customer.customer_id)
         ->  Bitmap Heap Scan on public.payment  (cost=74.22..231.89 rows=3311 width=8) (actual time=0.428..0.927 rows=3300 loops=1)
               Output: payment.payment_id, payment.customer_id, payment.staff_id, payment.rental_id, payment.amount, payment.payment_date
               Recheck Cond: ((payment.payment_date > '2007-04-14 00:00:00'::timestamp without time zone) AND (payment.payment_date < '2007-05-14 00:00:00
'::timestamp without time zone))
               Heap Blocks: exact=50
               ->  Bitmap Index Scan on payment_payment_date_idx  (cost=0.00..73.39 rows=3311 width=0) (actual time=0.414..0.414 rows=3300 loops=1)
                     Index Cond: ((payment.payment_date > '2007-04-14 00:00:00'::timestamp without time zone) AND (payment.payment_date < '2007-05-14 00:0
0:00'::timestamp without time zone))
         ->  Hash  (cost=14.99..14.99 rows=599 width=6) (actual time=0.180..0.180 rows=599 loops=1)
               Output: customer.store_id, customer.customer_id
               Buckets: 1024  Batches: 1  Memory Usage: 32kB
               ->  Seq Scan on public.customer  (cost=0.00..14.99 rows=599 width=6) (actual time=0.010..0.093 rows=599 loops=1)
                     Output: customer.store_id, customer.customer_id
 Planning Time: 1.050 ms
 Execution Time: 3.116 ms
(21 rows)
```

