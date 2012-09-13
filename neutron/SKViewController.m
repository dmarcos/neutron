//
//  SKViewController.m
//  neutron
//
//  Created by Diego Marcos Segura on 9/13/12.
//  Copyright (c) 2012 Stellarkite. All rights reserved.
//

#import "SKViewController.h"

@interface SKViewController ()

@end

@implementation SKViewController

@synthesize viewFrame = _viewFrame;

- (void) loadView {
	self.view = [[UIView alloc] initWithFrame: self->_viewFrame];
    self.view.backgroundColor = [UIColor purpleColor];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
