LOCAL_SRC := src/app/app.cpp

# Name of the target to build
APPLICATIONS += prog

# List of objects used to build target 
prog_OBJS := $(patsubst %.cpp,%.o, $(LOCAL_SRC))

# List of libs to be linked in the target
prog_LIBS := -lTest
#lib1 lib2

bin/prog: lib/libTest.so

OBJ += $(prog_OBJS)
