//
//  SKAppDelegate.m
//  neutron
//
//  Created by Diego Marcos Segura on 9/13/12.
//  Copyright (c) 2012 Stellarkite. All rights reserved.
//

#import "SKAppDelegate.h"
#import "SKViewController.h"

@implementation SKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CGRect appFrame = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame: appFrame];
    
    SKViewController* neutronViewController = [[SKViewController alloc] init];
    neutronViewController.viewFrame = appFrame;
    
    self.window.rootViewController = neutronViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
