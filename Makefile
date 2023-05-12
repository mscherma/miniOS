DD=cat

all:
	@cd boot; $(MAKE)
	@cd kernel; $(MAKE)

	@mkdir -p bin;
	@cp boot/boot.bin bin/boot.bin
	$(DD) kernel/kentry.o >> bin/boot.bin

clean:
	@cd boot; $(MAKE) clean
	@cd kernel; $(MAKE) clean

	@rm -rf ./bin/
