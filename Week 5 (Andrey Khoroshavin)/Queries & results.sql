Explain ANALYZE SELECT * FROM public.customer_1 where id > 10000 and id < 11111;

	-- Before indexing: 	Seq Scan on customer_1  (cost=0.00..9141.50 rows=1212 width=211)
	-- B-tree: 		Index Scan using "B-tree" on customer_1  (cost=0.42..80.85 rows=1212 width=211)


Explain ANALYZE SELECT * FROM public.customer_1 where address = '02591 Regina Port Apt. 277 East Stephanieville, ND 05662';

	-- Before indexing: 	Seq Scan on customer_1  (cost=0.00..8881.08 rows=1 width=211) 
	-- Hash: 		Index Scan using "Hash" on customer_1  (cost=0.00..8.02 rows=1 width=211)

/* Use cases:
	As we can see, indexing extremely reduces query execution time. 
	B-tree is more likely to be used with sorting elements as numbers and names.
	Hashing is useful for unsortable text fields like addresses and reviews (for our example).
*/

