//
//  DBMessageView.m
//  GPAZJU
//
//  Created by Xinbao Dong on 2/26/16.
//  Copyright © 2016 com.dongxinbao. All rights reserved.
//

#import "DBMessageView.h"

@interface DBMessageView ()

@property (strong, nonatomic) UIWindow *overlayWindow;

@end

@implementation DBMessageView

+ (DBMessageView *)sharedInstance
{
	static dispatch_once_t once;
	static DBMessageView *sharedInstance;
	dispatch_once(&once, ^{
		sharedInstance = [[self alloc] init];
	});
	return sharedInstance;
}

+ (void)showWithMessage:(NSString *)message
{
	UIView *messageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
	messageView.backgroundColor = [UIColor blackColor];

	UILabel *label = [[UILabel alloc] init];
	label.textColor = RGBACOLOR(222, 222, 222, 1);
	label.textAlignment = 1;
	label.numberOfLines = 0;
	label.backgroundColor = [UIColor blackColor];
	label.font = [UIFont fontWithStyle:GZFontStyleDescription];
	label.text = message;
	[messageView addSubview:label];
	CGRect rect = [label textRectForBounds:CGRectMake(0, 0, SCREEN_WIDTH - 20, MAXFLOAT) limitedToNumberOfLines:0];
	CGRect m_frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(rect) + 20);
	m_frame.origin.y = -m_frame.size.height;
	messageView.frame = m_frame;
	label.frame = messageView.bounds;
	[[self sharedInstance].overlayWindow.rootViewController.view addSubview:messageView];

	[self sharedInstance].overlayWindow.hidden = NO;
	[UIView animateWithDuration:.25f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
		CGRect frame = messageView.frame;
		frame.origin.y = 0;
		messageView.frame = frame;
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:.25f delay:1.5 options:UIViewAnimationOptionCurveLinear animations:^{
			CGRect frame = messageView.frame;
			frame.origin.y = -CGRectGetHeight(frame);
			messageView.frame = frame;
		} completion:^(BOOL finished) {
			[messageView removeFromSuperview];
			if ([[[self sharedInstance].overlayWindow.rootViewController.view subviews] count] == 0) {
				[self sharedInstance].overlayWindow.hidden = YES;
			}
		}];
	}];
}

#pragma mark - Setter

- (UIWindow *)overlayWindow;
{
	if (_overlayWindow == nil) {
		_overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
		_overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		_overlayWindow.backgroundColor = [UIColor clearColor];
		_overlayWindow.userInteractionEnabled = NO;
		_overlayWindow.windowLevel = UIWindowLevelAlert;
		_overlayWindow.rootViewController = [[UIViewController alloc] init];
		_overlayWindow.rootViewController.view.backgroundColor = [UIColor clearColor];
		_overlayWindow.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);

		UIWindow *window = [self mainApplicationWindowIgnoringWindow:self.overlayWindow];
		_overlayWindow.frame = window.frame;
	}
	return _overlayWindow;
}

- (UIWindow *)mainApplicationWindowIgnoringWindow:(UIWindow *)ignoringWindow
{
	for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
		if (!window.hidden && window != ignoringWindow) {
			return window;
		}
	}
	return nil;
}

@end
