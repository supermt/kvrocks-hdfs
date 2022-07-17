#!/usr/bin/env bash
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

set -e

function usage() {
    echo "Usage: $0 BUILD_DIR [-Dvar=value ...] [--unittest] [-jN] [-h|--help]" >&2
    echo >&2
    echo "BUILD_DIR   : directory to store cmake-generated and build files" >&2
    echo "-Dvar=value : extra cmake definitions" >&2
    echo "-jN         : execute N build jobs concurrently, default N = 4" >&2
    echo "--unittest  : build unittest target" >&2
    echo "--ninja     : use ninja to build kvrocks" >&2
    echo "--gcc       : use gcc/g++ to build kvrocks" >&2
    echo "--clang     : use clang/clang++ to build kvrocks" >&2
    echo "--ghproxy   : use ghproxy.com to fetch dependencies" >&2
    echo "-h, --help  : print this help messages" >&2
    exit 1
}

until [ $# -eq 0 ]; do
    case $1 in
        -D*) CMAKE_DEFS="$CMAKE_DEFS $1";;
        --unittest) BUILD_UNITTEST=1;;
        --ninja) USE_NINJA="-G Ninja";;
        --gcc) COMPILER="-DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++";;
        --clang) COMPILER="-DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++";;
        --ghproxy) USE_GHPROXY="-DDEPS_FETCH_PROXY=https://ghproxy.com/";;
        -j*) JOB_CMD=$1;;
        -*) usage;;
        *) BUILD_DIR=$1;;
    esac
    shift
done

if [ -z "$BUILD_DIR" ]; then
    usage
fi

if [ -z "$JOB_CMD" ]; then
    JOB_CMD="-j 4"
fi

WORKING_DIR=$(pwd)
CMAKE_INSTALL_DIR=$WORKING_DIR/$BUILD_DIR/cmake
CMAKE_REQUIRE_VERSION="3.13.0"

RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

if [ ! -x "$(command -v autoconf)" ]; then
    printf ${RED}"The autoconf was required to build jemalloc\n"${NC}
    printf ${YELLOW}"Please use 'yum install -y autoconf automake libtool' in centos/redhat, or use 'apt-get install autoconf automake libtool' in debian/ubuntu"${NC}"\n"
    exit 1
fi

if [ -x "$(command -v cmake)" ]; then
    CMAKE_BIN=$(command -v cmake)
fi

if [ -x "$CMAKE_INSTALL_DIR/bin/cmake" ]; then
    CMAKE_BIN=$CMAKE_INSTALL_DIR/bin/cmake
fi

if [ -f "$CMAKE_BIN" ]; then
    CMAKE_VERSION=`$CMAKE_BIN -version | head -n 1 | sed 's/[^0-9.]*//g'`
else
    CMAKE_VERSION=0
fi

if [ "$(printf '%s\n' "$CMAKE_REQUIRE_VERSION" "$CMAKE_VERSION" | sort -V | head -n1)" != "$CMAKE_REQUIRE_VERSION" ]; then
    printf ${YELLOW}"CMake $CMAKE_REQUIRE_VERSION or higher is required. Trying to install CMake $CMAKE_REQUIRE_VERSION ..."${NC}"\n"
    if [ ! -x "$(command -v curl)" ]; then
        printf ${RED}"Please install the curl first to download the cmake"${NC}"\n"
        exit 1
    fi
    mkdir -p $BUILD_DIR/cmake
    cd $BUILD_DIR
    CMAKE_DOWNLOAD_VERSION=3.23.1
    curl -O -L https://github.com/Kitware/CMake/releases/download/v$CMAKE_DOWNLOAD_VERSION/cmake-$CMAKE_DOWNLOAD_VERSION.tar.gz
    tar -zxf cmake-$CMAKE_DOWNLOAD_VERSION.tar.gz && cd cmake-$CMAKE_DOWNLOAD_VERSION
    ./bootstrap --prefix=$CMAKE_INSTALL_DIR -- -DCMAKE_USE_OPENSSL=OFF && make && make install && cd ../..
    CMAKE_BIN=$CMAKE_INSTALL_DIR/bin/cmake
fi

mkdir -p $BUILD_DIR
cd $BUILD_DIR

set -x
$CMAKE_BIN $WORKING_DIR -DCMAKE_BUILD_TYPE=RelWithDebInfo $CMAKE_DEFS $USE_NINJA $COMPILER $USE_GHPROXY
$CMAKE_BIN --build . $JOB_CMD -t kvrocks kvrocks2redis

if [ -n "$BUILD_UNITTEST" ]; then
    $CMAKE_BIN --build . $JOB_CMD -t unittest
fi
