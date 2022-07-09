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

>  `./build.sh -h` to check more options;
> especially, `./build.sh build --ghproxy` will fetch dependencies via ghproxy.com.
