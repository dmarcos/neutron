//
//  SKNeutronAppDelegate.m
//  neutron
//
//  Created by Diego Marcos Segura on 9/13/12.
//  Copyright (c) 2012 Stellarkite. All rights reserved.
//

#import "SKNeutronAppDelegate.h"
#import "SKNeutronMainViewController.h"

@implementation SKNeutronAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CGRect appFrame = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame: appFrame];
    
    SKNeutronMainViewController* neutronMainViewController = [[SKNeutronMainViewController alloc] init];
    neutronMainViewController.viewFrame = appFrame;
    
    self.window.rootViewController = neutronMainViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
