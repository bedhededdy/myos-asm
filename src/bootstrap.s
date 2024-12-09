# Multiboot header magic to make kernel
# bootable by GRUB
.set MAGIC, 0x1badb002
.set FLAGS, (1 << 0 | 1 << 1)
.set CHECKSUM, -(MAGIC + FLAGS)

.section .multiboot
.long MAGIC
.long FLAGS
.long CHECKSUM

.section .text
.extern kmain
.global _start
_start:
    # TODO: MAYBE DON'T HAVE TO DO THIS?
    # Disable interrupts
    cli

    # Allocate a stack for the kernel, because the bootloader
    # will not do this for us
    # TODO: WHY DO WE NOT SET THE BASE POINTER??
    mov $kstack, %esp

    # kmain takes a pointer to the multiboot structure
    # which is stored in %eax upon entry
    push %eax
    call kmain
    add $4, %esp
_stop:
    # Disable interrupts, halt the processor
    # and infinitely repeat in case the processor
    # somehow wakes up. This should never happen
    # so long as kmain never returns (which it shouldn't).
    cli
    hlt
    jmp _stop

# Create a 2MB stack for the kernel
.section .bss
.space 2 * 1024 * 1024
kstack:

.section .data

