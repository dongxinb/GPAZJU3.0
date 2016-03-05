//
//  GZMenuBar.h
//  GPAZJU
//
//  Created by Xinbao Dong on 2/2/16.
//  Copyright © 2016 com.dongxinbao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GZMenuBar;

@protocol GZMenuBarDelegate<NSObject>

- (void)menuBar:(GZMenuBar *)menubar didSelectMenuItemAtIndex:(NSInteger)index;

@end

@interface GZMenuBar : UIView

@property (weak, nonatomic) id<GZMenuBarDelegate> delegate;
@property (assign, nonatomic) NSInteger selectedIndex;
- (instancetype)initWithItemTitles:(NSArray *)array andFrame:(CGRect)frame;

@end
