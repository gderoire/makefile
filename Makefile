mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir := $(dir $(mkfile_path))

SOURCES := $(mkfile_dir)

VPATH := $(SOURCES)

# Get list of folders
MODULES := $(shell find $(SOURCES)src -type d)
#$(warning Modules list $(MODULES))

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

$(info APPLICATIONS is $(APPLICATIONS))
$(info LIBRARIES is $(LIBRARIES))

.PHONY: all clean lib app

all: $(APPLICATIONS) $(LIBRARIES)

# link the program
# $$($$@_OBJ) -> target_OBJS
app:$(APPLICATIONS)
.SECONDEXPANSION:
$(APPLICATIONS):  $$($$(@F)_LIBSDEP)
$(APPLICATIONS):  $$($$(@F)_OBJS)
	echo Build application $@ with $^ objects and $($(@F)_LIBS) libraries
#	echo depend on $($(@F)_LIBSDEP) libraries
	$(CXX) $(LDFLAGS) -o $@ $^ $($(@F)_LIBS) -L ./

lib:$(LIBRARIES)

.SECONDEXPANSION:
#$(LIBRARIES):  $$($$(@F)_OBJS) $$($$(@F)_LIBSDEP)
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
	

