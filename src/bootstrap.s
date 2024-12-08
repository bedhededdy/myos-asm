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

.global _start
_start:
    # TODO: MAYBE DON'T HAVE TO DO THIS?
    # Disable interrupts
    cli

    # Allocate a stack for the kernel, because the bootloader
    # will not do this for us
    mov $kstack, %esp

    mov $GDT_SIZE, %eax
    mov $gdt_begin, %eax
    mov $gdt_end, %eax

    call gdt_init
    sgdt [loaded_gdt] # Debug that it was stored right
    

    call idt_init
_stop:
    # Disable interrupts, halt the processor
    # and infinitely repeat in case the processor
    # somehow wakes up. This should never happen
    # so long as kmain never returns (which it shouldn't).
    cli
    hlt
    jmp _stop

gdt_init:
    lgdt [gdtr]
    jmp $KERNEL_CODE_SEG, $reload_cs
reload_cs:
    mov $KERNEL_DATA_SEG, %ax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    mov %ax, %ss
    ret

idt_init:
    ret

# Create a 2MB stack for the kernel
.section .bss
.space 2 * 1024 * 1024
kstack:

.section .data
.set KERNEL_CODE_SEG, 0x08
.set KERNEL_DATA_SEG, 0x10

# https://wiki.osdev.org/Global_Descriptor_Table
# https://wiki.osdev.org/GDT_Tutorial
gdt_begin:
gdt_null_segment:
    .long 0
    .long 0
gdt_kernel_code_segment:
    .word 0xffff
    .word 0
    .byte 0
    .byte 0x9a
    .byte 0xcf
    .byte 0
gdt_kernel_data_segment:
    .word 0xffff
    .word 0
    .byte 0
    .byte 0x92
    .byte 0xcf
    .byte 0
gdt_user_code_segment:
    .word 0xffff
    .word 0
    .byte 0
    .byte 0xfa
    .byte 0xcf
    .byte 0
gdt_user_data_segment:
    .word 0xffff
    .word 0
    .byte 0
    .byte 0xf2
    .byte 0xcf
    .byte 0
#TODO: gdt_task_state_segment
gdt_end:

.set GDT_SIZE, (gdt_end - gdt_begin - 1)

gdtr:
    .word GDT_SIZE
    .long gdt_begin

loaded_gdt:
    .word 0
    .long 0

