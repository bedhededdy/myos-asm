INC_DIR = include
BUILD_DIR = out
ISO_DIR = isodir
SRC_DIR = src

CC = i686-elf-gcc
AS = i686-elf-as
CFLAGS = -ffreestanding -Wall -Wextra -I$(INC_DIR) -g
ASFLAGS = -I$(INC_DIR) -g
LDFLAGS = -nostdlib -lgcc

all: wyoos.iso

clean:
	rm -rf $(BUILD_DIR) $(ISO_DIR)

$(BUILD_DIR)/%_c.o: $(SRC_DIR)/%.c
	mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/%_s.o: $(SRC_DIR)/%.s
	mkdir -p $(@D)
	$(AS) $(ASFLAGS) $< -o $@

C_FILES = $(wildcard $(SRC_DIR)/*.c)
ASM_FILES = $(wildcard $(SRC_DIR)/*.s)
OBJ_FILES = $(C_FILES:$(SRC_DIR)/%.c=$(BUILD_DIR)/%_c.o)
OBJ_FILES += $(ASM_FILES:$(SRC_DIR)/%.s=$(BUILD_DIR)/%_s.o)

# Use GCC for linking because it handles a lot of stuff
# you would have to manually do when directly invoking
# the linker
wyoos.bin: linker.ld $(OBJ_FILES)
	$(CC) $(LDFLAGS) -T linker.ld $(OBJ_FILES) -o $(BUILD_DIR)/$@

wyoos.iso: wyoos.bin
	rm -rf $(ISO_DIR)
	mkdir -p $(ISO_DIR)
	mkdir -p $(ISO_DIR)/boot
	mkdir -p $(ISO_DIR)/boot/grub
	cp $(BUILD_DIR)/$< $(ISO_DIR)/boot/$<
	cp grub.cfg $(ISO_DIR)/boot/grub/grub.cfg
	grub-mkrescue -o $@ $(ISO_DIR)

run:
	qemu-system-i386 -cdrom wyoos.iso 

