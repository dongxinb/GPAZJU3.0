//
//  GZPushTransition.m
//  GPAZJU
//
//  Created by Xinbao Dong on 10/5/15.
//  Copyright © 2015 com.dongxinbao. All rights reserved.
//

#import "GZPushTransition.h"
#import "GZTransitionProtocal.h"
//#import "Masonry.h"
#import "MPFoldTransition.h"
#import "MPFlipTransition.h"

@implementation GZPushTransition

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
    
//    UIImage *fromImage = [self screenshotOfScreen];
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    [container addSubview:toVC.view];
    toVC.view.hidden = YES;
    toVC.view.frame = screenBounds;
    
//    UIImageView *view = [[UIImageView alloc] initWithFrame:screenBounds];
//    view.backgroundColor = [UIColor colorWithPatternImage:fromImage];
//    view.image = fromImage;

//    [container insertSubview:view belowSubview:toVC.view];
    [container addSubview:fromVC.view];
    
    [MPFlipTransition transitionFromView:fromVC.view toView:toVC.view duration:[self transitionDuration:transitionContext] style:MPFlipStyleOrientationMask transitionAction:MPTransitionActionShowHide completion:^(BOOL finished) {
        [fromVC.view removeFromSuperview];
        fromVC.view.hidden = NO;
        [transitionContext completeTransition:YES];
    }];
//    toVC.view.backgroundColor = [UIColor clearColor];
//    toVC.view.transform = CGAffineTransformMakeScale(2.0, 2.0);
}


//- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
//{
//	UIViewController<GZTransitionProtocal> *fromVC = (id)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//	UIViewController<GZTransitionProtocal> *toVC = (id)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//
//	UIView *fromView = [fromVC viewForTransition];
//	//    UIView *toView = [toVC viewForTransition];
//	UIView *containerView = [transitionContext containerView];
//	containerView.backgroundColor = [UIColor blackColor];
//
//	CGRect rect = [fromVC.view convertRect:fromView.frame toView:nil];
//	rect.origin.y += 70;
//	//    fromView = [self duplicate:fromView];
//	//    fromView.frame = rect;
//	//    fromView.backgroundColor = [UIColor whiteColor];
//
//	[containerView addSubview:fromVC.view];
//	[containerView addSubview:toVC.view];
//
//	toVC.view.frame = rect;
//	toVC.view.clipsToBounds = YES;
//	//    [containerView addSubview:fromView];
//
//	//    [fromView mas_makeConstraints:^(MASConstraintMaker *make) {
//	//        make.edges.equalTo(containerView).with.insets(UIEdgeInsetsMake(CGRectGetMinY(rect), CGRectGetMinX(rect), SCREEN_HEIGHT - CGRectGetMaxY(rect), SCREEN_WIDTH - CGRectGetMaxX(rect)));
//	//    }];
//	//    [fromView layoutIfNeeded];
//	//    fromView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//	//    fromView.layer.borderWidth = 1.;
//
//	//    [fromView mas_remakeConstraints:^(MASConstraintMaker *make) {
//	//        //            make.edges.equalTo(containerView).with.insets(UIEdgeInsetsMake(74, 30, 100, 30));
//	//        make.top.equalTo(containerView).with.offset(75);
//	//        make.left.equalTo(containerView).with.offset(24);
//	//        make.right.equalTo(containerView).with.offset(-24);
//	//        make.height.mas_equalTo(SCREEN_WIDTH / 2.);
//	//    }];
//
//	[UIView animateWithDuration:.3 animations:^{
//		//        fromView.frame = CGRectMake(0, 100, SCREEN_WIDTH, 200);
//
//		//        [fromView layoutIfNeeded];
//		//        toVC.view.alpha = 1.;
//		//        UIView *view = [fromView viewWithTag:3];
//		//        view.alpha = 0.;
//		fromVC.view.alpha = 0.;
//		toVC.view.frame = fromVC.view.frame;
//	} completion:^(BOOL finished) {
//		fromVC.view.alpha = 1.;
//		//        [toVC.view addSubview:fromView];
//		//        [fromView mas_remakeConstraints:^(MASConstraintMaker *make) {
//		//            make.top.equalTo(toVC.view).with.offset(75);
//		//            make.left.equalTo(toVC.view).with.offset(24);
//		//            make.right.equalTo(toVC.view).with.offset(-24);
//		//            make.height.mas_equalTo(SCREEN_WIDTH / 2.);
//		//        }];
//		//        fromView.layer.borderWidth = 0.;
//		//        [fromView removeFromSuperview];
//		//        [fromVC.view removeFromSuperview];
//		[transitionContext completeTransition:![transitionContext transitionWasCancelled]];
//	}];
//}

- (UIView *)duplicate:(UIView *)view
{
	NSData *tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view];
	return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}

- (UIImage *)screenshotOfScreen
{
	UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];

	UIGraphicsBeginImageContext(screenWindow.frame.size);
	[screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	NSData *screenShotPNG = UIImagePNGRepresentation(screenShot);

	UIImage *image = [UIImage imageWithData:screenShotPNG];
    return image;
}

@end
