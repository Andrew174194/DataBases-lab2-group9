#!/bin/bash
redis-cli flushall
cat profiles.txt | redis-cli --pipe
cat posts.txt | redis-cli --pipe
echo 'First user:'
redis-cli HMGET profiles:1 id username name followers following posts
echo

echo 'First post:'
redis-cli HMGET posts:1 post_id id timestamp text
