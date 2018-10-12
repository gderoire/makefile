# Get list of folders
MODULES := $(shell find . -type d)

# look for include files in each of the modules
CFLAGS += $(patsubst %,-I%,	$(MODULES)) -fPIC
CXXFLAGS += $(patsubst %,-I%,	$(MODULES)) -fPIC

# each module will add to this
APPLICATIONS :=
LIBRARIES := 

# determine the object files for dependencies
OBJ :=
#	\
#	$(patsubst %.cpp,%.o, $(filter %.cpp,$(SRC))) \
#	$(patsubst %.c,%.o,	$(filter %.c,$(SRC)))

# include the description for each module if any
-include $(patsubst %,%/module.mk,$(MODULES))

.SILENT:

BIN := bin
TARGET_APPLICATIONS := $(APPLICATIONS:%=$(BIN)/%)

LIB := lib
TARGET_LIBRARIES := $(LIBRARIES:%=$(LIB)/%)

$(info APPLICATIONS is $(APPLICATIONS))
$(info LIBRARIES is $(LIBRARIES))

.PHONY: all clean

all: $(TARGET_APPLICATIONS) $(TARGET_LIBRARIES)

# link the program
# $$($$@_OBJ) -> target_OBJS
.SECONDEXPANSION:
$(TARGET_APPLICATIONS):  $$($$(@F)_OBJS)
	echo Build application $@ with \'$^\' objects and \'$($(@F)_LIBS)\' libraries
	mkdir -p $(BIN)
	$(CXX) $(LDFLAGS) -o $@ $^ $($(@F)_LIBS)

.SECONDEXPANSION:
$(TARGET_LIBRARIES):  $$($$(@F)_OBJS)
	echo Build library $@ with \'$^\' objects and \'$($(@F)_LIBS)\' libraries
	mkdir -p $(LIB)
	$(CXX) -shared $(LDFLAGS) -o $@.so $^ $($(@F)_LIBS) -L $(BIN)

# include the C include dependencies if any and trigger dependencies refresh if files is missing
-include $(OBJ:.o=.d)

#calculate C/CPP include dependencies
%.d: %.cpp
	echo Rebuild dependency for $<
	DIR=$$(dirname $*); \
	$(CXX) -MM -MG $(CFLAGS) $< | sed -e "s@^\(.*\).o:@$$DIR/\1.d $$DIR/\1.o:@" > $@


clean:
	rm -rf $(BIN)
	rm -rf $(LIB)
	rm -f `find . -name "*.o"`
	rm -f `find . -name "*.a"`
	rm -f `find . -name "*.map"`
	rm -f `find . -name "*.so*"`
	rm -f `find . -name "*.d"`
	

