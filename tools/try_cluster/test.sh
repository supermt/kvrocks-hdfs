redis-cli -h 127.0.0.1 -p 30001 clusterx setnodes \
"kvrockskvrockskvrockskvrockskvrocksnode1 0.0.0.0 30001 master - 0-5000
 kvrockskvrockskvrockskvrockskvrocksnode2 0.0.0.0 30002 master - 5001-10000 
 kvrockskvrockskvrockskvrockskvrocksnode3 0.0.0.0 30003 master - 10001-10007
 kvrockskvrockskvrockskvrockskvrocksnode4 0.0.0.0 30004 master - " 4
redis-cli -h 127.0.0.1 -p 30002 clusterx setnodes \
"kvrockskvrockskvrockskvrockskvrocksnode1 0.0.0.0 30001 master - 0-5000
 kvrockskvrockskvrockskvrockskvrocksnode2 0.0.0.0 30002 master - 5001-10000 
 kvrockskvrockskvrockskvrockskvrocksnode3 0.0.0.0 30003 master - 10001-10007
 kvrockskvrockskvrockskvrockskvrocksnode4 0.0.0.0 30004 master - " 4

redis-cli -h 127.0.0.1 -p 30003 clusterx setnodes \
"kvrockskvrockskvrockskvrockskvrocksnode1 0.0.0.0 30001 master - 0-5000
 kvrockskvrockskvrockskvrockskvrocksnode2 0.0.0.0 30002 master - 5001-10000 
 kvrockskvrockskvrockskvrockskvrocksnode3 0.0.0.0 30003 master - 10001-10007
 kvrockskvrockskvrockskvrockskvrocksnode4 0.0.0.0 30004 master - " 4

redis-cli -h 127.0.0.1 -p 30001 clusterx setnodeid kvrockskvrockskvrockskvrockskvrocksnode1
redis-cli -h 127.0.0.1 -p 30002 clusterx setnodeid kvrockskvrockskvrockskvrockskvrocksnode2
redis-cli -h 127.0.0.1 -p 30003 clusterx setnodeid kvrockskvrockskvrockskvrockskvrocksnode3
redis-cli -h 127.0.0.1 -p 30004 clusterx setnodeid kvrockskvrockskvrockskvrockskvrocksnode4
