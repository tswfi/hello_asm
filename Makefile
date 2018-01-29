all: hello.o
	ld -o hello hello.o

hello.o: hello.asm
	nasm -f elf64 -l hello.lst -g -F dwarf hello.asm

clean:
	rm hello.o hello
