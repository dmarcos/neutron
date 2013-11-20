//
//  SKNeutronMainViewController.m
//  neutron
//
//  Created by Diego Marcos Segura on 9/13/12.
//  Copyright (c) 2012 Stellarkite. All rights reserved.
//

#import "SKDosimeterSessionController.h"
#import "SKNeutronMainViewController.h"
#import "SKDosimeterDataView.h"
#import "SKDosimeterData.h"

@interface SKNeutronMainViewController (){
    SKDosimeterData* _dosimeterData;
    SKDosimeterDataView* _dosimeterDataView;
    
    SKDosimeterSessionController* _dosimeterSession;
    EAAccessory *_dosimeter;
}

@end

@implementation SKNeutronMainViewController

@synthesize viewFrame = _viewFrame;

- (void) loadView {
    // Listen to accessory connection
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_accessoryDidConnect:) name:EAAccessoryDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_accessoryDidDisconnect:) name:EAAccessoryDidDisconnectNotification object:nil];
    [[EAAccessoryManager sharedAccessoryManager] registerForLocalNotifications];
    
    // View
    _dosimeterData = [[SKDosimeterData alloc] init];
    [_dosimeterData addObserver:self forKeyPath:@"sensorTemperature" options:NSKeyValueObservingOptionNew context:nil];
    
	self->_dosimeterDataView = [[SKDosimeterDataView alloc] initWithFrame: self->_viewFrame];
    self.view = self->_dosimeterDataView;
    self.view.backgroundColor = [UIColor colorWithRed:0.67 green:0.14 blue:0.16 alpha:1.0];
 
    // Instantiate Dosimeter Controller
    _dosimeterSession = [SKDosimeterSessionController sharedController];
    
    // Open session if device already connected
    EAAccessory* accessory = [[self class] isNeutronDeviceConnected];
    if(accessory != nil) {
        [self _openSession:accessory];
    }
    
    [NSTimer scheduledTimerWithTimeInterval: 1.0
             target: self
             selector: @selector(updateTemperature)
             userInfo: nil
             repeats: YES];
}

- (void) updateTemperature {
    if([_dosimeterSession accessory] != nil)
        [_dosimeterSession requestTemperature];
}


- (void) viewDidLoad {
    // Statusbar color
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    self->_dosimeterDataView.sensorTemperature = self->_dosimeterData.sensorTemperature;
    [self->_dosimeterDataView setNeedsDisplay];
}




// Accessory conection callbacks

#define SK_PROTOCOL_STRING @"com.stellarkite.neutron"

+ (BOOL) isNeutronDevice:(EAAccessory*) accessory {
    
    if ([[accessory protocolStrings] count] > 0) {
        NSLog(@"Device: protocol(%@), manufacter(%@)",
              [[accessory protocolStrings] objectAtIndex:0],
              [accessory manufacturer]);
        
        if([[[accessory protocolStrings] objectAtIndex:0] isEqualToString:SK_PROTOCOL_STRING])
            return true;
    }
    
    return false;
}


+ (EAAccessory*) isNeutronDeviceConnected {
    NSArray* accessoryList = [[EAAccessoryManager sharedAccessoryManager] connectedAccessories];
    
    for (id accessory in accessoryList) {
        if([self isNeutronDevice:accessory])
            return (EAAccessory*) accessory;
    }
    
    return nil;
}

- (void) _openSession: (EAAccessory*) accessory {
    if(accessory != nil) {
        [_dosimeterSession openSession: accessory withProtocolString: SK_PROTOCOL_STRING];
        
        // Once the session is open start listening to accesory notifications
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_dataReady:) name:SKDosimeterSessionDataReceivedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_deviceReady:) name:SKDosimeterSessionReadyNotification object:nil];
        
        [_dosimeterDataView changeDeviceStatus: true];
    }
}

- (void) _closeSession {
    [_dosimeterSession closeSession];
    [_dosimeterDataView changeDeviceStatus: false];
}

- (void) _accessoryDidConnect:(NSNotification*) notification {
    NSLog(@"Checking if connected device is a Stellarkite dosimeter...");
    
    EAAccessory* connectedAccessory = [[notification userInfo] objectForKey:EAAccessoryKey];
    
    if ([[self class] isNeutronDevice: connectedAccessory]) {
        NSLog(@"Open Session with device: protocol(%@), manufacter(%@)",
              [[connectedAccessory protocolStrings] objectAtIndex:0],
              [connectedAccessory manufacturer]);

        [self _openSession: connectedAccessory];
    }
}


- (void) _accessoryDidDisconnect:(NSNotification *)notification {
    EAAccessory* disconnectedAccessory = [[notification userInfo] objectForKey:EAAccessoryKey];
    
    if ([[self class] isNeutronDevice: disconnectedAccessory]) {
        [self _closeSession];
    }
}

- (void) _dataReady: (NSNotification*) notification {
    NSNumber* temperature = [[notification userInfo] objectForKey:@"Temperature"];
    self->_dosimeterData.sensorTemperature = (int) [temperature unsignedIntValue];
}

- (void) _deviceReady: (NSNotification*) notification {
    //[_dosimeterSession requestTemperature];
}



@end
