## Building kvrocks

#### requirements

* g++ (required by c++11, version >= 4.8)
* autoconf automake libtool cmake

#### Build

```shell
# Ubuntu/Debian
sudo apt update
sudo apt-get install gcc g++ make cmake autoconf automake libtool
```

```shell
$ ./build.sh build 
```

### Start the client to access the system

> You can first install the redis-cli by apt, as apt-get install redis-tools

# Run cluster as following commands

> it create a cluster with 6 nodes on single machine with different ports. 3 master + 3 slave

## Start the system and watch

```shell
cd tools/try_cluster/
./try_cluster.sh start
#./try_cluster.sh watch
redis-cli -h 127.0.0.1 -p 30001 cluster nodes
```

## Stop the system

```shell
cd tools/try_cluster/
./try_cluster.sh stop
exit 
```

```shell
redis-cli -h 127.0.0.1 -p 30001 clusterx migrate 0 kvrockskvrockskvrockskvrockskvrocksnode3
redis-cli -h 127.0.0.1 -p 30001 clusterx setslot 0 NODE kvrockskvrockskvrockskvrockskvrocksnode3 2  
redis-cli -h 127.0.0.1 -p 30002 clusterx setslot 0 NODE kvrockskvrockskvrockskvrockskvrocksnode3 2
redis-cli -h 127.0.0.1 -p 30003 clusterx setslot 0 NODE kvrockskvrockskvrockskvrockskvrocksnode3 2
redis-cli -h 127.0.0.1 -p 30004 clusterx setslot 0 NODE kvrockskvrockskvrockskvrockskvrocksnode3 2
redis-cli -h 127.0.0.1 -p 30005 clusterx setslot 0 NODE kvrockskvrockskvrockskvrockskvrocksnode3 2
redis-cli -h 127.0.0.1 -p 30006 clusterx setslot 0 NODE kvrockskvrockskvrockskvrockskvrocksnode3 2
```