#!/bin/bash
echo "Testing failover..."

echo "1. Insert data..."
docker exec mongos mongosh --eval 'use testdb; db.test.insertMany([{_id:1, msg:"test1"}, {_id:2, msg:"test2"}])'

echo "2. Stop primary..."
docker stop shard1
sleep 15

echo "3. Restart primary..."
docker start shard1
sleep 10

echo "4. Check data..."
docker exec mongos mongosh --eval 'use testdb; db.test.find().pretty()'

echo "✅ FAILOVER TEST DONE!"

