LOCAL_SRC := src/lib/lib.cpp

# Name of the target to build
LIBRARIES += lib

# List of objects used to build target 
lib_OBJS := $(patsubst %.cpp,%.o, $(LOCAL_SRC))

# List of libs to be linked in the target
lib_LIBS := 

OBJ += $(lib_OBJS)
