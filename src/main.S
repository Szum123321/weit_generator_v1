;(C)Szymon Januszek 2023 
#include <avr/io.h>

.extern SINE_TAB
.global main

#define PORT_OUT VPORTD_OUT
#define PORT_DIR VPORTD_DIR

main:
	eor r1, r1

	;select external clock as Main Clock source
	ldi r0, 0x3
	sts CLKCTRL_MCLKCTRLA, r0

	;set port out and clear
	ldi r0, 0xFF
	out PORT_DIR, r0
	out PORT_OUT, r1

	;load array address
	ldi r20, hi8(SINE_TAB)
	mov r30, r20
	mov r31, r1

	ldi r3, 3
	ldi r0, 1

loop:
	;pull next byte out of memory and increment the pointer
	ld r2, Z+

	; randomise lowest bit, g' = (g*3) % 256
	;r0 * r3 = (r1, r0) unsigned
	mul r0, r3
	andi r1, 1
	eor r2, r1

	;output data
	out PORT_OUT, r2
	
	;cyclize data pointer
	andi r30, 0x03
	or r30, r20

	;pad for 12.288 MHz
	nop

	rjmp loop