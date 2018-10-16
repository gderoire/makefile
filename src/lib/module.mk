LIB_DIRECTORY := src/lib

# List of source files
LIB_SOURCES := $(LIB_DIRECTORY)/lib.cpp

# Name of the target to build
LIB := testlib
$(LIB)_NAME :=
$(LIB)_SONAME :=
$(LIB)_VER :=

# List of libs to be passed to the linker
$(LIB)_SYSLIBS :=
$(LIB)_USERLIBS := -ltestlib

# -------------- Common --------------

# List of objects to be passed to the linker
$(LIB)_OBJS := $(patsubst %.cpp,%.o, $(LIB_SOURCES))

# List of source to be checked for dependencies
OBJ += $($(LIB)_OBJS)

# Append to list of applications that can be built
LIBRARIES += lib$(LIB).so

# List of dependencies on user libraries
$(LIB)_USERLIBSDEP := $(patsubst -l%,lib%.so,$($(LIB)_USERLIBS))

