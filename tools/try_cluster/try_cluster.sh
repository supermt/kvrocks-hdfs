#!/bin/bash

# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

# Settings
BIN_PATH="../../cmake-build-debug/"
HOST=127.0.0.1
PORT=30000
NODES=6
REPLICAS=1

# Computed vars
ENDPORT=$((PORT + NODES))

slots_range=("0-5460" "5461-10992" "10993-16383")
node_id=("kvrockskvrockskvrockskvrockskvrocksnode1"
  "kvrockskvrockskvrockskvrockskvrocksnode2"
  "kvrockskvrockskvrockskvrockskvrocksnode3"
  "kvrockskvrockskvrockskvrockskvrocksnode4"
  "kvrockskvrockskvrockskvrockskvrocksnode5"
  "kvrockskvrockskvrockskvrockskvrocksnode6")

if [ "$1" == "start" ]; then
  index=0
  cluster_nodes=""
  while [ $((index < NODES)) != "0" ]; do
    slotindex=$(expr $index / 2)
    slots=${slots_range[$slotindex]}
    if [ $(expr $index % 2) == 1 ]; then
      master_index=$(expr $index - 1)
      masterid=${node_id[$master_index]}
      cluster_nodes="$cluster_nodes\n${node_id[$index]} $HOST $((PORT + $index + 1)) slave $masterid"
    else
      cluster_nodes="$cluster_nodes\n${node_id[$index]} $HOST $((PORT + $index + 1)) master - $slots"
    fi
    index=$((index + 1))
  done
  cluster_nodes=$(echo -e ${cluster_nodes:2})

  index=0
  while [ $((PORT < ENDPORT)) != "0" ]; do
    PORT=$((PORT + 1))
    echo "Starting $PORT"
    mkdir node_${PORT}
    conf_file="node_${PORT}.conf"
    cp ./default.conf ${conf_file}
    sed -i.bak "s|pidfile.*|pidfile  node_${PORT}.pid|g" ${conf_file} && rm ${conf_file}.bak
    sed -i.bak "s|port.*|port ${PORT}|g" ${conf_file} && rm ${conf_file}.bak
    sed -i.bak "s|dir.*|dir "node_${PORT}"|g" ${conf_file} && rm ${conf_file}.bak
    $BIN_PATH/kvrocks -c ${conf_file}
    sleep 1
    redis-cli -h 127.0.0.1 -p $PORT clusterx setnodeid ${node_id[$index]}
    redis-cli -h 127.0.0.1 -p $PORT clusterx setnodes "${cluster_nodes}" 1
    index=$((index + 1))
  done
  exit 0
fi

if [ "$1" == "stop" ]; then
  while [ $((PORT < ENDPORT)) != "0" ]; do
    PORT=$((PORT + 1))
    echo "Stopping $PORT"
    redis-cli -h 127.0.0.1 -p $PORT shutdown
  done
  rm -r ./node_*
  exit 0
fi

if [ "$1" == "watch" ]; then
  PORT=$((PORT + 1))
  while [ 1 ]; do
    clear
    date
    redis-cli -h 127.0.0.1 -p $PORT cluster nodes
    sleep 1
  done
  exit 0
fi

echo "Usage: $0 [start|stop|watch]"
echo "start       -- Launch Redis Cluster instances."
echo "stop        -- Stop Redis Cluster instances."
echo "watch       -- Show CLUSTER NODES output (first 30 lines) of first node."
