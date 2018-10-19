APP_DIRECTORY := src/app

# List of source files
APP_SOURCES := $(APP_DIRECTORY)/app.cpp

# Name of the target to build
APP := prog

# List of libs to be passed to the linker
$(APP)_SYSLIBS :=
$(APP)_USERLIBS := -ltestlib

# -------------- Common --------------

# List of objects to be passed to the linker
$(APP)_OBJS := $(patsubst %.cpp,%.o, $(APP_SOURCES))

# List of source to be checked for dependencies
OBJ += $($(APP)_OBJS)

# Append to list of applications that can be built
APPLICATIONS += $(APP)

# List of dependencies on user libraries
$(APP)_USERLIBSDEP := $(patsubst -l%,lib%.so,$($(APP)_USERLIBS))


