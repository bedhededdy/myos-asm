.section .text

.set IRQ_BASE, 0x20

.macro irq_isr_exception num
.global irq_isr_exception\num\()
irq_isr_exception\num\():
    movb $\num, (irq_number)
    jmp irq_isr_begin
.endm

.macro irq_isr_interrupt num
.global irq_isr_interrupt\num\()
irq_isr_interrupt\num\():
    movb $\num + IRQ_BASE, (irq_number)
    jmp irq_isr_begin
.endm

irq_isr_exception 0x00
irq_isr_exception 0x01
irq_isr_exception 0x02
irq_isr_exception 0x03
irq_isr_exception 0x04
irq_isr_exception 0x05
irq_isr_exception 0x06
irq_isr_exception 0x07
irq_isr_exception 0x08
irq_isr_exception 0x09
irq_isr_exception 0x0a
irq_isr_exception 0x0b
irq_isr_exception 0x0c
irq_isr_exception 0x0d
irq_isr_exception 0x0e
irq_isr_exception 0x0f
irq_isr_exception 0x10
irq_isr_exception 0x11
irq_isr_exception 0x12
irq_isr_exception 0x13

irq_isr_interrupt 0x00
irq_isr_interrupt 0x01
irq_isr_interrupt 0x02
irq_isr_interrupt 0x03
irq_isr_interrupt 0x04
irq_isr_interrupt 0x05
irq_isr_interrupt 0x06
irq_isr_interrupt 0x07
irq_isr_interrupt 0x08
irq_isr_interrupt 0x09
irq_isr_interrupt 0x0a
irq_isr_interrupt 0x0b
irq_isr_interrupt 0x0c
irq_isr_interrupt 0x0d
irq_isr_interrupt 0x0e
irq_isr_interrupt 0x0f
irq_isr_interrupt 0x31
irq_isr_interrupt 0x80

irq_isr_begin:
    # Store register contents
    pushal

    # Push current stack pointer and
    # interrupt number onto the stack
    push %esp
    push (irq_number)
    
    call irq_handle
    # irq_handle returns the stack pointer
    mov %eax, %esp

    # Restore previous register contents (need to add 4
    # because popal does not pop %esp)
    popal
.global irq_ignore
irq_ignore:
    # FIXME: WOULD NEED TO POP THE ERROR CODE OF AN 
    #        EXCEPTION OFF THE STACK FOR EXCEPTIONAL ERROR CODES
    iret

irq_handle:
    # Function calls push 4 bytes on the stack and the previous stack pointer
    # lives 4 bytes before that
    mov 8(%esp), %eax
    ret
    
.global idt_init
idt_init:
    # FIXME: NEED TO DEFINE A CONSTANT FOR THE KERNEL CODE SEGMENT (0x08)
    mov $0x00, %ecx
_tbl_init:
    # https://wiki.osdev.org/Interrupt_Descriptor_Table
    # Define the ignore handler as a 32-bit interrupt gate that lives
    # in the kernel code segment with privilege level 0 (most privileged)
    mov $irq_ignore, %eax
    call idt_set_entry

    add $1, %ecx
    cmp $0x100, %ecx
    jne _tbl_init

    # After we have initialized the table with the generic ignore handler,
    # we can setup the handlers we actually have handling for
    mov $0x00, %ecx
    mov $irq_isr_exception0x00, %eax
    call idt_set_entry

    mov $0x01, %ecx
    mov $irq_isr_exception0x01, %eax
    call idt_set_entry

    mov $0x02, %ecx
    mov $irq_isr_exception0x02, %eax
    call idt_set_entry

    mov $0x03, %ecx
    mov $irq_isr_exception0x03, %eax
    call idt_set_entry

    mov $0x04, %ecx
    mov $irq_isr_exception0x04, %eax
    call idt_set_entry


    mov $0x05, %ecx
    mov $irq_isr_exception0x05, %eax
    call idt_set_entry


    mov $0x06, %ecx
    mov $irq_isr_exception0x06, %eax
    call idt_set_entry


    mov $0x07, %ecx
    mov $irq_isr_exception0x07, %eax
    call idt_set_entry

    mov $0x08, %ecx
    mov $irq_isr_exception0x08, %eax
    call idt_set_entry

    mov $0x09, %ecx
    mov $irq_isr_exception0x09, %eax
    call idt_set_entry

    mov $0x0a, %ecx
    mov $irq_isr_exception0x0a, %eax
    call idt_set_entry

    mov $0x0b, %ecx
    mov $irq_isr_exception0x0b, %eax
    call idt_set_entry

    mov $0x0c, %ecx
    mov $irq_isr_exception0x0c, %eax
    call idt_set_entry

    mov $0x0d, %ecx
    mov $irq_isr_exception0x0d, %eax
    call idt_set_entry

    mov $0x0e, %ecx
    mov $irq_isr_exception0x0e, %eax
    call idt_set_entry

    mov $0x0f, %ecx
    mov $irq_isr_exception0x0f, %eax
    call idt_set_entry

    mov $0x10, %ecx
    mov $irq_isr_exception0x10, %eax
    call idt_set_entry

    mov $0x11, %ecx
    mov $irq_isr_exception0x11, %eax
    call idt_set_entry

    mov $0x12, %ecx
    mov $irq_isr_exception0x12, %eax
    call idt_set_entry

    mov $0x13, %ecx
    mov $irq_isr_exception0x13, %eax
    call idt_set_entry

    mov $0x20, %ecx
    mov $irq_isr_interrupt0x00, %eax
    call idt_set_entry

    # Now we can load the interrupt descriptor table
    lidt (idtr)

    # Let's write to the keyboard
    # Read masks
    mov $0x21, %dx
    in %dx, %al
    mov $0xa1, %dx
    in %dx, %al

    # Init sequence
    mov $0x20, %dx
    mov $0x11, %al
    out %al, %dx
    nop
    nop
    mov $0xa0, %dx
    out %al, %dx
    nop
    nop
    mov $0x21, %dx
    mov $0x20, %al
    out %al, %dx
    nop
    nop
    mov $0xa1, %dx
    mov $0x28, %al
    out %al, %dx
    nop
    nop
    mov $0x21, %dx
    mov $0x04, %al
    out %al, %dx
    nop
    nop
    mov $0xa1, %dx
    mov $0x02, %al
    out %al, %dx
    nop
    nop
    mov $0x21, %dx
    mov $0x01, %al
    out %al, %dx
    nop
    nop
    mov $0xa1, %dx
    out %al, %dx
    nop
    nop

    # TODO: RESTORE MASKS???


    # Now that we have initialized the IDT, we can safely enable interrupts
    sti

    ret

idt_set_entry:
    # Function pointer is passed in %eax
    # The index in the IDT is passed in %ecx
    mov %ax, (idt_ent)
    shr $0x10, %eax
    mov %ax, (idt_ent + 6)
    movw $0x08, (idt_ent + 2)
    movb $0x00, (idt_ent + 4)
    movb $0x8e, (idt_ent + 5)

    mov %ecx, %eax
    imul $8, %eax
    add $idt, %eax
    mov (idt_ent), %edx
    mov %edx, (%eax)
    mov (idt_ent + 4), %edx
    mov %edx, 4(%eax)

    ret 

.section .data
irq_number:    
    .byte 0

idt_ent:
    .word 0
    .word 0
    .byte 0
    .byte 0
    .word 0

idt:
    .space 256 * 8
idt_end:

.set IDT_SIZE, idt_end - idt - 1

idtr:
    .word IDT_SIZE
    .long idt

