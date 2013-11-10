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
    
    
    
    _dosimeterData = [[SKDosimeterData alloc] init];
    [_dosimeterData addObserver:self forKeyPath:@"sensorTemperature" options:NSKeyValueObservingOptionNew context:nil];
    [_dosimeterData addObserver:self forKeyPath:@"ambientTemperature" options:NSKeyValueObservingOptionNew context:nil];
    [_dosimeterData addObserver:self forKeyPath:@"timeOverThreshold" options:NSKeyValueObservingOptionNew context:nil];
    [_dosimeterData addObserver:self forKeyPath:@"timeStamp" options:NSKeyValueObservingOptionNew context:nil];
    
	self->_dosimeterDataView = [[SKDosimeterDataView alloc] initWithFrame: self->_viewFrame];
    self.view = self->_dosimeterDataView;
    self.view.backgroundColor = [UIColor purpleColor];
    
    _dosimeterSession = [SKDosimeterSessionController sharedController];
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
    self->_dosimeterDataView.ambientTemperature = self->_dosimeterData.ambientTemperature;
    self->_dosimeterDataView.timeOverThreshold = self->_dosimeterData.timeOverThreshold;
    self->_dosimeterDataView.timeStamp = self->_dosimeterData.timeStamp;
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
/*
+ (void) isNeutronDeviceConnected {
    NSArray* accessoryList = [[EAAccessoryManager sharedAccessoryManager] connectedAccessories];
    
}*/


- (void) _accessoryDidConnect:(NSNotification*) notification {
    NSLog(@"Checking if connected device is a Stellarkite dosimeter...");
    
    EAAccessory* connectedAccessory = [[notification userInfo] objectForKey:EAAccessoryKey];
    
    if ([[self class] isNeutronDevice: connectedAccessory]) {
        NSLog(@"Open Session with device: protocol(%@), manufacter(%@)",
              [[connectedAccessory protocolStrings] objectAtIndex:0],
              [connectedAccessory manufacturer]);
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Device connection"
                                                        message:@"Neutron device has been connected!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];

        [_dosimeterSession openSession: connectedAccessory withProtocolString: SK_PROTOCOL_STRING];
        NSInteger value = [_dosimeterSession getTemperature];
        NSLog(@"TEMPERATURE VALUE: %d", value);
        
        [alert show];
    }
}


- (void) _accessoryDidDisconnect:(NSNotification *)notification {
    EAAccessory* disconnectedAccessory = [[notification userInfo] objectForKey:EAAccessoryKey];
    
    if ([[self class] isNeutronDevice: disconnectedAccessory]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Device connection"
                                                        message:@"Neutron device has been disconnected..."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}


@end
