#include "include/xcustom.h"
#include <stdint.h>
#include <stdio.h>
#include "util.h"

static inline void accum_write(int idx, unsigned long data)
{
	ROCC_INSTRUCTION_SS(1, data, idx, 0);
}

static inline unsigned long accum_read(int idx)
{
	unsigned long value;
	ROCC_INSTRUCTION_DSS(1, value, 0, idx, 1);
	return value;
}

static inline void accum_load(int idx, void *ptr)
{
	asm volatile ("fence");
	ROCC_INSTRUCTION_SS(1, (uintptr_t) ptr, idx, 2);
}

static inline void accum_add(int idx, unsigned long addend)
{
	ROCC_INSTRUCTION_SS(1, addend, idx, 3);
}

uint32_t data = 0x3421;

int main(void)
{
	printf("Test Start!\n");
	uint32_t result;

	accum_load(0, &data);
	accum_add(0, 2);
	result = accum_read(0);
	// result = data + 2;
    

	if (result != data + 2){
		printf("Test 1 Failed!\n");
	} else {
		printf("Test 1 Passed!\n");
	}

	accum_write(0, 3);
	accum_add(0, 1);
	result = accum_read(0);
	if (result != 4){
		printf("Test 2 Failed!\n");
	} else {
		printf("Test 2 Passed!\n");
	}
	
	printf("All Test Passed!\n");

	return 0;
}
