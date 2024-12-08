#ifndef _GDT_H
#define _GDT_H

#include <stdint.h>

typedef struct __attribute__((packed)) gdt_seg {
    uint16_t limit_lo;
    uint16_t base_lo;
    uint8_t base_hi;
    uint8_t type;
    uint8_t flags_limit_hi;
    uint8_t base_vhi;
} gdt_seg_t;

typedef struct __attribute__((packed)) gdt {
    gdt_seg_t null_seg;
    gdt_seg_t unused_seg;
    gdt_seg_t code_seg;
    gdt_seg_t data_seg;
} gdt_t;


gdt_seg_t gdt_seg_create(uint32_t base, uint32_t limit, uint8_t type);
uint32_t gdt_seg_base(gdt_seg_t *gdt_seg);
uint32_t gdt_seg_limit(gdt_seg_t *gdt_seg);
void gdt_seg_destroy(gdt_seg_t *gdt_seg);

gdt_t gdt_create(void);
void gdt_init(gdt_t *gdt);
void gdt_destroy(gdt_t *gdt);
uint16_t gdt_code_seg_selector(gdt_t *gdt);
uint16_t gdt_data_seg_selector(gdt_t *gdt);

#endif

