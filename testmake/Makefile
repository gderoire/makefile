TARGET:=target1 target2

all: $(TARGET)

# Direct
#$(TARGET): %: %.d

# With variable indirection
target1_OBJS:=target1.d
target2_OBJS:=target2.d
.SECONDEXPANSION:
$(TARGET): $$($$(@F)_OBJS)


.SILENT:

target1:
	echo Target1

target2:
	echo Target2

target1.d:
	echo Depend1

target2.d:
	echo Depend2

