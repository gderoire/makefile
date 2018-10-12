# Get list of folders
MODULES := $(shell find . -type d)

# look for include files in each of the modules
CFLAGS += $(patsubst %,-I%,	$(MODULES))

# each module will add to this
TARGET :=

# determine the object files for dependencies
OBJ :=
#	\
#	$(patsubst %.cpp,%.o, $(filter %.cpp,$(SRC))) \
#	$(patsubst %.c,%.o,	$(filter %.c,$(SRC)))

# include the description for each module if any
-include $(patsubst %,%/module.mk,$(MODULES))

.SILENT:

BIN := bin
TARGETBIN := $(TARGET:%=$(BIN)/%)

.PHONY: all clean

all: $(TARGETBIN)

# link the program
# $$($$@_OBJ) -> target_OBJS
.SECONDEXPANSION:
$(TARGETBIN):  $$($$(@F)_OBJS)
	echo Build $@ with \'$^\' objects and \'$($(@F)_LIBS)\' libraries
	mkdir -p $(BIN)
	$(CXX) -o $@ $^ $($(@F)_LIBS)

# include the C include dependencies if any and trigger dependencies refresh if files is missing
-include $(OBJ:.o=.d)

#calculate C/CPP include dependencies
%.d: %.cpp
	echo Rebuild dependency for $<
	DIR=$$(dirname $*); \
	$(CXX) -MM -MG $(CFLAGS) $< | sed -e "s@^\(.*\).o:@$$DIR/\1.d $$DIR/\1.o:@" > $@


clean:
	rm -f $(TARGET)
	rm -f `find . -name "*.o"`
	rm -f `find . -name "*.a"`
	rm -f `find . -name "*.map"`
	rm -f `find . -name "*.so*"`
	rm -f `find . -name "*.d"`
	

