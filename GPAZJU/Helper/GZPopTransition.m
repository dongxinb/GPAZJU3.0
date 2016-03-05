//
//  GZPopTransition.m
//  GPAZJU
//
//  Created by Xinbao Dong on 10/5/15.
//  Copyright © 2015 com.dongxinbao. All rights reserved.
//

#import "GZPopTransition.h"
#import "GZTransitionProtocal.h"
#import "MPFlipTransition.h"

#import "Masonry.h"

@implementation GZPopTransition

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.6;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *container = [transitionContext containerView];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    [container addSubview:toVC.view];
    toVC.view.hidden = YES;
    toVC.view.frame = screenBounds;

    [container addSubview:fromVC.view];
    
    [MPFlipTransition transitionFromView:fromVC.view toView:toVC.view duration:[self transitionDuration:transitionContext] style:MPFlipStyleOrientationMask|MPFlipStyleDirectionBackward transitionAction:MPTransitionActionShowHide completion:^(BOOL finished) {
        [fromVC.view removeFromSuperview];
        fromVC.view.hidden = NO;
        [transitionContext completeTransition:YES];
        
    }];
//    UIViewController<GZTransitionProtocal> *fromVC = (id)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    UIViewController<GZTransitionProtocal> *toVC = (id)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//    
//    UIView *fromView = [fromVC viewForTransition];
//    UIView *toView = [toVC viewForTransition];
//    
//    UIView *containerView = [transitionContext containerView];
//    [containerView addSubview:toVC.view];
//    [containerView addSubview:fromVC.view];
//    [containerView addSubview:fromView];
//    
//    CGRect rect = [toView convertRect:rect toView:nil];
//    rect.size = toView.frame.size;
//    
//    [fromView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(containerView).with.offset(75);
//        make.left.equalTo(containerView).with.offset(24);
//        make.right.equalTo(containerView).with.offset(-24);
//        make.height.mas_equalTo(SCREEN_WIDTH / 2.);
//    }];
//    [fromView layoutIfNeeded];
//    
//    fromView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    fromView.layer.borderWidth = 1.;
//    
//    [fromView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(containerView).with.insets(UIEdgeInsetsMake(CGRectGetMinY(rect), CGRectGetMinX(rect), SCREEN_HEIGHT - CGRectGetMaxY(rect), SCREEN_WIDTH - CGRectGetMaxX(rect)));
//    }];
//    
//    [UIView animateWithDuration:0.5 animations:^{
//        [fromView layoutIfNeeded];
//        fromVC.view.alpha = 0.;
//        UIView *view = [fromView viewWithTag:3];
//        view.alpha = 1.;
//    } completion:^(BOOL finished) {
//        [fromVC.view removeFromSuperview];
//        [fromView removeFromSuperview];
//        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
//    }];
    
    
}

@end
