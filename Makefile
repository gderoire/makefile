makefile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
makefile_dir := $(dir $(makefile_path))

SOURCES := $(makefile_dir)

VPATH := $(SOURCES)

# Get list of folders
MODULES := $(shell find $(SOURCES)src -type d)

# look for include files in each of the modules
CFLAGS += $(patsubst %,-I%,	$(MODULES)) -fPIC
CXXFLAGS += $(patsubst %,-I%,	$(MODULES)) -fPIC

# each module will add to this
APPLICATIONS :=
LIBRARIES :=
OBJ :=

# Tools
RM := rm -f
MKDIR := mkdir -p


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
# <xxx>_LIBS : libraries linked to build the application (system libs)
# <xxx>_LIBSDEP : libraries that are needed by application (user libs)

$(APPLICATIONS):  $$($$(@F)_LIBSDEP)
$(APPLICATIONS):  $$($$(@F)_OBJS)
	echo Build application $@ with $^ objects and $($(@F)_LIBS) libraries
#	echo depend on $($(@F)_LIBSDEP) libraries
	$(CXX) $(LDFLAGS) -o $@ $^ $($(@F)_LIBS) -L ./


# Define how to build a library
$(LIBRARIES):  $$($$(patsubst lib%.so,%,$$(@F))_OBJS) $$($$(patsubst lib%.so,%,$$(@F))_LIBSDEP)
	echo Build library $@ with $^ objects and $($(@F)_LIBS) libraries
#	echo depend on $($(@F)_LIBSDEP) libraries
	$(CXX) -shared $(LDFLAGS) -o $@ $^ $($(@F)_LIBS)

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
	$(RM) $(TARGET)
	$(RM) `find . -name "*.o"`
	$(RM) `find . -name "*.a"`
	$(RM) `find . -name "*.map"`
	$(RM) `find . -name "*.so*"`
	$(RM) `find . -name "*.d"`
	

