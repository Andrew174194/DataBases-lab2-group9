# First query

# Before creation of index:

```sql
explain (verbose, analyze) select title from film where ((rating='R' or rating='PG-13') and film_id in (select film_id from film_category where (category_id=11 or category_id=14)) and film_id not in (select film_id from inventory where inventory_id in (select inventory_id from rental)));
```

```sql
 Hash Semi Join  (cost=763.82..836.04 rows=21 width=15) (actual time=6.074..6.396 rows=3 loops=1)
   Output: film.title
   Hash Cond: (film.film_id = film_category.film_id)
   ->  Seq Scan on public.film  (cost=741.40..812.90 rows=187 width=19) (actual time=5.872..6.245 rows=16 loops=1)
         Output: film.film_id, film.title, film.description, film.release_year, film.language_id, film.rental_duration, film.rental_rate, film.length, fil
m.replacement_cost, film.rating, film.last_update, film.special_features, film.fulltext
         Filter: ((NOT (hashed SubPlan 1)) AND ((film.rating = 'R'::mpaa_rating) OR (film.rating = 'PG-13'::mpaa_rating)))
         Rows Removed by Filter: 984
         SubPlan 1
           ->  Merge Semi Join  (cost=0.57..729.95 rows=4580 width=2) (actual time=0.043..4.864 rows=4580 loops=1)
                 Output: inventory.film_id
                 Merge Cond: (inventory.inventory_id = rental.inventory_id)
                 ->  Index Scan using inventory_pkey on public.inventory  (cost=0.28..157.00 rows=4581 width=6) (actual time=0.009..0.927 rows=4581 loops=
1)
                       Output: inventory.inventory_id, inventory.film_id, inventory.store_id, inventory.last_update
                 ->  Index Only Scan using idx_fk_inventory_id on public.rental  (cost=0.29..360.94 rows=16044 width=4) (actual time=0.031..1.811 rows=160
40 loops=1)
                       Output: rental.inventory_id
                       Heap Fetches: 0
   ->  Hash  (cost=21.00..21.00 rows=114 width=2) (actual time=0.141..0.141 rows=117 loops=1)
         Output: film_category.film_id
         Buckets: 1024  Batches: 1  Memory Usage: 12kB
         ->  Seq Scan on public.film_category  (cost=0.00..21.00 rows=114 width=2) (actual time=0.017..0.123 rows=117 loops=1)
               Output: film_category.film_id
               Filter: ((film_category.category_id = 11) OR (film_category.category_id = 14))
               Rows Removed by Filter: 883
 Planning Time: 0.578 ms
 Execution Time: 6.439 ms
(25 rows)
```

# After creation of index (partial indexes for indexes depends on film_id):

```sql
create index on inventory using btree (inventory_id, film_id);
create index on film_category using btree (category_id, film_id);
```

```sql
 Hash Semi Join  (cost=732.06..804.28 rows=21 width=15) (actual time=5.453..5.775 rows=3 loops=1)
   Output: film.title
   Hash Cond: (film.film_id = film_category.film_id)
   ->  Seq Scan on public.film  (cost=713.40..784.90 rows=187 width=19) (actual time=5.269..5.641 rows=16 loops=1)
         Output: film.film_id, film.title, film.description, film.release_year, film.language_id, film.rental_duration, film.rental_rate, film.length, fil
m.replacement_cost, film.rating, film.last_update, film.special_features, film.fulltext
         Filter: ((NOT (hashed SubPlan 1)) AND ((film.rating = 'R'::mpaa_rating) OR (film.rating = 'PG-13'::mpaa_rating)))
         Rows Removed by Filter: 984
         SubPlan 1
           ->  Merge Semi Join  (cost=0.57..701.95 rows=4580 width=2) (actual time=0.027..4.405 rows=4580 loops=1)
                 Output: inventory.film_id
                 Merge Cond: (inventory.inventory_id = rental.inventory_id)
                 ->  Index Only Scan using inventory_inventory_id_film_id_idx on public.inventory  (cost=0.28..129.00 rows=4581 width=6) (actual time=0.01
6..0.701 rows=4581 loops=1)
                       Output: inventory.inventory_id, inventory.film_id
                       Heap Fetches: 0
                 ->  Index Only Scan using idx_fk_inventory_id on public.rental  (cost=0.29..360.94 rows=16044 width=4) (actual time=0.010..1.610 rows=160
40 loops=1)
                       Output: rental.inventory_id
                       Heap Fetches: 0
   ->  Hash  (cost=17.24..17.24 rows=114 width=2) (actual time=0.115..0.116 rows=117 loops=1)
         Output: film_category.film_id
         Buckets: 1024  Batches: 1  Memory Usage: 12kB
         ->  Bitmap Heap Scan on public.film_category  (cost=9.48..17.24 rows=114 width=2) (actual time=0.068..0.098 rows=117 loops=1)
               Output: film_category.film_id
               Recheck Cond: ((film_category.category_id = 11) OR (film_category.category_id = 14))
               Heap Blocks: exact=6
               ->  BitmapOr  (cost=9.48..9.48 rows=117 width=0) (actual time=0.058..0.059 rows=0 loops=1)
                     ->  Bitmap Index Scan on film_category_category_id_film_id_idx  (cost=0.00..4.70 rows=56 width=0) (actual time=0.040..0.040 rows=56 l
oops=1)
                           Index Cond: (film_category.category_id = 11)
                     ->  Bitmap Index Scan on film_category_category_id_film_id_idx  (cost=0.00..4.73 rows=61 width=0) (actual time=0.017..0.017 rows=61 l
oops=1)
                           Index Cond: (film_category.category_id = 14)
 Planning Time: 0.743 ms
 Execution Time: 5.861 ms
(31 rows)
```

# Second query

# Before creation of index:

```sql
explain (verbose, analyze) select * from (select store_id, sum(amount) as money from payment right join customer using (customer_id) right join store using (store_id) where payment_date > '2007/04/14' and payment_date <= '2007/05/14' group by store_id) as answer order by money desc;
```

```sql
 Sort  (cost=403.03..403.03 rows=2 width=36) (actual time=4.077..4.079 rows=2 loops=1)
   Output: store.store_id, (sum(payment.amount))
   Sort Key: (sum(payment.amount)) DESC
   Sort Method: quicksort  Memory: 25kB
   ->  HashAggregate  (cost=402.97..403.00 rows=2 width=36) (actual time=4.071..4.073 rows=2 loops=1)
         Output: store.store_id, sum(payment.amount)
         Group Key: store.store_id
         Batches: 1  Memory Usage: 24kB
         ->  Hash Join  (cost=23.52..386.39 rows=3317 width=10) (actual time=1.017..3.378 rows=3300 loops=1)
               Output: store.store_id, payment.amount
               Inner Unique: true
               Hash Cond: (customer.store_id = store.store_id)
               ->  Hash Join  (cost=22.48..358.19 rows=3317 width=8) (actual time=0.984..2.660 rows=3300 loops=1)
                     Output: payment.amount, customer.store_id
                     Inner Unique: true
                     Hash Cond: (payment.customer_id = customer.customer_id)
                     ->  Seq Scan on public.payment  (cost=0.00..326.94 rows=3317 width=8) (actual time=0.759..1.691 rows=3300 loops=1)
                           Output: payment.payment_id, payment.customer_id, payment.staff_id, payment.rental_id, payment.amount, payment.payment_date
                           Filter: ((payment.payment_date > '2007-04-14 00:00:00'::timestamp without time zone) AND (payment.payment_date <= '2007-05-14 0
0:00:00'::timestamp without time zone))
                           Rows Removed by Filter: 11296
                     ->  Hash  (cost=14.99..14.99 rows=599 width=6) (actual time=0.205..0.205 rows=599 loops=1)
                           Output: customer.customer_id, customer.store_id
                           Buckets: 1024  Batches: 1  Memory Usage: 31kB
                           ->  Seq Scan on public.customer  (cost=0.00..14.99 rows=599 width=6) (actual time=0.008..0.095 rows=599 loops=1)
                                 Output: customer.customer_id, customer.store_id
               ->  Hash  (cost=1.02..1.02 rows=2 width=4) (actual time=0.024..0.024 rows=2 loops=1)
                     Output: store.store_id
                     Buckets: 1024  Batches: 1  Memory Usage: 9kB
                     ->  Seq Scan on public.store  (cost=0.00..1.02 rows=2 width=4) (actual time=0.009..0.010 rows=2 loops=1)
                           Output: store.store_id
 Planning Time: 0.442 ms
 Execution Time: 4.116 ms
(32 rows)
```

# After creation of index (comparison of payment_date <>):

```sql
create index on payment using btree(payment_date);
```

```sql
 Sort  (cost=307.93..307.93 rows=2 width=36) (actual time=3.631..3.634 rows=2 loops=1)
   Output: store.store_id, (sum(payment.amount))
   Sort Key: (sum(payment.amount)) DESC
   Sort Method: quicksort  Memory: 25kB
   ->  HashAggregate  (cost=307.87..307.90 rows=2 width=36) (actual time=3.622..3.626 rows=2 loops=1)
         Output: store.store_id, sum(payment.amount)
         Group Key: store.store_id
         Batches: 1  Memory Usage: 24kB
         ->  Hash Join  (cost=97.76..291.31 rows=3312 width=10) (actual time=0.672..2.855 rows=3300 loops=1)
               Output: store.store_id, payment.amount
               Inner Unique: true
               Hash Cond: (customer.store_id = store.store_id)
               ->  Hash Join  (cost=96.71..263.15 rows=3312 width=8) (actual time=0.656..2.215 rows=3300 loops=1)
                     Output: payment.amount, customer.store_id
                     Inner Unique: true
                     Hash Cond: (payment.customer_id = customer.customer_id)
                     ->  Bitmap Heap Scan on public.payment  (cost=74.23..231.91 rows=3312 width=8) (actual time=0.305..0.819 rows=3300 loops=1)
                           Output: payment.payment_id, payment.customer_id, payment.staff_id, payment.rental_id, payment.amount, payment.payment_date
                           Recheck Cond: ((payment.payment_date > '2007-04-14 00:00:00'::timestamp without time zone) AND (payment.payment_date <= '2007-0
5-14 00:00:00'::timestamp without time zone))
                           Heap Blocks: exact=50
                           ->  Bitmap Index Scan on payment_payment_date_idx  (cost=0.00..73.41 rows=3312 width=0) (actual time=0.292..0.292 rows=3300 loo
ps=1)
                                 Index Cond: ((payment.payment_date > '2007-04-14 00:00:00'::timestamp without time zone) AND (payment.payment_date <= '20
07-05-14 00:00:00'::timestamp without time zone))
                     ->  Hash  (cost=14.99..14.99 rows=599 width=6) (actual time=0.344..0.344 rows=599 loops=1)
                           Output: customer.customer_id, customer.store_id
                           Buckets: 1024  Batches: 1  Memory Usage: 31kB
                           ->  Seq Scan on public.customer  (cost=0.00..14.99 rows=599 width=6) (actual time=0.007..0.111 rows=599 loops=1)
                                 Output: customer.customer_id, customer.store_id
               ->  Hash  (cost=1.02..1.02 rows=2 width=4) (actual time=0.011..0.012 rows=2 loops=1)
                     Output: store.store_id
                     Buckets: 1024  Batches: 1  Memory Usage: 9kB
                     ->  Seq Scan on public.store  (cost=0.00..1.02 rows=2 width=4) (actual time=0.008..0.009 rows=2 loops=1)
                           Output: store.store_id
 Planning Time: 0.997 ms
 Execution Time: 3.681 ms
(34 rows)
```

