//
//  SKDosimeterDataView.h
//  neutron
//
//  Created by Diego Marcos on 9/19/12.
//  Copyright (c) 2012 Stellarkite. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKDosimeterDataView : UIView
    @property int sensorTemperature;
    @property int ambientTemperature;
    @property int timeOverThreshold;
    @property int timeStamp;
@end
