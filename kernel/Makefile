AS=nasm
ASFLAGS=-f bin
DD=cat
SOURCES=kentry.asm
OBJECTS=$(SOURCES:.asm=.o)

TARGET=minikrnl.bin

%.o: %.asm
	@echo Compiling $< from $(OBJECTS)
	$(AS) $(ASFLAGS) $< -o $@

$(TARGET): $(OBJECTS)
	@echo Compiled $(OBJECTS)

.PHONY: clean
clean:
	rm *.o
