makefile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
makefile_dir := $(dir $(makefile_path))

SOURCES := $(makefile_dir)

VPATH := $(SOURCES)

# Get list of folders
MODULES := $(shell find $(SOURCES)src -type d)

# look for include files in each of the modules
CFLAGS += $(patsubst %,-I%,	$(MODULES)) -fPIC
CXXFLAGS += $(patsubst %,-I%,	$(MODULES)) -fPIC

# each module will add to these variables
# Name of binaries
APPLICATIONS :=
# Name of library (e.g. : libTest.so)
LIBRARIES :=
# List of objects to compute dependencies
OBJ :=

# Tools
RM := rm -f
MKDIR := mkdir -p
LN := ln -sfn


# include the description for each module if any
-include $(patsubst %,%/module.mk,$(MODULES))

.SILENT:

$(info Availables APPLICATIONS are $(APPLICATIONS))
$(info Availables LIBRARIES are $(LIBRARIES))

.PHONY: all clean lib app

# By default build all
all: $(APPLICATIONS) $(LIBRARIES)
app: $(APPLICATIONS)
lib: $(LIBRARIES)

# In order to define the application and library prerequisite with a variable starting with target name
# Example: the .o needed by prog application are listed in prog_OBJS variable
.SECONDEXPANSION:

# Define how to build an application
# <xxx> : application name
# <xxx>_OBJS : objects linked to build the application
# <xxx>_SYSLIBS : libraries linked to build the application (system libs)
# <xxx>_USERLIBS : libraries linked to build the application (user libs)
# <xxx>_USERLIBSDEP : dependencies on user libraries (user libs)

$(APPLICATIONS):  $$($$@_USERLIBSDEP)
$(APPLICATIONS):  $$($$@_OBJS)
	echo Build application $@ with $^ objects and $($@_SYSLIBS) $($@_USERLIBS) libraries
	$(CXX) $(LDFLAGS) -o $@ $^ $($@_USERLIBS) $($@_SYSLIBS) -L ./


# Define how to build a library
# <xxx> : library base name (e.g.: libTest.so -> Test)
# <xxx>_OBJS : objects linked to build the library
# <xxx>_SYSLIBS : libraries linked to build the library (system libs)
# <xxx>_USERLIBS : libraries linked to build the library (user libs)
# <xxx>_USERLIBSDEP : dependencies on user libraries (user libs)
# <xxx>_NAME : library name 
# <xxx>_SONAME : lib name + major version = API version
# <xxx>_VER : library versions major.minor.build

define get_lib_basename
$(patsubst lib%.so,%,$@)
endef

$(LIBRARIES):  $$($$@_OBJS) $$($$@_LIBSDEP)
	echo Lib fullname: $@, basename: $(get_lib_basename)
	echo Build library $@ with $^ objects and $($@_LIBS) libraries
#	echo depend on $($(@F)_LIBSDEP) libraries
	$(CXX) -shared $(LDFLAGS) -Wl,-soname,$($@_SONAME) -o $($@_NAME).$($@_VER) $^ $($@_LIBS)
	$(LN) $($@_NAME).$($@_VER) $@


# Don't rebuild dependencies if clean is requested
ifneq ($(MAKECMDGOALS),clean)

# build C/CPP include dependencies
%.d: %.cpp
	echo Rebuild dependency for $<
	DIR=$$(dirname $*); \
	$(MKDIR) $${DIR}; \
	$(CXX) -MM -MG $(CFLAGS) $< | sed -e "s@^\(.*\).o:@$$DIR/\1.d $$DIR/\1.o:@" > $@

# include the C include dependencies if any and trigger dependencies refresh if files is missing
-include $(OBJ:.o=.d)
endif


clean:
	$(RM) $(APPLICATIONS) $(LIBRARIES)
	$(RM) `find . -name "*.o"`
	$(RM) `find . -name "*.a"`
	$(RM) `find . -name "*.map"`
	$(RM) `find . -name "*.so*"`
	$(RM) `find . -name "*.d"`
	

