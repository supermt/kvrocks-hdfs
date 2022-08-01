## Building kvrocks

#### requirements

* g++ (required by c++11, version >= 4.8)
* autoconf automake libtool cmake
* JAVA 1.8, and save at least 8GB for your JAVA HEAP, you can set up the `$_JAVA_OPTIONS`

# example environment:

* This is the example setups, which works fine on my own computer, if you keep receiving the error of JNI and report
  stack overflow problem, increase the `Xmx` in the following config

```shell
export HADOOP_HOME=/home/hadoop/hadoop-3.3.3
export HADOOP_INSTALL=$HADOOP_HOME
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin

export _JAVA_OPTIONS="-Xss1g -Xmx12g -XX:StackShadowPages=50"
export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/native -Xss4m -Xmx512m -XX:StackShadowPages=40"
export JAVA_HOME=/usr/lib/jvm/default-java/
#export LD_LIBRARY_PATH=$JAVA_HOME/lib/server
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/jvm/default-java/lib/server:/usr/lib/jvm/default-java/lib/amd64/:/usr/lib/jvm/default-java/lib/
export LIBRARY_PATH=$LD_LIBRARY_PATH:$LIBRARY_PATH

export CLASSPATH=`hadoop classpath`
export USE_HDFS=1
export CLASSPATH=`$HADOOP_HOME/bin/hadoop classpath --glob`
for f in `find $HADOOP_HOME/share/hadoop/hdfs | grep jar`; do export CLASSPATH=$CLASSPATH:$f; done
for f in `find $HADOOP_HOME/share/hadoop | grep jar`; do export CLASSPATH=$CLASSPATH:$f; done
for f in `find $HADOOP_HOME/share/hadoop/client | grep jar`; do export CLASSPATH=$CLASSPATH:$f; done
```

# For Clion users

if your debugger keeps reporting Segment fault, you can create the `.gdbinit` file, and add the following lines into the
system, but be careful, as it will pass all the segment fault in your system. Also, this works ONLY for gdb.

```
handle SIGSEGV nostop noprint pass
```

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

# Commands to do the migration.

```shell
redis-cli -h 127.0.0.1 -p 30001 clusterx migrate 0 kvrockskvrockskvrockskvrockskvrocksnode3
redis-cli -h 127.0.0.1 -p 30001 clusterx setslot 0 NODE kvrockskvrockskvrockskvrockskvrocksnode3 2  
redis-cli -h 127.0.0.1 -p 30002 clusterx setslot 0 NODE kvrockskvrockskvrockskvrockskvrocksnode3 2
redis-cli -h 127.0.0.1 -p 30003 clusterx setslot 0 NODE kvrockskvrockskvrockskvrockskvrocksnode3 2
redis-cli -h 127.0.0.1 -p 30004 clusterx setslot 0 NODE kvrockskvrockskvrockskvrockskvrocksnode3 2
redis-cli -h 127.0.0.1 -p 30005 clusterx setslot 0 NODE kvrockskvrockskvrockskvrockskvrocksnode3 2
redis-cli -h 127.0.0.1 -p 30006 clusterx setslot 0 NODE kvrockskvrockskvrockskvrockskvrocksnode3 2
```

## Use YCSB to do the benchmark

Under the dir `ycsbcore` is the source code of YCSB workload generator

We also check out the newest version (July 3rd 2022) of redis-plus-plus as the request client

Also, you can use the java version in `ycsb` dir, which is the original version of YCSB.

```shell
cd YCSB-C/
make -j4
./ycsb-redis -db redis -threads 1 -P workloads/workloada.spec -host 127.0.0.1 -port 30001 -nodes 1
```