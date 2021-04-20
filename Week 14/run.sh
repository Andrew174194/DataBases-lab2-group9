#!/bin/bash
redis-cli flushall
cat customers.txt | redis-cli --pipe
cat orders.txt | redis-cli --pipe
