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
    UILabel* _ambientTemperatureView;
    UILabel* _timeOverThresholdView;
    UILabel* _timeStampView;
}
@end

@implementation SKDosimeterDataView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _sensorTemperature = 0;
        _ambientTemperature = 0;
        _timeOverThreshold = 0;
        _timeStamp = 0;
        
        _sensorTemperatureView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 30.0, self.bounds.size.width, 72.0)];
        _sensorTemperatureView.textAlignment =  UITextAlignmentCenter;
        _sensorTemperatureView.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(72.0)];
        _sensorTemperatureView.textColor = [UIColor whiteColor];
        _sensorTemperatureView.backgroundColor = [UIColor clearColor];
        _sensorTemperatureView.text = [NSString stringWithFormat: @"%i\u00B0", _sensorTemperature];

        _ambientTemperatureView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 142.0, self.bounds.size.width, 72.0)];
        _ambientTemperatureView.textAlignment =  UITextAlignmentCenter;
        _ambientTemperatureView.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(72.0)];
        _ambientTemperatureView.textColor = [UIColor whiteColor];
        _ambientTemperatureView.backgroundColor = [UIColor clearColor];
        _ambientTemperatureView.text = [NSString stringWithFormat: @"%i\u00B0", _ambientTemperature];

        _timeOverThresholdView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 254.0, self.bounds.size.width, 72.0)];
        _timeOverThresholdView.textAlignment =  UITextAlignmentCenter;
        _timeOverThresholdView.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(72.0)];
        _timeOverThresholdView.textColor = [UIColor whiteColor];
        _timeOverThresholdView.backgroundColor = [UIColor clearColor];
        _timeOverThresholdView.text = [NSString stringWithFormat: @"%ims", _timeOverThreshold];

        _timeStampView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 366.0, self.bounds.size.width, 72.0)];
        _timeStampView.textAlignment =  UITextAlignmentCenter;
        _timeStampView.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(72.0)];
        _timeStampView.textColor = [UIColor whiteColor];
        _timeStampView.backgroundColor = [UIColor clearColor];
        _timeStampView.text = [NSString stringWithFormat: @"%is", _timeStamp];
        
        [self addSubview: _sensorTemperatureView];
        [self addSubview: _ambientTemperatureView];
        [self addSubview: _timeOverThresholdView];
        [self addSubview: _timeStampView];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    _sensorTemperatureView.text = [NSString stringWithFormat: @"%i\u00B0", _sensorTemperature];
    _ambientTemperatureView.text = [NSString stringWithFormat: @"%i\u00B0", _ambientTemperature];
    _timeOverThresholdView.text = [NSString stringWithFormat: @"%ims", _timeOverThreshold];
    _timeStampView.text = [NSString stringWithFormat: @"%is", _timeStamp];
}


@end
