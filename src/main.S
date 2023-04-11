;Szymon Januszek 2023 
#include <avr/io.h>
#include "config.h"

.extern SINE_TAB
.global main

main:
	;temporarly use r1 for ZERO 
	eor r1, r1

	;select external clock as Main Clock source @\label{code:set_clock}@
	ldi r16, 0x3
	sts CLKCTRL_MCLKCTRLA, r16

	;set port direction and clear
	ldi r16, 0xFF
	out PORT_DIR, r16
	out PORT_OUT, r1

	;load pointer to sine tab to Z reg. pair @\label{code:set_r20_bp}@
	ldi r20, hi8(SINE_TAB)
	mov r30, r20
	mov r31, r1

#ifdef DITHER
	; setup constans. for now, r0 wil be used as counter for RNG
	ldi r16, 3
	mov r3, r16
	ldi r16, 1
	mov r0, r16
	ldi r17, 1
#endif //DITHER

loop:
	;pull next byte out of memory and increment the pointer @\label{code:load_and_inc}@
	ld r2, Z+

#ifdef DITHER
	; randomise lowest bit @\label{code:dither}@
	mul r0, r3
	and r1, r17
	eor r2, r1
#endif //DITHER

	;output data  @\label{code:set_pin_reg}@
	out PORT_OUT, r2
	
	;cyclize data pointer @\label{code:overflow_pointer}@
	andi r30, 0x03
	or r30, r20

	;pad for 12.288 MHz
	nop
#ifndef DITHER
	nop
	nop
	nop
	nop
#endif //DITHER

	rjmp loop