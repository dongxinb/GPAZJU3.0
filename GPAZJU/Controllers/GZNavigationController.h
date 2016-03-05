//
//  GZNavigationController.h
//  GPAZJU
//
//  Created by Xinbao Dong on 10/5/15.
//  Copyright © 2015 com.dongxinbao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GZNavigationController : UINavigationController

@property (assign, nonatomic) BOOL willTransition;
- (void)setMenuDisplay:(BOOL)display animated:(BOOL)animated andOffset:(CGPoint)offset dragging:(BOOL)dragging;

@end
