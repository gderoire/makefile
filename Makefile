mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir := $(dir $(mkfile_path))

SOURCES := $(mkfile_dir)

VPATH := $(SOURCES)

# Get list of folders
MODULES := $(shell find $(SOURCES)src -type d)
#$(warning Modules list $(MODULES))

# look for include files in each of the modules
CFLAGS += $(patsubst %,-I%,	$(MODULES))

# each module will add to this
TARGET :=

# each module will add to this (path is relative to $(SOURCES) )
OBJ :=
#	\
#	$(patsubst %.cpp,%.o, $(filter %.cpp,$(SRC))) \
#	$(patsubst %.c,%.o,	$(filter %.c,$(SRC)))

# Tools
RM := rm -f
MKDIR := mkdir -p



# include the description for each module if any
-include $(patsubst %,%/module.mk,$(MODULES))

.SILENT:

all: $(TARGET)

# link the program
# $$($$@_OBJ) -> target_OBJS
.SECONDEXPANSION:
$(TARGET):  $$($$@_OBJS)
	echo Build $@ with $^ objects and $($@_LIBS) libraries
	$(CXX) -o $@ $^ $($@_LIBS)

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
	

