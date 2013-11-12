//
//  SKDosimeterData.m
//  neutron
//
//  Created by Diego Marcos on 9/19/12.
//  Copyright (c) 2012 Stellarkite. All rights reserved.
//

#import "SKDosimeterData.h"

@implementation SKDosimeterData

- (id) init
{
    self = [super init];
    if (self) {
        self->_sensorTemperature = 0;
        self->_ambientTemperature = 0;
        self->_timeOverThreshold = 0;
        self->_timeStamp = 0;
//        [NSTimer scheduledTimerWithTimeInterval: 1.0
//                 target: self
//                 selector: @selector(update)
//                 userInfo: nil
//                 repeats: YES];
    }
    return self;
}

- (void) update
{
//    self.sensorTemperature = arc4random() % 50;
//    self.ambientTemperature = arc4random() % 50;
//    self.timeOverThreshold = arc4random() % 1000;
//    self.timeStamp += 1;
}

@end
