#!/bin/bash
redis-cli flushall
cat profiles.txt | redis-cli --pipe
