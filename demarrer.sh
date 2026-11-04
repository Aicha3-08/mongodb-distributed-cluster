
#!/bin/bash
echo "🚀 Starting cluster..."
docker-compose up -d
sleep 10

echo "⏳ Init config server..."
docker exec config mongosh --eval 'rs.initiate({_id:"csrs", members:[{_id:0, host:"config:27019"}]})'
sleep 3

echo "⏳ Init shard 1..."
docker exec shard1 mongosh --eval 'rs.initiate({_id:"shard1rs", members:[{_id:0, host:"shard1:27018"}]})'
sleep 3

echo "⏳ Configure mongos..."
docker exec mongos mongosh --eval 'sh.addShard("shard1rs/shard1:27018")'

echo ""
echo "✅ CLUSTER STARTED!"
echo ""
echo "Connect to mongosh:"
echo "  docker exec -it mongos mongosh"
echo ""
echo "Add PC 2:"
echo "  > rs.add({host: \"172.20.10.5:27018\", priority: 5})"
echo ""
echo "Add PC 3:"
echo "  > rs.add({host: \"172.20.10.6:27018\", priority: 5})"

