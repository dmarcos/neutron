
//  SKDosimeterSessionController.h
//  neutron
//
//  Created by Ramon Lamana on 9/15/13.
//  Copyright (c) 20123Stellarkite. All rights reserved.

#import <Foundation/Foundation.h>
#import <ExternalAccessory/ExternalAccessory.h>

#import "DS18B20_owm.h"

extern NSString* SKDosimeterSessionDataReceivedNotification;
extern NSString* SKDosimeterSessionReadyNotification;

// NOTE: EADSessionController is not threadsafe, calling methods from different threads will lead to unpredictable results
@interface SKDosimeterSessionController : NSObject <EAAccessoryDelegate, NSStreamDelegate> {
    EAAccessory* _accessory;
    EASession* _session;
    NSString* _protocolString;
    
    bool _waiting;
}

+ (SKDosimeterSessionController*) sharedController;

- (BOOL) openSession: (EAAccessory*)accessory withProtocolString:(NSString *)protocolString;
- (void) closeSession;

- (void) requestTemperature;

@property (nonatomic, readonly) EAAccessory* accessory;
@property (nonatomic, readonly) NSString* protocolString;

@end
