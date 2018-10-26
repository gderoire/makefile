CURRENT_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_DIRECTORY := $(dir $(CURRENT_PATH))
CURRENT_DIRECTORY := $(subst $(makefile_dir),,$(CURRENT_DIRECTORY))

# List of source files
APP_SOURCES := app.cpp

# Name of the target to build
APP := app_hello

# List of libs to be passed to the linker (e.g.: -lthread)
$(APP)_SYSLIBS :=
$(APP)_USERLIBS := -lhello

$(eval $(append_application_to_targets))

