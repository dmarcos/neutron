#ifndef DS18B20_owm_I_H
#define DS18B20_owm_I_H

typedef unsigned char u8;
typedef unsigned int u32;
typedef unsigned short u16;

typedef struct {
	u8 sign;
	u8 temp;
	u32 tempdec;
	u8 presicion;
} DS18B20_decoded_temp;

void OWM_SK_Send(u8 * baseaddr, u8 * bytes, unsigned int nbytes );
void OWM_SK_Read(u8 * baseaddr, u8 * bytes, unsigned int nbytes );
DS18B20_decoded_temp DS18B20_Temperature(u8 low, u8 high, u8 presc);

#endif
