AS=nasm
ASFLAGS=-f bin
DD=cat
SOURCES=bootsect.asm \
	mainboot.asm
OBJECTS=$(SOURCES:.asm=.o)
EXECUTABLE=bootloader.com

%.o: %.asm
	@echo Compiling $< from $(OBJECTS)
	$(AS) $(ASFLAGS) $< -o $@

$(EXECUTABLE):$(OBJECTS)
	$(DD) $^ > boot.bin

.PHONY: clean
clean:
	rm *.bin
	rm *.o
