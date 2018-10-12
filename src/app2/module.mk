LOCAL_SRC := src/app2/app.cpp

# Name of the target to build
TARGET += prog2

# List of objects used to build target 
prog2_OBJS := $(patsubst %.cpp,%.o, $(LOCAL_SRC))

# List of libs to be linked in the target
prog2_LIBS := 

OBJ += $(prog2_OBJS)
