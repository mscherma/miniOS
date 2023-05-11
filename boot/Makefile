AS=nasm
ASFLAGS=-f bin
DD=cat
SOURCES=bootsect.asm \
	mainboot.asm
OBJECTS=$(SOURCES:.asm=.o)
EXECUTABLE=boot.bin

%.o: %.asm
	@echo Compiling $< from $(OBJECTS)
	$(AS) $(ASFLAGS) $< -o $@

$(EXECUTABLE):$(OBJECTS)
	$(DD) $^ > $@
	mkdir -p ../bin/
	cp $@ ../bin/

.PHONY: clean
clean:
	rm *.bin
	rm *.o
