LIB_DIRECTORY := src/lib

# List of source files
LIB_SOURCES := $(LIB_DIRECTORY)/lib.cpp $(LIB_DIRECTORY)/lib2.cpp

# Name of the target to build
LIB := testlib
# Base library name
LIB_REALNAME := lib$(LIB).so

$(LIB_REALNAME)_NAME := $(LIB_REALNAME)

# Library versions. Major version is used in soname to state that all library with same major version are backward compatibles
$(LIB_REALNAME)_MAJOR_VER := 1
$(LIB_REALNAME)_MINOR_VER := 0
$(LIB_REALNAME)_BUILD_VER := 0

# List of libs to be passed to the linker
$(LIB_REALNAME)_SYSLIBS :=
$(LIB_REALNAME)_USERLIBS := -ltestlib

# -------------- Common --------------

# List of objects to be passed to the linker
$(LIB_REALNAME)_OBJS := $(patsubst %.cpp,%.o, $(LIB_SOURCES))

# List of source to be checked for dependencies
OBJ += $($(LIB_REALNAME)_OBJS)

# Append to list of applications that can be built
LIBRARIES += $(LIB_REALNAME)

# List of dependencies on user libraries
$(LIB_REALNAME)_USERLIBSDEP := $(patsubst -l%,lib%.so,$($(LIB_REALNAME)_USERLIBS))

# Soname including Major version. Major version is ABI/API version
$(LIB_REALNAME)_SONAME := $($(LIB_REALNAME)_NAME).$($(LIB_REALNAME)_MAJOR_VER)
# Full version append to end of library name
$(LIB_REALNAME)_VER := $($(LIB_REALNAME)_MAJOR_VER).$($(LIB_REALNAME)_MINOR_VER).$($(LIB_REALNAME)_BUILD_VER)

