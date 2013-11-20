//
//  SKDosimeterDataView.m
//  neutron
//
//  Created by Diego Marcos on 9/19/12.
//  Copyright (c) 2012 Stellarkite. All rights reserved.
//

#import "SKDosimeterDataView.h"

@interface SKDosimeterDataView(){
    UILabel* _sensorTemperatureView;
    UILabel* _deviceStatusView;
}
@end

@implementation SKDosimeterDataView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _sensorTemperature = 0;
        
        _sensorTemperatureView = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 220.0, self.bounds.size.width, 120.0)];
        _sensorTemperatureView.textAlignment =  UITextAlignmentCenter;
        _sensorTemperatureView.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:(120.0)];
        _sensorTemperatureView.textColor = [UIColor whiteColor];
        _sensorTemperatureView.backgroundColor = [UIColor clearColor];
        _sensorTemperatureView.text = [NSString stringWithFormat: @"%i\u00B0", _sensorTemperature];
        _sensorTemperatureView.adjustsLetterSpacingToFitWidth = true;
        
        _deviceStatusView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 30.0, self.bounds.size.width, 12.0)];
        _deviceStatusView.textAlignment =  UITextAlignmentCenter;
        _deviceStatusView.font = [UIFont fontWithName:@"Helvetica Neue" size:(12.0)];
        _deviceStatusView.textColor = [UIColor whiteColor];
        _deviceStatusView.backgroundColor = [UIColor clearColor];
        [self changeDeviceStatus:false];

        [self addSubview: _sensorTemperatureView];
        [self addSubview: _deviceStatusView];
    }
    return self;
}

- (void)changeDeviceStatus: (BOOL) connected {
    if (connected)
        _deviceStatusView.text = @"Device is connected!";
    else
        _deviceStatusView.text = @"Device is not connected";
}

- (void)drawRect:(CGRect)rect
{
    _sensorTemperatureView.text = @"25\u00B0"; //[NSString stringWithFormat: @"%i\u00B0", _sensorTemperature];
}


@end
