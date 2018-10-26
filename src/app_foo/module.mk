CURRENT_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_DIRECTORY := $(dir $(CURRENT_PATH))
CURRENT_DIRECTORY := $(subst $(makefile_dir),,$(CURRENT_DIRECTORY))

# List of source files
APP_SOURCES := app_foo.cpp

# Name of the target to build
APP := app_foo

# List of libs to be passed to the linker (e.g.: -lthread)
$(APP)_SYSLIBS :=
$(APP)_USERLIBS := -lbar

$(eval $(append_application_to_targets))
