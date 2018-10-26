CURRENT_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_DIRECTORY := $(dir $(CURRENT_PATH))
CURRENT_DIRECTORY := $(subst $(makefile_dir),,$(CURRENT_DIRECTORY))

# List of source files
LIB_SOURCES := libbar.cpp

# Name of the target to build
LIB := libbar.so

# Library versions
# Major version is used in soname to state that all library with same major version are backward compatibles
$(LIB)_MAJOR_VER := 2
$(LIB)_MINOR_VER := 1
$(LIB)_BUILD_VER := 0

# List of libs to be passed to the linker (e.g.: -lthread)
$(LIB)_SYSLIBS :=
$(LIB)_USERLIBS :=

$(eval $(append_library_to_targets))
