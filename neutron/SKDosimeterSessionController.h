
//  SKDosimeterSessionController.h
//  neutron
//
//  Created by Ramon Lamana on 9/15/13.
//  Copyright (c) 20123Stellarkite. All rights reserved.

#import <Foundation/Foundation.h>
#import <ExternalAccessory/ExternalAccessory.h>

extern NSString *SKDosimeterSessionDataReceivedNotification;

// NOTE: EADSessionController is not threadsafe, calling methods from different threads will lead to unpredictable results
@interface SKDosimeterSessionController : NSObject <EAAccessoryDelegate, NSStreamDelegate> {
    EAAccessory *_accessory;
    EASession *_session;
    NSString *_protocolString;

    NSMutableData *_writeData;
    NSMutableData *_readData;
}

+ (SKDosimeterSessionController*) sharedController;

- (BOOL) openSession: (EAAccessory *)accessory withProtocolString:(NSString *)protocolString;
- (void) closeSession;

- (void) writeData:(NSData *)data;

- (NSUInteger) readBytesAvailable;
- (NSData *) readData:(NSUInteger)bytesToRead;

- (NSInteger) getTemperature;


@property (nonatomic, readonly) EAAccessory *accessory;
@property (nonatomic, readonly) NSString *protocolString;

@end
