#pragma once

#include <stdint.h>

#include <packon.h>

typedef struct {
	uint16_t sprpvalid;
	uint16_t prpvalid;
	uint8_t player;
	uint8_t hitpoint;
	uint8_t shield;
	uint8_t energy;
	uint32_t resource;
	uint16_t hanger;
	uint16_t sprpflag;
	uint32_t unused;
}UPRPData;


#include <packoff.h>