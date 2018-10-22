rm -rf build
mkdir build
cd build
time make -f ../Makefile -j8
export LD_LIBRARY_PATH=.
./app_hello
./app_foo
./app_lib
