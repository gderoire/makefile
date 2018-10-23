CURRENT_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_DIRECTORY := $(dir $(CURRENT_PATH))

# List of source files
LIB_SOURCES := libhello.cpp libhello2.cpp

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

$(eval $(append_library_to_targets))
