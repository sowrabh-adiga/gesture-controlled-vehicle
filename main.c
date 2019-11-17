/*
 * om_s_gnsmhay_namh.c
 *
 * Created: 07-04-2019 09:42:34
 * Author : sowra
 */ 

#include <avr/io.h>
#include <avr/interrupt.h>
//#include "MrLCD.h"
int main(void)
{
/* 	InitializeMrLCD();
	Send_A_StringToMrLCDWithLocation(1,1,"X:");
	Send_A_StringToMrLCDWithLocation(1,2,"Y:"); */
	
	DDRB = 0xFF;
	PORTB =0x00;
  /*Global settings for ADC*/
	ADCSRA |= 1<<ADPS2;     ///for 1Mhz clk
	ADMUX |= 1<<REFS0 | 1<<REFS1;  //vref = 2.56
	ADCSRA |= 1<<ADIE;  //enable enable interrrupt
	ADCSRA |= 1<<ADEN;
	

/*---------------------------------*/
	sei();           //global interrupt enable

	
    MCUCR |= 1<<SM0;
	MCUCR|=1<<SE;
	ADCSRA |= 1<<ADSC;      //capacitor 10uF between PA0,PA1 and groundnoise reduction

while (1)
	{        /*to keep microcontroller on continuosly*/
	}
}
ISR(ADC_vect)
{
	uint8_t theLow = ADCL;
	uint16_t theTenBitResult = ADCH<<8 | theLow;
	PORTB =0x00;
	switch (ADMUX)
		{
			case 0xC0:
				if(theTenBitResult > 350)
				{
					PORTB = 0x09;//0x0A;         //forward
				}
				else if(theTenBitResult < 330)
				{
					PORTB = 0x09;//0x05; 			//backward
				}
			break;
			case 0xC1:
				if(theTenBitResult > 350)
				{
					PORTB = 0x06;         //forward
				}
				else if(theTenBitResult < 330)
				{
					PORTB = 0x06;//0x09; 			//backward
				}
			break;
			default:
				PORTB = 0x00;
			break;
		} ADCSRA |= 1<<ADSC;
}

