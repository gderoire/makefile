CURRENT_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_DIRECTORY := $(dir $(CURRENT_PATH))

# List of source files
APP_SOURCES := app.cpp

# Name of the target to build
APP := app_lib

# List of libs to be passed to the linker (e.g.: -lthread)
$(APP)_SYSLIBS :=
$(APP)_USERLIBS := -llib

$(eval $(append_application_to_targets))

# -------------- Lib --------------

# List of source files
LIB_SOURCES := liblib.cpp

# Name of the target to build
LIB := liblib.so

# Library versions
# Major version is used in soname to state that all library with same major version are backward compatibles
$(LIB)_MAJOR_VER := 1
$(LIB)_MINOR_VER := 0
$(LIB)_BUILD_VER := 0

# List of libs to be passed to the linker (e.g.: -lthread)
$(LIB)_SYSLIBS :=
$(LIB)_USERLIBS :=

#$(info $(append_library_to_targets))
$(eval $(append_library_to_targets))

