#include <avr/io.h>

.extern SINE_TAB
.global main

#define PORT_OUT VPORTD_OUT
#define PORT_DIR VPORTD_DIR

;#define PORT_OUT PORTB
;#define PORT_DIR DDRB

main:
	;TODO: setup clock
	;setup the output port
	ldi r20, 0xFF

	out PORT_DIR, r20
	out PORT_OUT, r1

	;load array address
	ldi r20, hi8(SINE_TAB)
	mov r30, r20
	mov r31, r1

loop:
	;pull next byte out of memory and increment the pointer
	lpm r0, Z+
	;ld r0, Z+

	;output data
	out PORT_OUT, r0
	
	;truncate data pointer
	andi r30, 3
	or r30, r20

	rjmp loop