        DEVICE ZXSPECTRUM48

target 	equ 2020

	org $8000
start:
	di				; disable any interrupts
main:
	ld hl, (ptrOuter)			; load ptr with source position

	ld e, (hl)			; store first item in the array in de
	inc hl
	ld d, (hl)

	ld bc, de			; save the first value to bc

next:
	ld de, (ptrInner)			; ptr += 2
	inc de
	inc de
	ld (ptrInner), de			; save ptr

	; TODO if de == 400 (source.length * 2) - then reset

	ld hl, (ptrInner)			; set de to source(ptr)
	ld e, (hl)
	inc hl
	ld d, (hl)

	ld a, 0					; check 16bit zero value
	cp e
	jr nz, test
	cp d
	jr nz, test

	; if the value *was* zero, then we increment the outer pointer, and copy to inner pointer
	ld de, (ptrOuter)			; ptr += 2
	inc de
	inc de
	ld (ptrOuter), de			; save ptr
	ld (ptrInner), de

	jr main

test:

	; if de === 0 then we've hit the marker and we need to increment i (outer pointer stored in bc)


	ld hl, target			; hl = 2020 (res)

					; required for sbc to work the way we want
	scf 				; set carry bit
	ccf 				; flip carry bit

	sbc hl, de			; res = 2020 - source[j]
	sbc hl, bc			; res -= source[i]

	jr z, end			; if res === 0 then we found it

	jr next


mul16:
; via http://cpctech.cpc-live.com/docs/mult.html
; multiplies DE and BC togther
; Inputs:
;     DE
;     BC
; Uses:
;     A
; Outputs:
;     HL is the result

    	ld a,16				; this is the number of bits of the number to process
    	ld hl,0				; HL is updated with the partial result, and at the end it will hold
        				; the final result.
.mul_loop
	srl b
	rr c				; divide BC by 2 and shifting the state of bit 0 into the carry
					; if carry = 0, then state of bit 0 was 0, (the rightmost digit was 0)
					; if carry = 1, then state of bit 1 was 1. (the rightmost digit was 1)
					; if rightmost digit was 0, then the result would be 0, and we do the add.
					; if rightmost digit was 1, then the result is DE and we do the add.
	jr nc, .no_add

	add hl,de			; will get to here if carry = 1

.no_add
	;; at this point BC has already been divided by 2

	ex de,hl			; swap DE and HL
	add hl,hl			; multiply DE by 2
	ex de,hl			; swap DE and HL

	;; at this point DE has been multiplied by 2

	dec a
	jr nz, .mul_loop  ;; process more bits
	ret

DivHLby10:
; via http://z80-heaven.wikidot.com/math#toc21
;Inputs:
;     HL
;Outputs:
;     HL is the quotient
;     A is the remainder
;     DE is not changed
;     BC is 10
	ld bc,$0D0A
	xor a
	add hl,hl : rla
	add hl,hl : rla
	add hl,hl : rla

	add hl,hl : rla
	cp c
	jr c,$+4
	sub c
	inc l
	djnz $-7
	ret

end:
	; multiply bc and de to hl
	call mul16

	; now display the number in hl
printChr
	call DivHLby10
	add a, $30			; $30 is ascii "0"
	rst $10				; print A register
	ld a, 0

	cp h				; if HL is zero we're done, if not, keep printing
	jr nz, printChr
	cp l
	jr nz, printChr

	jr $

	org $9000	; put the data on an edge so we can nav
source:
	incbin "./1.input.bin"
	dw 0				; end marker
ptrOuter:
	dw source
ptrInner:
	dw source

	SAVESNA "1-a.sna", start
