# Linux application example

This application uses CMake buildsystem and pkg-config

* To compile (natively) type:

```
mkdir build
cd build
cmake ..
make
```

* To cross-compile you need a cross-toolchain in your path that has a relevant sysroot inside. You have to pass -DCROSS_COMPILE=prefix and -DCMAKE_LIBRARY_PATH to cmake

Example:
```
mkdir build
cd build
cmake .. -DCROSS_COMPILE=arm-rcm-linux-gnueabihf -DCMAKE_LIBRARY_PATH=arm-linux-gnueabihf
make
```

* Alternatively you can provide your own cmake toolchain file as described in cmake wiki: http://www.vtk.org/Wiki/CMake_Cross_Compiling

```
mkdir build
cd build
cmake .. -DCMAKE_TOOLCHAIN_FILE=../toolchain.cmake
make
```
