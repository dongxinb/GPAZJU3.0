//
//  GZMainItemViewController.h
//  GPAZJU
//
//  Created by Xinbao Dong on 1/27/16.
//  Copyright © 2016 com.dongxinbao. All rights reserved.
//

#import "GZRootViewController.h"

@class GZCourse;
@class GZMainItemViewController;

@protocol GZMainItemViewControllerDelegate<NSObject>

- (void)mainItemViewController:(GZMainItemViewController *)vc didScrollToOffset:(CGPoint)point dragging:(BOOL)dragging;

@end

@interface GZMainItemViewController : GZRootViewController

@property (assign, nonatomic) id<GZMainItemViewControllerDelegate> delegate;
@property (strong, nonatomic) NSArray<GZCourse *> *courses;
@property (assign, nonatomic) BOOL loginMode;

@end
