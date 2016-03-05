//
//  LGWareView.h
//  swareViewTest
//
//  Created by jamy on 15/6/9.
//  Copyright (c) 2015年 jamy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGWareView : UIView

@property (nonatomic, assign) CGFloat gpa;
@property (nonatomic, assign) BOOL hideGPA;
@property (nonatomic, copy) void (^finishedBlock)();

- (void)start;
- (void)stop;

@end
