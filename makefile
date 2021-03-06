SHELL := /bin/bash

export PATH := $(PATH):$(shell pwd)/cross/bin

CC = x86_64-elf-gcc
CXX = x86_64-elf-g++
NASM = nasm -f elf64 -g
GAS = x86_64-elf-as
LD = x86_64-elf-ld

LOOP_ONE = /dev/loop7
LOOP_TWO = /dev/loop8

SHARED_SOURCE_DIR = src/shared
SHARED_SOURCES_CXX = $(shell find $(SHARED_SOURCE_DIR) -name "*.cc")
SHARED_SOURCES_C = $(shell find $(SHARED_SOURCE_DIR) -name "*.c")
SHARED_SOURCES_GAS = $(shell find $(SHARED_SOURCE_DIR) -name "*.s")
SHARED_SOURCES_NASM = $(shell find $(SHARED_SOURCE_DIR) -name "*.asm")

SHARED_HEADERS = $(shell find $(SHARED_SOURCE_DIR) -name "*.h")

KERNEL_SOURCE_DIR = src/kernel
KERNEL_BUILD_DIR = build/kernel
KERNEL_SOURCES_CXX = $(shell find $(KERNEL_SOURCE_DIR) -name "*.cc")
KERNEL_SOURCES_C = $(shell find $(KERNEL_SOURCE_DIR) -name "*.c")
KERNEL_SOURCES_GAS = $(shell find $(KERNEL_SOURCE_DIR) -name "*.s")
KERNEL_SOURCES_NASM = $(shell find $(KERNEL_SOURCE_DIR) -name "*.asm")
KERNEL_OBJECTS_CXX = $(addprefix $(KERNEL_BUILD_DIR)/,$(KERNEL_SOURCES_CXX:$(KERNEL_SOURCE_DIR)/%.cc=%.o))
KERNEL_OBJECTS_C = $(addprefix $(KERNEL_BUILD_DIR)/,$(KERNEL_SOURCES_C:$(KERNEL_SOURCE_DIR)/%.c=%.o))
KERNEL_OBJECTS_GAS = $(addprefix $(KERNEL_BUILD_DIR)/,$(KERNEL_SOURCES_GAS:$(KERNEL_SOURCE_DIR)/%.s=%.o))
KERNEL_OBJECTS_NASM = $(addprefix $(KERNEL_BUILD_DIR)/,$(KERNEL_SOURCES_NASM:$(KERNEL_SOURCE_DIR)/%.asm=%.o))
KERNEL_SHARED_OBJECTS_CXX = $(addprefix $(KERNEL_BUILD_DIR)/,$(SHARED_SOURCES_CXX:$(SHARED_SOURCE_DIR)/%.cc=%.o))
KERNEL_SHARED_OBJECTS_C = $(addprefix $(KERNEL_BUILD_DIR)/,$(SHARED_SOURCES_C:$(SHARED_SOURCE_DIR)/%.c=%.o))
KERNEL_SHARED_OBJECTS_GAS = $(addprefix $(KERNEL_BUILD_DIR)/,$(SHARED_SOURCES_GAS:$(SHARED_SOURCE_DIR)/%.s=%.o))
KERNEL_SHARED_OBJECTS_NASM = $(addprefix $(KERNEL_BUILD_DIR)/,$(SHARED_SOURCES_NASM:$(SHARED_SOURCE_DIR)/%.asm=%.o))
KERNEL_OBJECTS = $(KERNEL_OBJECTS_CXX) $(KERNEL_OBJECTS_C) $(KERNEL_OBJECTS_GAS) $(KERNEL_OBJECTS_NASM) $(KERNEL_SHARED_OBJECTS_CXX) $(KERNEL_SHARED_OBJECTS_C) $(KERNEL_SHARED_OBJECTS_GAS) $(KERNEL_SHARED_OBJECTS_NASM)

KERNEL_HEADERS = $(shell find $(KERNEL_SOURCE_DIR) -name "*.h") $(SHARED_SOURCE_DIR)

USER_SOURCE_DIR = src/user

USER_LIB_SOURCE_DIR = $(USER_SOURCE_DIR)/lib
USER_LIB_BUILD_DIR = build/user/lib
USER_LIB_SOURCES_CXX = $(shell find $(USER_LIB_SOURCE_DIR) -name "*.cc")
USER_LIB_SOURCES_C = $(shell find $(USER_LIB_SOURCE_DIR) -name "*.c")
USER_LIB_SOURCES_GAS = $(shell find $(USER_LIB_SOURCE_DIR) -name "*.s")
USER_LIB_SOURCES_NASM = $(shell find $(USER_LIB_SOURCE_DIR) -name "*.asm")
USER_LIB_OBJECTS_CXX = $(addprefix $(USER_LIB_BUILD_DIR)/,$(USER_LIB_SOURCES_CXX:$(USER_LIB_SOURCE_DIR)/%.cc=%.o))
USER_LIB_OBJECTS_C = $(addprefix $(USER_LIB_BUILD_DIR)/,$(USER_LIB_SOURCES_C:$(USER_LIB_SOURCE_DIR)/%.c=%.o))
USER_LIB_OBJECTS_GAS = $(addprefix $(USER_LIB_BUILD_DIR)/,$(USER_LIB_SOURCES_GAS:$(USER_LIB_SOURCE_DIR)/%.s=%.o))
USER_LIB_OBJECTS_NASM = $(addprefix $(USER_LIB_BUILD_DIR)/,$(USER_LIB_SOURCES_NASM:$(USER_LIB_SOURCE_DIR)/%.asm=%.o))
USER_LIB_SHARED_OBJECTS_CXX = $(addprefix $(USER_LIB_BUILD_DIR)/,$(SHARED_SOURCES_CXX:$(SHARED_SOURCE_DIR)/%.cc=%.o))
USER_LIB_SHARED_OBJECTS_C = $(addprefix $(USER_LIB_BUILD_DIR)/,$(SHARED_SOURCES_C:$(SHARED_SOURCE_DIR)/%.c=%.o))
USER_LIB_SHARED_OBJECTS_GAS = $(addprefix $(USER_LIB_BUILD_DIR)/,$(SHARED_SOURCES_GAS:$(SHARED_SOURCE_DIR)/%.s=%.o))
USER_LIB_SHARED_OBJECTS_NASM = $(addprefix $(USER_LIB_BUILD_DIR)/,$(SHARED_SOURCES_NASM:$(SHARED_SOURCE_DIR)/%.asm=%.o))
USER_LIB_OBJECTS = $(USER_LIB_OBJECTS_CXX) $(USER_LIB_OBJECTS_C) $(USER_LIB_OBJECTS_GAS) $(USER_LIB_OBJECTS_NASM) $(USER_LIB_SHARED_OBJECTS_CXX) $(USER_LIB_SHARED_OBJECTS_C) $(USER_LIB_SHARED_OBJECTS_GAS) $(USER_LIB_SHARED_OBJECTS_NASM)

USER_EXE_SOURCE_DIR = $(USER_SOURCE_DIR)/exe
USER_EXE_BUILD_DIR = build/user/exe
IMAGE_USER_EXE_BUILD_DIR = image/user
USER_EXE_SOURCES_CXX = $(shell find $(USER_EXE_SOURCE_DIR) -name "*.cc")
USER_EXE_SOURCES_C = $(shell find $(USER_EXE_SOURCE_DIR) -name "*.c")
USER_EXE_OBJECTS_CXX = $(addprefix $(USER_EXE_BUILD_DIR)/,$(USER_EXE_SOURCES_CXX:$(USER_EXE_SOURCE_DIR)/%.cc=%.o))
USER_EXE_OBJECTS_C = $(addprefix $(USER_EXE_BUILD_DIR)/,$(USER_EXE_SOURCES_C:$(USER_EXE_SOURCE_DIR)/%.c=%.o))
USER_EXES_CXX = $(addprefix $(USER_EXE_BUILD_DIR)/,$(USER_EXE_SOURCES_CXX:$(USER_EXE_SOURCE_DIR)/%.cc=%.o))
USER_EXES_C = $(addprefix $(USER_EXE_BUILD_DIR)/,$(USER_EXE_SOURCES_C:$(USER_EXE_SOURCE_DIR)/%.c=%.o))
IMAGE_USER_EXES_CXX = $(addprefix $(IMAGE_USER_EXE_BUILD_DIR)/,$(USER_EXE_SOURCES_CXX:$(USER_EXE_SOURCE_DIR)/%.cc=%))
IMAGE_USER_EXES_C = $(addprefix $(IMAGE_USER_EXE_BUILD_DIR)/,$(USER_EXE_SOURCES_C:$(USER_EXE_SOURCE_DIR)/%.cc=%))
USER_EXE_OBJECTS = $(USER_EXE_OBJECTS_CXX) $(USER_EXE_OBJECTS_C) $(USER_EXE_OBJECTS_GAS) $(USER_EXE_OBJECTS_NASM)
#USER_EXES = $(USER_EXES_CXX) $(USER_EXES_C)
IMAGE_USER_EXES = $(IMAGE_USER_EXES_CXX) $(IMAGE_USER_EXES_C)

USER_HEADERS = $(shell find $(USER_LIB_SOURCE_DIR) -name "*.h") $(shell find $(USER_EXE_SOURCE_DIR) -name "*.h") $(SHARED_HEADERS)

# TODO use this to make tests build and run automatically on linux host?
USER_TEST_SOURCE_DIR = $(USER_SOURCE_DIR)/test
USER_TEST_BUILD_DIR = build/user/test
USER_TEST_SOURCES_CXX = $(shell find $(USER_TEST_SOURCE_DIR) -name "*.cc")
USER_TEST_OBJECTS_CXX = $(addprefix $(USER_TEST_BUILD_DIR)/,$(USER_TEST_SOURCES_CXX:$(USER_TEST_SOURCE_DIR)/%.cc=%.o))
USER_TEST_OBJECTS = $(USER_TEST_OBJECTS_CXX)
# TODO add C/GAS/NASM?


TEST_SOURCE_DIR = src/test
TEST_BUILD_DIR = build/test
TEST_SOURCES_CXX = $(shell find $(TEST_SOURCE_DIR) -name "*.cc")
TEST_OBJECTS = $(addprefix $(TEST_BUILD_DIR)/,$(TEST_SOURCES_CXX:$(TEST_SOURCE_DIR)/%.cc=%.o))
TEST_EXECS = $(addprefix $(TEST_BUILD_DIR)/,$(TEST_SOURCES_CXX:$(TEST_SOURCE_DIR)/%.cc=%.out))
TEST_PASSED_FILES = $(addprefix $(TEST_BUILD_DIR)/,$(TEST_SOURCES_CXX:$(TEST_SOURCE_DIR)/%.cc=%.passed))

TEST_HEADERS = $(shell find $(TEST_SOURCE_DIR) -name "*.h") $(SHARED_HEADERS)

CC_FLAGS = -DJOS -Werror -mno-red-zone -Wreturn-type -I $(SHARED_SOURCE_DIR) -I src/ #-g #-Wall -Werror #-mgeneral-regs-only
# -fno-rtti is no runtime type information since we don't have libstdc++
CXX_FLAGS = -DJOS -Werror -fno-threadsafe-statics -fno-exceptions -mno-red-zone -Wreturn-type -fno-rtti -mcmodel=large -I $(SHARED_SOURCE_DIR) -I src/ -std=c++11 #-g

.PHONY: all
all: run

.PHONY: run
run: os.img
	# TODO: -d int
	qemu-system-x86_64 -curses -drive format=raw,file=os.img -s -net nic,model=e1000 -net dump,file=dump.pcap -net user
	#qemu-system-x86_64 -curses -drive format=raw,file=os.img -s
	#qemu-system-x86_64 -curses -serial stdio -drive format=raw,file=os.img -s
	#qemu-system-x86_64 -serial stdio -drive format=raw,file=os.img -s

#os.img: image/boot/kernel.bin image/boot/grub/grub.cfg image/user/init
os.img: image/boot/kernel.bin image/boot/grub/grub.cfg $(IMAGE_USER_EXES) image/*
	-sudo umount /mnt/fatgrub
	-sudo losetup -d $(LOOP_TWO)
	-sudo losetup -d $(LOOP_ONE)
	-rm -f os.img build/os.img
	#cp build/kernel.bin image/boot/kernel.bin
	dd if=/dev/zero of=build/os.img bs=512 count=32768
	parted build/os.img mklabel msdos
	parted build/os.img mkpart primary fat32 2048s 30720s
	parted build/os.img set 1 boot on
	sudo losetup $(LOOP_ONE) build/os.img
	sudo losetup $(LOOP_TWO) build/os.img -o 1048576
	#sudo mkdosfs -F32 -f 2 /dev/loop1
	sudo mkdosfs -F32 -f 2 -S 512 -s 1 $(LOOP_TWO)
	sudo mkdir -p /mnt/fatgrub
	sudo mount $(LOOP_TWO) /mnt/fatgrub
	sudo grub-install --root-directory=/mnt/fatgrub --no-floppy --modules="normal part_msdos ext2 multiboot" $(LOOP_ONE)
	sudo cp -r image/* /mnt/fatgrub
	-sudo umount /mnt/fatgrub
	-sudo losetup -d $(LOOP_TWO)
	-sudo losetup -d $(LOOP_ONE)
	mv build/os.img os.img


image/boot/kernel.bin: $(KERNEL_SOURCE_DIR)/linker.ld $(KERNEL_OBJECTS) $(KERNEL_BUILD_DIR)/cxx_util.o
	$(LD) -n -o $@ -T $< $(KERNEL_OBJECTS) $(KERNEL_BUILD_DIR)/cxx_util.o

# Kernel objects

$(KERNEL_BUILD_DIR)/%.o: $(KERNEL_SOURCE_DIR)/%.asm $(KERNEL_HEADERS)
	$(NASM) $< -o $@ -g

$(KERNEL_BUILD_DIR)/%.o: $(KERNEL_SOURCE_DIR)/%.s $(KERNEL_HEADERS)
	$(GAS) -g -c $< -o $@

$(KERNEL_BUILD_DIR)/%.o: $(KERNEL_SOURCE_DIR)/%.c $(KERNEL_HEADERS)
	$(CC) $(CC_FLAGS) -c $< -o $@ -g -DKERNEL

$(KERNEL_BUILD_DIR)/%.o: $(KERNEL_SOURCE_DIR)/%.cc $(KERNEL_HEADERS)
	$(CXX) $(CXX_FLAGS) -c $< -o $@ -g -DKERNEL

$(KERNEL_BUILD_DIR)/cxx_util.o: src/cxx_util.cc
	$(CXX) $(CXX_FLAGS) -c $< -o $@ -g -DKERNEL

# Kernel shared library objects

$(KERNEL_BUILD_DIR)/%.o: $(SHARED_SOURCE_DIR)/%.asm $(SHARED_HEADERS)
	$(NASM) $< -o $@ -g

$(KERNEL_BUILD_DIR)/%.o: $(SHARED_SOURCE_DIR)/%.s $(SHARED_HEADERS)
	$(GAS) -g -c $< -o $@

$(KERNEL_BUILD_DIR)/%.o: $(SHARED_SOURCE_DIR)/%.c $(SHARED_HEADERS)
	$(CC) $(CC_FLAGS) -c $< -o $@ -g -DKERNEL

$(KERNEL_BUILD_DIR)/%.o: $(SHARED_SOURCE_DIR)/%.cc $(SHARED_HEADERS)
	$(CXX) $(CXX_FLAGS) -c $< -o $@ -g -DKERNEL


# User executable objects

$(USER_EXE_BUILD_DIR)/%.o: $(USER_EXE_SOURCE_DIR)/%.asm
	$(NASM) $< -o $@

$(USER_EXE_BUILD_DIR)/%.o: $(USER_EXE_SOURCE_DIR)/%.s
	$(GAS) -g -c $< -o $@

$(USER_EXE_BUILD_DIR)/%.o: $(USER_EXE_SOURCE_DIR)/%.c $(USER_HEADERS)
	$(CC) $(CC_FLAGS) -c $< -o $@

$(USER_EXE_BUILD_DIR)/%.o: $(USER_EXE_SOURCE_DIR)/%.cc $(USER_HEADERS)
	$(CXX) $(CXX_FLAGS) -c $< -o $@

$(IMAGE_USER_EXE_BUILD_DIR)/%: $(USER_SOURCE_DIR)/linker.ld $(USER_EXE_BUILD_DIR)/%.o $(USER_LIB_OBJECTS) build/user/lib/cxx_util.o
	$(LD) -n -o $@ -T $^


# User library objects

$(USER_LIB_BUILD_DIR)/%.o: $(USER_LIB_SOURCE_DIR)/%.asm
	$(NASM) $< -o $@

$(USER_LIB_BUILD_DIR)/%.o: $(USER_LIB_SOURCE_DIR)/%.s
	$(GAS) -g -c $< -o $@

$(USER_LIB_BUILD_DIR)/%.o: $(USER_LIB_SOURCE_DIR)/%.c $(USER_HEADERS)
	$(CC) $(CC_FLAGS) -c $< -o $@

$(USER_LIB_BUILD_DIR)/%.o: $(USER_LIB_SOURCE_DIR)/%.cc $(USER_HEADERS)
	$(CXX) $(CXX_FLAGS) -c $< -o $@

$(USER_LIB_BUILD_DIR)/cxx_util.o: src/cxx_util.cc
	$(CXX) $(CXX_FLAGS) -c $< -o $@

# User library shared library objects

$(USER_LIB_BUILD_DIR)/%.o: $(SHARED_SOURCE_DIR)/%.asm $(SHARED_HEADERS)
	$(NASM) $< -o $@

$(USER_LIB_BUILD_DIR)/%.o: $(SHARED_SOURCE_DIR)/%.s $(SHARED_HEADERS)
	$(GAS) -g -c $< -o $@

$(USER_LIB_BUILD_DIR)/%.o: $(SHARED_SOURCE_DIR)/%.c $(SHARED_HEADERS)
	$(CC) $(CC_FLAGS) -c $< -o $@

$(USER_LIB_BUILD_DIR)/%.o: $(SHARED_SOURCE_DIR)/%.cc $(SHARED_HEADERS)
	$(CXX) $(CXX_FLAGS) -c $< -o $@


# Generated source files

src/multi_interrupt_handlers.asm: build/multi_interrupt_handlers_generate
	build/multi_interrupt_handlers_generate > src/multi_interrupt_handlers.asm

src/irq_handlers.h: build/irq_handlers_generate
	build/irq_handlers_generate > src/irq_handlers.h

build/multi_interrupt_handlers_generate: src/multi_interrupt_handlers_generate.c
	gcc src/multi_interrupt_handlers_generate.c -o build/multi_interrupt_handlers_generate

build/irq_handlers_generate: src/irq_handlers_generate.c
	gcc src/irq_handlers_generate.c -o build/irq_handlers_generate


.PHONY: test
test: $(TEST_PASSED_FILES)
	@echo all tests passed!

# TODO make this depend on all headers in all source dirs?
.PRECIOUS: $(TEST_BUILD_DIR)/%.o
$(TEST_BUILD_DIR)/%.o: $(TEST_SOURCE_DIR)/%.cc $(TEST_HEADERS)
	g++ -g -std=c++11 -I src/ -c $< -o $@ -DTEST

.PRECIOUS: $(TEST_BUILD_DIR)/%.out
$(TEST_BUILD_DIR)/%.out: $(TEST_BUILD_DIR)/%.o $(KERNEL_OBJECTS) build/test/smartalloc.o
	g++ -o $@ $< $(KERNEL_OBJECTS) build/test/smartalloc.o

.PRECIOUS: $(TEST_BUILD_DIR)/%.passed
$(TEST_BUILD_DIR)/%.passed: $(TEST_BUILD_DIR)/%.out
	./$<
	touch $@

build/test/smartalloc.o: src/test/smartalloc.c src/test/smartalloc.h
	gcc -c $< -o $@


.PHONY: clean
clean:
	-rm -f os.img 
	-git clean -fdx build/
	-git clean -fdx image/
	-sudo umount /mnt/fatgrub
	-sudo losetup -d $(LOOP_TWO)
	-sudo losetup -d $(LOOP_ONE)

.PHONY: dump
dump:
	#tcpdump -qns 0 -A -r dump.pcap
	tcpdump -r dump.pcap
