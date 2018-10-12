MODULES := src/app 

# look for include files in each of the modules
CFLAGS += $(patsubst %,-I%,	$(MODULES))

# each module will add to this
#SRC :=

# each module will add to this
TARGET :=

# include the description for each module
include $(patsubst %,%/module.mk,$(MODULES))

# determine the object files for dependencies
OBJ :=
#	\
#	$(patsubst %.cpp,%.o, $(filter %.cpp,$(SRC))) \
#	$(patsubst %.c,%.o,	$(filter %.c,$(SRC)))

all: $(TARGET)

# link the program
# $$($$@_OBJ) -> target_OBJS
.SECONDEXPANSION:
$(TARGET):  $$($$@_OBJS)
	@echo Build $@ with $^ objects and $($@_LIBS) libraries
	$(CXX) -o $@ $^ $($@_LIBS)


# include the C include dependencies
include $(OBJ:.o=.d)

#calculate C/CPP include dependencies
%.d: %.cpp
	@echo Rebuild dependency for $<
	@DIR=$$(dirname $*); \
	$(CXX) -MM -MG $(CFLAGS) $< | sed -e "s@^\(.*\).o:@$$DIR/\1.d $$DIR/\1.o:@" > $@


clean:
	@rm -fv `find . -name "*.o"`
	@rm -fv `find . -name "*.a"`
	@rm -fv `find . -name "*.map"`
	@rm -fv `find . -name "*.so*"`
	@rm -fv `find . -name "*.d"`
	

