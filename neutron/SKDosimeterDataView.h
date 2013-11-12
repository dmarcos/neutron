//
//  SKDosimeterDataView.h
//  neutron
//
//  Created by Diego Marcos on 9/19/12.
//  Copyright (c) 2012 Stellarkite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ExternalAccessory/ExternalAccessory.h>

@class SKDosimeterSessionController;

@interface SKDosimeterDataView : UIView {
    EAAccessory* dosimeter;
    SKDosimeterSessionController* _sessionController;
}

@property int sensorTemperature;
//@property int ambientTemperature;
//@property int timeOverThreshold;
//@property int timeStamp;

@end
