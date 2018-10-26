makefile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
makefile_dir := $(dir $(makefile_path))

SOURCES := $(makefile_dir)

VPATH := $(SOURCES)

# Get list of folders
MODULES := $(shell find $(SOURCES)src -type d)

# look for include files in each of the modules
# Include all folder for header search
#CFLAGS += $(patsubst %,-I%,	$(MODULES))
#CXXFLAGS += $(patsubst %,-I%,	$(MODULES))
# Include base source folder for header search
CFLAGS += -I$(SOURCES)src
CXXFLAGS += -I$(SOURCES)src

# each module will add to these variables
# Name of binaries
APPLICATIONS :=
# Name of library (e.g. : libTest.so)
LIBRARIES :=
# List of objects to compute dependencies
OBJ :=
# Library objects that have to be built with -fPIC flag
LIBOBJ :=

# Tools
RM := rm -f
MKDIR := mkdir -p
LN := ln -sfn

define append_application_to_targets
 # List of dependencies on user libraries
 $(APP)_USERLIBSDEP := $(patsubst -l%,lib%.so,$($(APP)_USERLIBS))

 # List of libraries to link with
 $(APP)_LIBS := $$($(APP)_SYSLIBS) $$($(APP)_USERLIBS)

 # List of objects to be passed to the linker
 $(APP)_OBJS := $(patsubst %.cpp,$(CURRENT_DIRECTORY)%.o, $(APP_SOURCES))

 # List of source to be checked for dependencies
 OBJ += $$($(APP)_OBJS)

 # Append to list of applications that can be built
 APPLICATIONS += $(APP)
endef

define append_library_to_targets
 # List of dependencies on user libraries to be build before
 $(LIB)_USERLIBSDEP := $(patsubst -l%,lib%.so,$($(LIB)_USERLIBS))

 # List of libraries to link with
 $(LIB)_LIBS := $$($(LIB)_SYSLIBS) $$($(LIB)_USERLIBS)

 # Soname including Major version. Major version is ABI/API version
 $(LIB)_SONAME := $(LIB).$$($(LIB)_MAJOR_VER)

 # Library realname with version append
 $(LIB)_REALNAME := $(LIB).$$($(LIB)_MAJOR_VER).$$($(LIB)_MINOR_VER).$$($(LIB)_BUILD_VER)

 # List of objects to be passed to the linker
 $(LIB)_OBJS := $(patsubst %.cpp,$(CURRENT_DIRECTORY)%.o, $(LIB_SOURCES))

 # List of source to be checked for dependencies
 LIBOBJ += $$($(LIB)_OBJS)

 # Append to list of applications that can be built
 LIBRARIES += $(LIB)
endef

# include the description for each module if any
-include $(patsubst %,%/module.mk,$(MODULES))

.SILENT:

$(info Availables APPLICATIONS are $(APPLICATIONS))
$(info Availables LIBRARIES are $(LIBRARIES))
$(info Availables objects for application are $(OBJ))
$(info Availables objects for library are $(LIBOBJ))

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
# <xxx>_LIBS : libraries linked to build the application
# <xxx>_USERLIBSDEP : dependencies on user libraries (user libs)

$(APPLICATIONS):  $$($$@_USERLIBSDEP)
$(APPLICATIONS):  $$($$@_OBJS)
	echo Build application $@ with $^ objects and $($@_LIBS) libraries
	$(CXX) $(LDFLAGS) -o $@ $^ $($@_LIBS) -L ./


# Define how to build a library
# <xxx> : library base name (e.g.: libTest.so -> Test)
# <xxx>_OBJS : objects linked to build the library
# <xxx>_LIBS : libraries linked to build the library
# <xxx>_USERLIBSDEP : libraries that need to be built before
# <xxx>_REALNAME : library name with version append
# <xxx>_SONAME : lib name + major version = API version

$(LIBRARIES):  $$($$@_USERLIBSDEP)
$(LIBRARIES):  $$($$@_OBJS)
	echo Build library $@ with $^ objects and $($@_LIBS) libraries
	$(CXX) -shared $(LDFLAGS) -Wl,-soname,$($@_SONAME) -o $($@_REALNAME) $^ $($@_LIBS)
	# Link to use the specific version for compilation ($@ is passed to linker)
	$(LN) $($@_REALNAME) $@
	# Link to use the specific version at runtime (SONAME is stored in caller binary)
	$(LN) $($@_REALNAME) $($@_SONAME)

# Add -fPIC flag only for Objects used in libraries
$(LIBOBJ): CFLAGS += -fPIC
$(LIBOBJ): CXXFLAGS += -fPIC


# Don't rebuild dependencies if clean is requested
ifneq ($(MAKECMDGOALS),clean)

# build C/CPP include dependencies
%.d: %.cpp
	echo Rebuild dependency for $<
	DIR=$$(dirname $*); \
	$(MKDIR) $${DIR}; \
	$(CXX) -MM -MG $(CFLAGS) $< | sed -e "s@^\(.*\).o:@$$DIR/\1.d $$DIR/\1.o:@" > $@

# include the C include dependencies if any and trigger dependencies refresh if files is missing
-include $(OBJ:.o=.d) $(LIBOBJ:.o=.d)
endif


clean:
	$(RM) $(APPLICATIONS) $(LIBRARIES)
	$(RM) `find . -name "*.o"`
	$(RM) `find . -name "*.a"`
	$(RM) `find . -name "*.map"`
	$(RM) `find . -name "*.so*"`
	$(RM) `find . -name "*.d"`
	

