extern void gdt_init(void);
extern void idt_init(void);

void kmain(void *multiboot_info) {
    gdt_init();
    idt_init();

    while (1);
}

