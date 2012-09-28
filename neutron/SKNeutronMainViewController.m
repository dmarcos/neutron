//
//  SKNeutronMainViewController.m
//  neutron
//
//  Created by Diego Marcos Segura on 9/13/12.
//  Copyright (c) 2012 Stellarkite. All rights reserved.
//

#import "SKNeutronMainViewController.h"
#import "SKDosimeterDataView.h"
#import "SKDosimeterData.h"

@interface SKNeutronMainViewController (){
    SKDosimeterData* _dosimeterData;
    SKDosimeterDataView* _dosimeterDataView;
}

@end

@implementation SKNeutronMainViewController

@synthesize viewFrame = _viewFrame;

- (void) loadView {
    _dosimeterData = [[SKDosimeterData alloc] init];
    [_dosimeterData addObserver:self forKeyPath:@"sensorTemperature" options:NSKeyValueObservingOptionNew context:nil];
    [_dosimeterData addObserver:self forKeyPath:@"ambientTemperature" options:NSKeyValueObservingOptionNew context:nil];
    [_dosimeterData addObserver:self forKeyPath:@"timeOverThreshold" options:NSKeyValueObservingOptionNew context:nil];
    [_dosimeterData addObserver:self forKeyPath:@"timeStamp" options:NSKeyValueObservingOptionNew context:nil];
    
	self->_dosimeterDataView = [[SKDosimeterDataView alloc] initWithFrame: self->_viewFrame];
    self.view = self->_dosimeterDataView;
    self.view.backgroundColor = [UIColor purpleColor];
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

@end
