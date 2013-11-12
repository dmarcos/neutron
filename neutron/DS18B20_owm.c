/**
 * Authors: John Idarraga, Oscar Blanco, 2013.
 */

#include "DS18B20_owm.h"

DS18B20_decoded_temp DS18B20_Temperature(u8 low, u8 high, u8 presc) {

	// LS BYTE    7    6    5    4     3     2     1     0
	//			2^3  2^2  2^1  2^0  2^-1  2^-2  2^-3  2^-4
	//
	// MS BYTE   15   14   13   12    11    10     9     8
	//			  S    S    S    S     S   2^6   2^5   2^4

	// Ex, in 12 bits precision
	// 0000 0001 1001 0001	+25.0625	0x0191

	// The decoded temperature fits in this structure
	DS18B20_decoded_temp tempdeco;

	tempdeco.tempdec = low & 0xF; 	// extract last 4 bits from LSB
	u8 temp = (low & 0xF0) >> 4;   	// extract first 4 bits from LSB
	u8 htemp = (high & 0x7) << 4;	// extract last 3 bits from MSB and switch 4 places

	tempdeco.temp = temp | htemp;	// Concatenate the missing high 3 bits to temp

	// Extract presicon and sign
	tempdeco.presicion = presc;
	if( ( (u16)(high) & 0x0800 ) == 0x0000 ) { // check bit 11
		tempdeco.sign = 1;			 // Negative temperature
	} else {
		tempdeco.sign = 0;			 // Positive temperature
	}

	switch ( presc ) {

	case 12:
		tempdeco.tempdec *=  625; // 0.0625
		break;
	case 11:
		tempdeco.tempdec *= 1250; // 0.125
		break;
	case 10:
		tempdeco.tempdec *= 2500; // 0.25
		break;
	case 9:
		tempdeco.tempdec *= 5000; // 0.5
		break;
	default:
		tempdeco.tempdec *=  625; // 12 bits --> 0.0625
		break;
	}

	return tempdeco;
}
