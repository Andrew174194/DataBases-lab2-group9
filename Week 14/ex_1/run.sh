#!/bin/bash
redis-cli flushall
cat customers.txt | redis-cli --pipe
cat orders.txt | redis-cli --pipe
echo 'First customer:'
redis-cli HMGET customers:1 customer_numb first_name last_name
echo
echo 'Fourth customer:'
redis-cli HMGET customers:4 customer_numb first_name last_name
echo
echo 'First order:'
redis-cli HMGET orders:1 order_numb customer_numb order_date order_total
echo
echo 'Fourth order:'
redis-cli HMGET orders:4 order_numb customer_numb order_date order_total
