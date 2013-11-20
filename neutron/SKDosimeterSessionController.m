
//  SKDosimeterSessionController.m
//  neutron
//
//  Created by Ramon Lamana on 9/15/13.
//  Copyright (c) 20123Stellarkite. All rights reserved.

#import "SKDosimeterSessionController.h"

NSString* SKDosimeterSessionDataReceivedNotification = @"SKDosimeterSessionDataReceivedNotification";
NSString* SKDosimeterSessionReadyNotification = @"SKDosimeterSessionReadyNotification";

@implementation SKDosimeterSessionController

@synthesize accessory = _accessory;
@synthesize protocolString = _protocolString;

#pragma mark Internal

- (void) requestTemperature {
    NSMutableData* data = [[NSMutableData alloc] init];
    uint16_t command = (uint16_t) 0x4000;

    [data appendBytes:(void*)&command length:2];
    
    if([[_session outputStream] hasSpaceAvailable] && !_waiting) {
        _waiting = true;
        NSLog(@"TEMPDATA to send/write: %d", [data length]);
        NSInteger bytesWritten = [[_session outputStream] write:[data bytes] maxLength:[data length]];
        NSLog(@"TEMPDATA bytes sent/written: %d", bytesWritten);
        if (bytesWritten == -1) {
            NSLog(@"requestTemperature() error");
        }
    }
}

- (void) readTemperature {
    #define EAD_INPUT_BUFFER_SIZE 128
    
    if(!_waiting)
        return;
    
    uint8_t buf[EAD_INPUT_BUFFER_SIZE];
    while ([[_session inputStream] hasBytesAvailable])
    {
        NSInteger bytesRead = [[_session inputStream] read:buf maxLength:EAD_INPUT_BUFFER_SIZE];
        NSLog(@"read %d bytes from input stream", bytesRead);
        NSLog(@"read value: %i %i %i %i", buf[0], buf[1], buf[2], buf[3]);
    }
    
    NSLog(@"TEMPERATURE: %d", [self _humanReadeableTemperature: buf]);
    
    NSDictionary* userInfo;
    userInfo = [NSDictionary dictionaryWithObject: [NSNumber numberWithInteger:[self _humanReadeableTemperature: buf]]
                                           forKey: @"Temperature"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SKDosimeterSessionDataReceivedNotification object:self userInfo:userInfo];
    
    _waiting = false;
}

- (NSInteger) _humanReadeableTemperature:(uint8_t*)temperatureBytes {
    uint8_t high = temperatureBytes[2];
    uint8_t low = temperatureBytes[3];
    
    NSLog(@"TEMPHEX: low:%x, high:%x", low, high);
    NSLog(@"TEMPDEC: %d", DS18B20_Temperature(low, high, 0x0c).temp);
    
    return DS18B20_Temperature(low, high, 0x0c).temp;
}

#pragma mark Public Methods

+ (SKDosimeterSessionController*) sharedController
{
    static SKDosimeterSessionController* sessionController = nil;
    if (sessionController == nil) {
        sessionController = [[SKDosimeterSessionController alloc] init];
    }

    return sessionController;
}

- (void)dealloc
{
    [self closeSession];
}

// open a session with the accessory and set up the input and output stream on the default run loop
- (BOOL)openSession: (EAAccessory *)accessory withProtocolString:(NSString *)protocolString
{
    _waiting = false;
    _accessory = accessory;
    _protocolString = protocolString;
    
    [_accessory setDelegate:self];
    _session = [[EASession alloc] initWithAccessory:accessory forProtocol:protocolString];

    if (_session)
    {
        [[_session inputStream] setDelegate:self];
        [[_session inputStream] scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [[_session inputStream] open];

        [[_session outputStream] setDelegate:self];
        [[_session outputStream] scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [[_session outputStream] open];
    }
    else
    {
        NSLog(@"creating session failed");
    }

    return (_session != nil);
}

- (void)closeSession
{
    [[_session inputStream] close];
    [[_session inputStream] removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [[_session inputStream] setDelegate:nil];
    [[_session outputStream] close];
    [[_session outputStream] removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [[_session outputStream] setDelegate:nil];
    _session = nil;
}

#pragma mark EAAccessoryDelegate
- (void)accessoryDidDisconnect:(EAAccessory *)accessory
{
}

#pragma mark NSStreamDelegateEventExtensions

// asynchronous NSStream handleEvent method
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    switch (eventCode) {
        case NSStreamEventNone:
            break;
        case NSStreamEventOpenCompleted:
            break;
        case NSStreamEventHasBytesAvailable: {
            [self readTemperature]; // Read from input stream
            break;
        }
        case NSStreamEventHasSpaceAvailable:
            //[[NSNotificationCenter defaultCenter] postNotificationName:SKDosimeterSessionReadyNotification object:self userInfo:nil];
            //[self requestTemperature]; // Write to output stream
            break;
        case NSStreamEventErrorOccurred:
            break;
        case NSStreamEventEndEncountered:
            break;
        default:
            break;
    }
}

@end
