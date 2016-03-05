//
//  UIViewController+Custom.h
//  GPAZJU
//
//  Created by Xinbao Dong on 1/27/16.
//  Copyright © 2016 com.dongxinbao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Custom)

+ (instancetype)viewControllerFromStoryboard;
- (void)showLogin;
- (void)customNavigationItemWithTitle:(NSString *)title;

@end
