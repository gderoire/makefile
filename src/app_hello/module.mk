APP_DIRECTORY := src/app_hello

# List of source files
APP_SOURCES := $(APP_DIRECTORY)/app.cpp

# Name of the target to build
APP := app_hello

# List of libs to be passed to the linker (e.g.: -lthread)
$(APP)_SYSLIBS :=
$(APP)_USERLIBS := -lhello

# -------------- Common --------------

# List of dependencies on user libraries
$(APP)_USERLIBSDEP := $(patsubst -l%,lib%.so,$($(APP)_USERLIBS))

# List of libraries to link with
$(APP)_LIBS := $($(APP)_SYSLIBS) $($(APP)_USERLIBS)

# List of objects to be passed to the linker
$(APP)_OBJS := $(patsubst %.cpp,%.o, $(APP_SOURCES))

# List of source to be checked for dependencies
OBJ += $($(APP)_OBJS)

# Append to list of applications that can be built
APPLICATIONS += $(APP)

