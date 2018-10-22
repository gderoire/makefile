LIB_DIRECTORY := src/lib_hello

# List of source files
LIB_SOURCES := $(LIB_DIRECTORY)/libhello.cpp $(LIB_DIRECTORY)/libhello2.cpp

# Name of the target to build
LIB := libhello.so

# Library versions
# Major version is used in soname to state that all library with same major version are backward compatibles
$(LIB)_MAJOR_VER := 1
$(LIB)_MINOR_VER := 0
$(LIB)_BUILD_VER := 0

# List of libs to be passed to the linker (e.g.: -lthread)
$(LIB)_SYSLIBS :=
$(LIB)_USERLIBS :=

# -------------- Common --------------

# List of dependencies on user libraries to be build before
$(LIB)_USERLIBSDEP := $(patsubst -l%,lib%.so,$($(LIB)_USERLIBS))

# List of libraries to link with
$(LIB)_LIBS := $($(LIB)_SYSLIBS) $($(LIB)_USERLIBS)

# Soname including Major version. Major version is ABI/API version
$(LIB)_SONAME := $(LIB).$($(LIB)_MAJOR_VER)

# Library realname with version append
$(LIB)_REALNAME := $(LIB).$($(LIB)_MAJOR_VER).$($(LIB)_MINOR_VER).$($(LIB)_BUILD_VER)

# List of objects to be passed to the linker
$(LIB)_OBJS := $(patsubst %.cpp,%.o, $(LIB_SOURCES))

# List of source to be checked for dependencies
OBJ += $($(LIB)_OBJS)

# Append to list of applications that can be built
LIBRARIES += $(LIB)


