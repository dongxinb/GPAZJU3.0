//
//  GZTipRope.h
//  GPAZJU
//
//  Created by Xinbao Dong on 1/27/16.
//  Copyright © 2016 com.dongxinbao. All rights reserved.
//

#import "GZTranparentView.h"

@interface GZTipRope : GZTranparentView

@property (strong, nonatomic) NSArray <UIView *> *links;
@property (assign, nonatomic) NSInteger numSegments;
@property (assign, nonatomic) CGFloat segmentWidth;
@property (assign, nonatomic) CGFloat segmentLength;
@property (weak, nonatomic) UIView *attachedView;

- (instancetype)initWithFrame:(CGRect)frame numSegments:(NSInteger)numSegments referenceView:(UIView *)view;

- (void)addToAnimator:(UIDynamicAnimator *)animator;

@end
