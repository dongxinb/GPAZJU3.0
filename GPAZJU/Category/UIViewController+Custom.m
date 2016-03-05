//
//  UIViewController+Custom.m
//  GPAZJU
//
//  Created by Xinbao Dong on 1/27/16.
//  Copyright © 2016 com.dongxinbao. All rights reserved.
//

#import "GZLoginViewController.h"
#import "MPFoldTransition.h"
#import "UIViewController+Custom.h"

@implementation UIViewController (Custom)

+ (instancetype)viewControllerFromStoryboard
{
	return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
}

- (void)showLogin
{
	if ([self isKindOfClass:[UINavigationController class]]) {
		[(UINavigationController *)self pushViewController:[GZLoginViewController viewControllerFromStoryboard] animated:YES];
	} else {
		[self.navigationController pushViewController:[GZLoginViewController viewControllerFromStoryboard] animated:YES];
	}
}

- (void)customNavigationItemWithTitle:(NSString *)title
{
    WS(weakSelf);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.tintColor = [UIColor blackColor];
    button.userInteractionEnabled = NO;
    button.titleLabel.font = [UIFont fontWithStyle:GZFontStyleNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"up"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}

@end
