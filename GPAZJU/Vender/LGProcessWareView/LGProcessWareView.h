//
//  LGProcessWareView.h
//  swareViewTest
//
//  Created by jamy on 15/6/9.
//  Copyright (c) 2015年 jamy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGProcessWareView : UIView

@property (nonatomic, assign) CGFloat precent;
@property (copy, nonatomic) void (^percentChangeBlock)(LGProcessWareView *sender, CGFloat percent, CGFloat offsetY);

- (void)start;
- (void)stop;

@end
