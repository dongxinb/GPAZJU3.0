//
//  GZRootViewController.m
//  GPAZJU
//
//  Created by Xinbao Dong on 1/27/16.
//  Copyright © 2016 com.dongxinbao. All rights reserved.
//

#import "GZRootViewController.h"

@interface GZRootViewController ()

@end

@implementation GZRootViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.extendedLayoutIncludesOpaqueBars = YES;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
	CGRect rect = self.navigationController.navigationBar.frame;
	rect.origin.y = 0;
	self.navigationController.navigationBar.frame = rect;
	[self.view layoutIfNeeded];
}

@end
