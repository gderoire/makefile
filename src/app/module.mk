LOCAL_DIR := src/app
LOCAL_SRC := $(LOCAL_DIR)/app.cpp

# Name of the target to build
APPLICATIONS += prog

# List of objects used to build target 
prog_OBJS := $(patsubst %.cpp,%.o, $(LOCAL_SRC))

# List of libs to be linked to the target
prog_SYSLIBS :=
prog_USERLIBS := -ltestlib

#$(info prog_OBJS: $(prog_OBJS))
#$(info prog_LIBS: $(prog_LIBS))
#$(info prog_LIBSDEP: $(prog_LIBSDEP))

# List of Userlibs required (dependencies)
prog_USERLIBSDEP := $(patsubst -l%,lib%.so,$(prog_USERLIBS))

OBJ += $(prog_OBJS)
