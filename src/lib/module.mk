LOCAL_DIR := src/lib
LOCAL_SRC := $(LOCAL_DIR)/lib.cpp

# Name of the library to build
LIBRARIES += libtestlib.so

# List of objects used to build target 
testlib_OBJS := $(patsubst %.cpp,%.o, $(LOCAL_SRC))

# List of libs to be linked in the target
testlib_LIBS :=  

#$(info testlib_OBJS: $(testlib_OBJS))
#$(info testlib_LIBS: $(testlib_LIBS))
#$(info testlib_LIBSDEP: $(testlib_LIBSDEP))

OBJ += $(testlib_OBJS)
