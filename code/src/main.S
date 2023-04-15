;@\copyright@ Szymon Januszek 2023 
#include <avr/io.h>
#include "config.h"

.extern SINE_TAB
.global main

main:
	;Wyzeruj rejestr 1
	eor r1, r1

	;użyj wejścia zegarowego @\label{code:set_clock}@
	ldi r16, 0xD8; MAGICZNA WARTOŚĆ do odblokowywania konfiguracji
	ldi r17, 0x03; CLKOUT=0 | CLKSEL=EXTCLK
	out CPU_CCP, r16; odblokuj konfiguracje systemową
	sts CLKCTRL_MCLKCTRLA, r17; użyj zewnętrzengo zegara

	out CPU_CCP, r16
	sts CLKCTRL_MCLKCTRLB, r1; wyłącz skalowanie zegara

	ldi r16, 0xFF
	out PORT_DIR r16 ;ustaw piny na wyjście
	out PORT_OUT, r1

	;wczytaj wskaźnik SINE_TAB do pary rejestrów Z (r30, r31) @\label{code:set_r20_bp}@
	ldi r20, hi8(SINE_TAB)
	mov r31, r20
	mov r30, r1

loop:
	;pobierz następny bajt z pamięcia oraz zinkrementuj wskaźnik @\label{code:load_and_inc}@
	ld r2, Z+

	;wyślij nowe dane na piny  @\label{code:set_pin_reg}@
	out PORT_OUT, r2
	
	;zamknij cykl licznika @\label{code:overflow_pointer}@
	andi r31, 0x03
	or r31, r20

	;dopełnij ilość instrukcji do dokładnie 12 cylki maszynowych
	nop
	nop
	nop
	nop

	rjmp loop