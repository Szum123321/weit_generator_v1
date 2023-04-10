;(C)Szymon Januszek 2023 
#include <avr/io.h>

.extern SINE_TAB
.global main

#define PORT_OUT VPORTD_OUT
#define PORT_DIR VPORTD_DIR

main:
	;temporarly use r1 for ZERO
	eor r1, r1

	;select external clock as Main Clock source
	ldi r16, 0x3
	sts CLKCTRL_MCLKCTRLA, r16

	;set port direction and clear
	ldi r16, 0xFF
	out PORT_DIR, r16
	out PORT_OUT, r1

	;load pointer to sine tab to Z reg. pair
	ldi r20, hi8(SINE_TAB)
	mov r30, r20
	mov r31, r1

	; setup constans. for now, r0 wil be used as counter for RNG
	ldi r16, 3
	mov r3, r16
	ldi r16, 1
	mov r0, r16

	ldi r17, 1

loop:
	;pull next byte out of memory and increment the pointer
	ld r2, Z+

	; randomise lowest bit, g' = (g*3) % 256
	; (r1, r0) = r0 * r3unsigned
	mul r0, r3
	; r1 &= 1
	and r1, r17
	
	eor r2, r1

	;output data
	out PORT_OUT, r2
	
	;cyclize data pointer
	andi r30, 0x03
	or r30, r20

	;pad for 12.288 MHz
	nop

	rjmp loop