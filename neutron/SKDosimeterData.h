//
//  SKDosimeterData.h
//  neutron
//
//  Created by Diego Marcos on 9/19/12.
//  Copyright (c) 2012 Stellarkite. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKDosimeterData : NSObject

- (void) update;

@property int sensorTemperature;
@property int ambientTemperature;
@property int timeOverThreshold;
@property int timeStamp;

@end
