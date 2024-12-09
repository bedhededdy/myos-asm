.section .text
.global gdt_init
gdt_init:
    # TODO: REMOVE ME, THIS IS FOR DEBUGGING
    mov $GDT_SIZE, %eax
    mov $gdt_begin, %eax
    mov $gdt_end, %eax

    lgdt (gdtr)
    jmp $KCODE_SEG, $reload_cs
reload_cs:
    # TODO: THIS IS FOR DEBUGGING
    sgdt (loaded_gdt)
    
    mov $KDATA_SEG, %ax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    mov %ax, %ss

    ret

.section .data
.set KCODE_SEG, 0x08
.set KDATA_SEG, 0x10
.set GDT_SIZE, (gdt_end - gdt_begin - 1)

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

gdtr:
    .word GDT_SIZE
    .long gdt_begin

# TODO: REMOVE ME, THIS IS FOR DEBUGGING
loaded_gdt:
    .word 0
    .long 0

