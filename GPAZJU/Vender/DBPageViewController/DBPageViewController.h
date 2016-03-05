//
//  DBPageView.h
//  YunGeZi
//
//  Created by Xinbao Dong on 1/6/16.
//  Copyright © 2016 ZJU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBPageViewController;

@protocol DBPageViewControllerDelegate <NSObject>

@optional
- (void)scrollPageViewController:(DBPageViewController *)scrollPageViewController didScrollToIndex:(NSUInteger)index;

@end

@interface DBPageViewController : UIViewController

@property (nonatomic, assign) id<DBPageViewControllerDelegate> delegate;

@property (nonatomic, retain) NSArray <UIViewController *>*viewControllers;

@property (nonatomic, assign, readonly) NSUInteger currentIndex;

@property (nonatomic, retain, readonly) UIViewController *currentViewController;

@property (assign, nonatomic) BOOL exceptionMode;

- (void)setCurrentIndex:(NSUInteger)index animated:(BOOL)animated;

@end
