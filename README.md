# gesture-controlled-vehicle
embedded c and avr assembly codes for the project
/*
 * gesture.c
 *
 * Created: 07-04-2019 09:42:34
 * Author : sowrabh m adiga
 */ 

#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
int main(void)
{
	//DDRD =0xFF;
	DDRB = 0xFF;
	PORTB =0x00;
	//PORTD =0x00;
  /*Global settings for ADC*/
	ADCSRA |= 1<<ADPS2;     ///for 1Mhz clk
	ADMUX |= 1<<REFS0 | 1<<REFS1;  //v ref = 2.56
	ADCSRA |= 1<<ADIE;  //enable enable interrupt
	ADCSRA |= 1<<ADEN;
	

/*---------------------------------*/
	sei();                       //global interrupt enable

	
    MCUCR |= 1<<SM0;
	MCUCR|=1<<SE;
	ADCSRA |= 1<<ADSC;      //capacitor 10uF between PA0,PA1 and ground noise reduction

while (1)
	{        /*to keep micro controller on continuously*/
	}
}
ISR(ADC_vect)
{
	uint8_t theLow = ADCL;
	uint16_t theTenBitResult = ADCH<<8 | theLow;
	//PORTD=0x00;
	//PORTB =0x00;
	switch (ADMUX)
		{
			case 0xC0:
				if(theTenBitResult > 741)  //365,787,751
				{
					PORTB = 0x0A;         //forward
					_delay_ms(1000);
				}
				else if(theTenBitResult < 573)  //300,563
				{
					PORTB = 0x05; 			//backward
					_delay_ms(1000);
				}
				else
				{
					PORTB = 0x00;
					_delay_ms(1000);
				}
				ADMUX = 0xC1;
			break;
			case 0xC1:
				if(theTenBitResult > 763)  //795
				{
					PORTB = 0x06   ;      //right
					_delay_ms(750);
				}
				else if(theTenBitResult < 557)  //568
				{
					PORTB = 0x09; 			//left
					_delay_ms(750);
				}
				else
				{
					PORTB = 0x00;
					_delay_ms(750);
				}
				ADMUX = 0xC0;
			break;
			default:
				PORTB = 0x00;
				//PORTD = 0x00;
			break;
		} ADCSRA |= 1<<ADSC;
}

