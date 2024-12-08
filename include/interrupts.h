#ifndef _INTERRUPTS_H
#define _INTERRUPTS_H

#include <stdint.h>

// FIXME: INLUDE PATH
#include "../include/gdt.h"
#include "../include/port.h"

typedef struct __attribute__((packed)) interrupt_gate_desc {
    uint16_t handler_addr_lo;
    uint16_t gdt_code_seg;
    uint8_t reserved;
    uint8_t access;
    uint16_t handler_addr_hi;
} interrupt_gate_desc_t;

typedef struct interrupt_mgr {
    interrupt_gate_desc_t interrupt_desc_tbl[256];
    port_t pic_master_command;
    port_t pic_slave_command;
    port_t pic_master_data;
    port_t pic_slave_data;
} interrupt_mgr_t;

void interrupt_mgr_create(interrupt_mgr_t *int_mgr, gdt_t *gdt);
void interrupt_mgr_destroy();
void interrupt_set_gdt_entry(
                             uint8_t interrupt_number,
                             uint16_t gdt_code_seg,
                             void (*handler)(),
                             uint8_t access,
                             uint8_t flags);

void interrupt_activate(void);

void interrupt_ignore_irq(void);
void interrupt_handle_irq0x00(void);
void interrupt_handle_irq0x01(void);
void interrupt_handle_irq0x02(void);
void interrupt_handle_irq0x03(void);
void interrupt_handle_irq0x04(void);
void interrupt_handle_irq0x05(void);
void interrupt_handle_irq0x06(void);
void interrupt_handle_irq0x07(void);
void interrupt_handle_irq0x08(void);
void interrupt_handle_irq0x09(void);
void interrupt_handle_irq0x0a(void);
void interrupt_handle_irq0x0b(void);
void interrupt_handle_irq0x0c(void);
void interrupt_handle_irq0x0d(void);
void interrupt_handle_irq0x0e(void);
void interrupt_handle_irq0x0f(void);
void interrupt_handle_irq0x31(void);

void interrupt_handle_exception0x00(void);
void interrupt_handle_exception0x01(void);
void interrupt_handle_exception0x02(void);
void interrupt_handle_exception0x03(void);
void interrupt_handle_exception0x04(void);
void interrupt_handle_exception0x05(void);
void interrupt_handle_exception0x06(void);
void interrupt_handle_exception0x07(void);
void interrupt_handle_exception0x08(void);
void interrupt_handle_exception0x09(void);
void interrupt_handle_exception0x0a(void);
void interrupt_handle_exception0x0b(void);
void interrupt_handle_exception0x0c(void);
void interrupt_handle_exception0x0d(void);
void interrupt_handle_exception0x0e(void);
void interrupt_handle_exception0x0f(void);
void interrupt_handle_exception0x10(void);
void interrupt_handle_exception0x11(void);
void interrupt_handle_exception0x12(void);
void interrupt_handle_exception0x13(void);

uint32_t interrupt_handle(uint8_t interrupt, uint32_t esp);

#endif

