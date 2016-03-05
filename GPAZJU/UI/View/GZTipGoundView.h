//
//  GZTipGoundView.h
//  GPAZJU
//
//  Created by Xinbao Dong on 1/27/16.
//  Copyright © 2016 com.dongxinbao. All rights reserved.
//

#import "GZTranparentView.h"

@interface GZTipGoundView : GZTranparentView

@property (assign, nonatomic) BOOL accelerometerEnabled;
@property (assign, nonatomic) BOOL panEnabled;
@property (assign, nonatomic) BOOL squareHidden;
@property (copy, nonatomic) void (^touchBlock)(GZTranparentView *sender);
- (void)startLoadingAnimation;
- (void)stopLoadingAnimation;

- (void)setGPA:(NSString *)gpa animated:(BOOL)animated;

@end
