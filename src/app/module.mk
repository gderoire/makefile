LOCAL_SRC := src/app/app.cpp

# Name of the target to build
APPLICATIONS += prog

# List of objects used to build target 
prog_OBJS := $(patsubst %.cpp,%.o, $(LOCAL_SRC))

# List of libs to be linked in the target
prog_LIBS := -ltestlib

prog_LIBSDEP := libtestlib.so

#$(info prog_OBJS: $(prog_OBJS))
#$(info prog_LIBS: $(prog_LIBS))
#$(info prog_LIBSDEP: $(prog_LIBSDEP))


OBJ += $(prog_OBJS)
