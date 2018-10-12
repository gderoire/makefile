LOCAL_SRC := src/app/app.cpp

# Name of the target to build
TARGET += prog

# List of objects used to build target 
prog_OBJS := $(patsubst %.cpp,%.o, $(LOCAL_SRC))

# List of libs to be linked in the target
prog_LIBS := 
#lib1 lib2

OBJ += $(prog_OBJS)
