
//  SKDosimeterSessionController.m
//  neutron
//
//  Created by Ramon Lamana on 9/15/13.
//  Copyright (c) 20123Stellarkite. All rights reserved.

#import "SKDosimeterSessionController.h"

NSString* SKDosimeterSessionDataReceivedNotification = @"SKDosimeterSessionDataReceivedNotification";

@implementation SKDosimeterSessionController

@synthesize accessory = _accessory;
@synthesize protocolString = _protocolString;

#pragma mark Internal

// low level write method - write data to the accessory while there is space available and data to write
- (void)_writeData {
    while (([[_session outputStream] hasSpaceAvailable]) && ([_writeData length] > 0))
    {
        NSInteger bytesWritten = [[_session outputStream] write:[_writeData bytes] maxLength:[_writeData length]];
        if (bytesWritten == -1)
        {
            NSLog(@"write error");
            break;
        }
        else if (bytesWritten > 0)
        {
             [_writeData replaceBytesInRange:NSMakeRange(0, bytesWritten) withBytes:NULL length:0];
        }
    }
}

// low level read method - read data while there is data and space available in the input buffer
- (void)_readData {
#define EAD_INPUT_BUFFER_SIZE 128
    uint8_t buf[EAD_INPUT_BUFFER_SIZE];
    while ([[_session inputStream] hasBytesAvailable])
    {
        NSInteger bytesRead = [[_session inputStream] read:buf maxLength:EAD_INPUT_BUFFER_SIZE];
        if (_readData == nil) {
            _readData = [[NSMutableData alloc] init];
        }
        [_readData appendBytes:(void *)buf length:bytesRead];
        //NSLog(@"read %d bytes from input stream", bytesRead);
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:SKDosimeterSessionDataReceivedNotification object:self userInfo:nil];
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
    [self setupControllerForAccessory:nil withProtocolString:nil];

    //[super dealloc];
}

// initialize the accessory with the protocolString
- (void)setupControllerForAccessory:(EAAccessory *)accessory withProtocolString:(NSString *)protocolString
{
    //[_accessory release];
    //_accessory = [accessory retain];
    //[_protocolString release];
    _protocolString = [protocolString copy];
}

// open a session with the accessory and set up the input and output stream on the default run loop
- (BOOL)openSession
{
    [_accessory setDelegate:self];
    _session = [[EASession alloc] initWithAccessory:_accessory forProtocol:_protocolString];

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

// close the session with the accessory.
- (void)closeSession
{
    [[_session inputStream] close];
    [[_session inputStream] removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [[_session inputStream] setDelegate:nil];
    [[_session outputStream] close];
    [[_session outputStream] removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [[_session outputStream] setDelegate:nil];

    //[_session release];
    _session = nil;

    //[_writeData release];
    _writeData = nil;
    //[_readData release];
    _readData = nil;
}

// high level write data method
- (void)writeData:(NSData *)data
{
    if (_writeData == nil) {
        _writeData = [[NSMutableData alloc] init];
    }

    [_writeData appendData:data];
    [self _writeData];
}

// high level read method 
- (NSData *)readData:(NSUInteger)bytesToRead
{
    NSData *data = nil;
    if ([_readData length] >= bytesToRead) {
        NSRange range = NSMakeRange(0, bytesToRead);
        data = [_readData subdataWithRange:range];
        [_readData replaceBytesInRange:range withBytes:NULL length:0];
    }
    return data;
}

// get number of bytes read into local buffer
- (NSUInteger)readBytesAvailable
{
    return [_readData length];
}

#pragma mark EAAccessoryDelegate
- (void)accessoryDidDisconnect:(EAAccessory *)accessory
{
    // do something ...
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
        case NSStreamEventHasBytesAvailable:
            [self _readData];
            break;
        case NSStreamEventHasSpaceAvailable:
            [self _writeData];
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
