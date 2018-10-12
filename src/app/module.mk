LOCAL_SRC := src/app/app.cpp

# Name of the target to build
APPLICATIONS += prog

# List of objects used to build target 
prog_OBJS := $(patsubst %.cpp,%.o, $(LOCAL_SRC))

# List of libs to be linked in the target
prog_LIBS := -llib
#lib1 lib2

OBJ += $(prog_OBJS)
