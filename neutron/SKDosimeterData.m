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
}

@end
