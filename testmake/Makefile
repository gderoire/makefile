TARGET:=target1 target2

all: $(TARGET)

# Direct
#$(TARGET): %: %.d

# With variable indirection
target1_OBJS:=target1.d
target2_OBJS:=target2.d
.SECONDEXPANSION:
# With @F
#$(TARGET): $$($$(@F)_OBJS)
# Simpler with % pattern
$(TARGET): % : $$(%_OBJS) $$(info Target: $$@)


.SILENT:

target1:
	echo Target1
	echo Target1 dependencies: $^

target2:
	echo Target2
	echo Target2 dependencies: $^

target1.d:
	echo Depend1

target2.d:
	echo Depend2

