	DEVICE ZXSPECTRUM48
	SLDOPT COMMENT WPMEM

	org $8000
start:
	di				; disable any interrupts

; load de with source
; load hl with (de)
; cp
; inc de

inc_res:
	exx				; temporarily free up bc, de, hl
	ld de, result
	ld hl, (de)



;;;;;;;;;;;;;;   DATA N BITS    ;;;;;;;;;;;;;

result:
	dw 0

source:
	incbin "./1-sample.input.bin"
	dw 0				; end marker

	SAVESNA "1-a.sna", start
