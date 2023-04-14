;@\copyright@ Szymon Januszek 2023 
#include <avr/io.h>
#include "config.h"

.extern SINE_TAB
.global main

main:
	;temporarly use r1 for ZERO 
	eor r1, r1

	;select external clock as Main Clock source @\label{code:set_clock}@
	ldi r16, 0xD8; MAGIC VALUE
	ldi r17, 0x83
	out CPU_CCP, r16
	sts CLKCTRL_MCLKCTRLA, r17; use external clock

	out CPU_CCP, r16
	sts CLKCTRL_MCLKCTRLB, r1; disable prescaler

	;set port direction and clear
	ldi r16, 0xFF
	sts PORTD_DIRSET, r16
	out PORT_OUT, r1

	;load pointer to Z reg. pair @\label{code:set_r20_bp}@
	ldi r20, hi8(SINE_TAB)
	mov r31, r20
	mov r30, r1

loop:
	;pull next byte out of memory and increment the pointer @\label{code:load_and_inc}@
	ld r2, Z+

	;output data  @\label{code:set_pin_reg}@
	out PORT_OUT, r2
	
	;cyclize data pointer @\label{code:overflow_pointer}@
	andi r31, 0x03
	or r31, r20

	;pad for 12.288 MHz
	nop
	nop
	nop
	nop

	rjmp loop