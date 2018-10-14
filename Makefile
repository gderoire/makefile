SOURCES := ../

VPATH := $(SOURCES)

# Get list of folders
MODULES := $(shell find $(SOURCES) -type d)

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

all: $(TARGET)

# link the program
# $$($$@_OBJ) -> target_OBJS
.SECONDEXPANSION:
$(TARGET):  $$($$@_OBJS)
	@echo Build $@ with $^ objects and $($@_LIBS) libraries
	$(CXX) -o $@ $^ $($@_LIBS)


# include the C include dependencies if any and trigger dependencies refresh if files is missing
-include $(OBJ:.o=.d)

#calculate C/CPP include dependencies
%.d: %.cpp
	@echo Rebuild dependency for $<
	@DIR=$$(dirname $*); \
	mkdir -p $${DIR}; \
	$(CXX) -MM -MG $(CFLAGS) $< | sed -e "s@^\(.*\).o:@$$DIR/\1.d $$DIR/\1.o:@" > $@


clean:
	@rm -f $(TARGET)
	@rm -f `find . -name "*.o"`
	@rm -f `find . -name "*.a"`
	@rm -f `find . -name "*.map"`
	@rm -f `find . -name "*.so*"`
	@rm -f `find . -name "*.d"`
	

