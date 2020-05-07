	   title     "Name of program"
	   list      p=16f877a
	   include   "p16f877a.inc"

	__CONFIG _CP_OFF & _WDT_OFF & _BODEN_OFF & _PWRTE_ON & _HS_OSC & _WRT_OFF & _LVP_OFF & _CPD_OFF

; '__CONFIG' directive is used to embed configuration data within .asm file.
; The lables following the directive are located in the respective .inc file.
; See respective data sheet for additional information on configuration word.
; Remember there are TWO underscore characters before the word CONFIG.

;*******************************************************************
;
;  filename  ::   one line description
;  ===================================
;
; Description
;    ..............................................
;
;
; Method
;    ................................................
;
; Version
;    People    V1.0    November 2007
;
; History
;    ..........................................
;
;******************************************************************* 
;*******************************************************************    
;
; Constant declarations
; =====================
;
AAAAA     equ     d'13'           ; comment
BBBBB     equ     b'10101100'     ; comment
CCCCC     equ     h'3F'           ; comment
;
;******************************************************************* 
;*******************************************************************    
;
; Variable declarations  : User RAM area starts at location h'20' for PIC16F877a
; =====================
;
w_temp		equ	h'7D'		; variable used for context saving 
status_temp	equ	h'7E'		; variable used for context saving
pclath_temp	equ	h'7F'		; variable used for context saving

variable1       equ     h'20'
variable2       equ     h'21'
;
;*******************************************************************
;******************************************************************* 
; Initial system vector.
;   
	org     h'00'                   ; initialise system restart vector
	clrf 	STATUS
	clrf 	PCLATH			; needed for TinyBootloader functionality
	goto    start

;******************************************************************* 
;******************************************************************* 
; interrupt vector
;
	org	h'04'
	goto	int_routine

;******************************************************************* 
;******************************************************************* 
;
; System subroutines.
;  
	org     h'05'           ; start of program space
;
;******************************************************************* 
;******************************************************************* 
; System functions
;******************************************************************* 
;
;* Init : initialise I/O ports and variables
;  ====
; Notes
;      ............................
;
Init    
	bsf     STATUS, RP0        ; enable page 1 register set
	bcf		STATUS, RP1

	movlw	h'07'
	movwf	ADCON1		   ; set PORTA to be digital rather than analogue

	movlw   b'000001'
	movwf   TRISA              ; set port A  
	movlw   b'00000000'                 
	movwf   TRISB              ; set port B 
	movlw   b'11111111'                 
	movwf   TRISC              ; set port C 
	movlw   b'00000001'                 
	movwf   TRISD              ; set port D 
	bcf     STATUS, RP0        ; back to page 0 register set
;
; initialise program variables
;
;	clrf	variable1          ; ensure that no delay command is active

	return
;******************************************************************* 
;
;  int_routine : routine to handle the single interrupt
;  ===========
; Notes
;      ............................
;
int_routine
	movwf   w_temp            ; save off current W register contents
	movf	STATUS,w          ; move status register into W register
	movwf	status_temp       ; save off contents of STATUS register
	movf	PCLATH,w	  ; move pclath register into w register
	movwf	pclath_temp	  ; save off contents of PCLATH register
;
; Your interrupt code goes HERE
;
	movf	pclath_temp,w	  ; retrieve copy of PCLATH register
	movwf	PCLATH		  ; restore pre-isr PCLATH register contents
	movf    status_temp,w     ; retrieve copy of STATUS register
	movwf	STATUS            ; restore pre-isr STATUS register contents
	swapf   w_temp,f
	swapf   w_temp,w          ; restore pre-isr W register contents
	retfie 
;*******************************************************************    
;
; ****** other system subroutines.
;
;
;******************************************************************* 
;*******************************************************************   
;
; MAIN program
; ============
;
start   
    call    Init
;
start1  
;	Your code goes HERE
;
;
;******************************************************************* 
;
; Program complete.
;
	END


