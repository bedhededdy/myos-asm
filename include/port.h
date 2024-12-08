#ifndef _PORT_H
#define _PORT_H

#include <stdint.h>

typedef enum port_type {
    PORT_TYPE_8,
    PORT_TYPE_16,
    PORT_TYPE_32
} port_type_t;

typedef struct port {
    uint16_t number;
    port_type_t type;
} port_t;

port_t port_create(uint16_t number, port_type_t type);
void port_destroy(port_t *port);
uint32_t port_read(port_t *port);
void port_write(port_t *port, uint32_t data);

#endif

