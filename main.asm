;
; Assemble3.asm
;
; Created: 29-03-2019 20:14:54
; Author : sowra
;
; ADC and accelerometer

CALL ADC_READY

  IN R24,0x17		;In from I/O location 

  ORI R24,0x0F		;Logical OR with immediate
   
  OUT 0x17,R24		;Out to I/O location and masking lower nibble
  				    ;PORTB = move_back
  LDI R16,0x05	    ;	Load immediate 
				    ;PORTB = move_front
  LDI R17,0x0A	    ;	Load immediate 
				    ;PORTB = move_right
  LDI R29,0x09	    ;	Load immediate 
				    ;PORTB = move_left
  LDI R28,0x06	    ;	Load immediate 

  LDI R24,0x01		;Load immediate 

 CALL ADC_READ	    ;Call subroutine  to get y axis values

  MOVW R18,R24		;Copy register pair 

  SUBI R18,0x30		;Subtract immediate
   
  SBCI R19,0x02		;Subtract immediate with carry
   
  CPI R18,0x23		;Compare with immediate 

  SBCI R19,0x01		;Subtract immediate with carry 

  BRCS PC+0x0B		;Branch if carry set checking y axis conditions

  CPI R24,0x53	    ;Compare with immediate 

  LDI R18,0x03		;Load immediate 

  CPC R25,R18		;Compare with carry 

  BRCS PC+0x02		;Branch if carry set if y value is greater than Yposlimit exe the following

  OUT 0x18,R28		;Out to I/O location to move left

  CPI R24,0x30      ;Compare with immediate 

  SBCI R25,0x02		;]Subtract immediate with carry 

  BRCC PC-0x10		;Branch if carry cleared 

  OUT 0x18,R29		;Out to I/O location ; y less than the negetive values
   
  RJMP PC-0x0012	;Relative jump 

  LDI R24,0x00		;Load immediate to move right

  CALL ADC_READ		;Call subroutine for x axis readings 
			        ;if (x>x_pos_limit)
  CPI R24,0x01		;Compare with immediate
   
  LDI R18,0x03		;Load immediate 

  CPC R25,R18		;Compare with carry 

  BRCS PC+0x03		;Branch if carry set 

				    ;PORTB = move_front;

  OUT 0x18,R17		;Out to I/O location 

  RJMP PC-0x001B	;	Relative jump 

			        ;else if(x<x_neg_limit)

  CP R24,R1		    ;Compare 

  SBCI R25,0x02		;Subtract immediate with carry 

  BRCC PC+0x03		;Branch if carry cleared 
				    ;PORTB = move_back;
  OUT 0x18,R16		;Out to I/O location
   
  RJMP PC-0x0020	;	Relative jump 

				    ;PORTB = idle;
  OUT 0x18,R1		;Out to I/O location 

  RJMP PC-0x0022	;	Relative jump 












ADC_READY:	OUT 0x1A,R1           ;Out to I/O location setting input port

			LDI R24,0xC0		  ;Load immediate for ref voltage

			OUT 0x07,R24		  ;Out to I/O location 

			LDI R24,0x87		  ;Load immediate 

			OUT 0x06,R24		  ;Out to I/O location prescalar

			RET

ADC_READ:   IN R25,0x07			  ;In from I/O location 

			ANDI R25,0xE0		  ;Logical AND with immediate  masking

			OUT 0x07,R25		  ;Out to I/O location 

			IN R25,0x07		      ;In from I/O location  channel setting

            ANDI R24,0x07		  ;Logical AND with immediate 

            OR R25,R24		      ;Logical OR 

            OUT 0x07,R25	       ;Out to I/O location 

			SBI 0x06,4	          ;ADIF clearing

			UP:LDS R17,ADCSRA
		    SBRS R17,4             ; CHECK OF COMPLETION OF CONVERSION

		    JMP UP
		    IN R24,0x04		       ;In from I/O location 

		    IN R25,0x05            ;return adc values

			RET

