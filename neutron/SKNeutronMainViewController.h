//
//  SKNeutronMainViewController.h
//  neutron
//
//  Created by Diego Marcos Segura on 9/13/12.
//  Copyright (c) 2012 Stellarkite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ExternalAccessory/ExternalAccessory.h>

@interface SKNeutronMainViewController : UIViewController {
}

@property (nonatomic) CGRect viewFrame;

+ (BOOL) isNeutronDevice:(EAAccessory*) accessory;

@end
