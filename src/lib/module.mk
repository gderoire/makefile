LOCAL_SRC := src/lib/lib.cpp

# Name of the target to build
LIBRARIES += libTest.so

# List of objects used to build target 
libTest.so_OBJS := $(patsubst %.cpp,%.o, $(LOCAL_SRC))

# List of libs to be linked in the target
libTest.so_LIBS := 

OBJ += $(libTest.so_OBJS)


