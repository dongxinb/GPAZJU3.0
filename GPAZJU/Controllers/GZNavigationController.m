//
//  GZNavigationController.m
//  GPAZJU
//
//  Created by Xinbao Dong on 10/5/15.
//  Copyright © 2015 com.dongxinbao. All rights reserved.
//

#import "GZGeneralViewController.h"
#import "GZNavigationController.h"
#import "GZSettingsViewController.h"

#import "GZMenuBar.h"
#import "GZNavigationBar.h"

#import "UIImage+color.h"

#import "GZPopTransition.h"
#import "GZPushTransition.h"
#import "MPFlipTransition.h"
#import "MPFoldTransition.h"

#import "Masonry/Masonry.h"

@interface GZNavigationController ()<UINavigationControllerDelegate>

@property (assign, nonatomic) BOOL menuDisplay;
@property (strong, nonatomic) GZMenuBar *menuBar;

@property (strong, nonatomic) NSArray *itemList;

@end

@implementation GZNavigationController

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.delegate = self;
	self.navigationBarSize = CGSizeMake(SCREEN_WIDTH, 70);
	self.navigationBar.clipsToBounds = YES;
	[self.navigationBar.superview addSubview:self.menuBar];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
	return UIBarPositionTop;
}

- (void)setMenuDisplay:(BOOL)display animated:(BOOL)animated andOffset:(CGPoint)offset dragging:(BOOL)dragging
{
	static BOOL loading;
	static CGFloat offsetY;
	static BOOL lastDragging;
	if (self.menuDisplay != display) {
		if (!loading) {
			loading = YES;
			if (display) {
				self.willTransition = NO;
			}
			[MPFlipTransition transitionFromView:display ? self.navigationBar : self.menuBar toView:!display ? self.navigationBar : self.menuBar duration:.3 style:display ? MPFlipStyleOrientationVertical : MPFlipStyleOrientationVertical | MPFlipStyleDirectionBackward transitionAction:MPTransitionActionShowHide completion:^(BOOL finished) {
				NSLog(@"%@", finished ? @"Finished" : @"Not Finished");
				if (display) {
					self.menuBar.hidden = NO;
				} else {
					self.navigationBar.hidden = NO;
					self.menuBar.selectedIndex = -1;
				}
				self.menuDisplay = display;
				loading = NO;
			}];
		}
		offsetY = 0;
	} else {
		if (display && !loading) {
			if (offsetY == 0) {
				offsetY = offset.y;
			}
			if (offset.y < offsetY - 30) {
				self.menuBar.selectedIndex = 2;
			} else if (offset.y < offsetY - 15) {
				self.menuBar.selectedIndex = 1;
			} else if (offset.y <= offsetY) {
				self.menuBar.selectedIndex = 0;
			} else {
				self.menuBar.selectedIndex = -1;
			}

			//            NSLog(@"Selected: %ld", self.menuBar.selectedIndex);
		}
	}
	if (lastDragging && !dragging && self.menuBar.selectedIndex >= 0) {
		self.willTransition = YES;
		[self pushToViewControllerWithIndex:self.menuBar.selectedIndex];
	}
	lastDragging = dragging;
}

- (void)pushToViewControllerWithIndex:(NSInteger)index
{
	NSLog(@"Push to VC: %ld", index);
	NSString *vcStr = [[self.itemList objectAtIndex:index] valueForKey:@"vc"];
	BOOL needLogin = [[[self.itemList objectAtIndex:index] valueForKey:@"needLogin"] boolValue];
	if (needLogin && ![GZUser hasLogin]) {
		[self showLogin];
		return;
	}
	Class c = NSClassFromString(vcStr);
	UIViewController *vc = [c viewControllerFromStoryboard];
	[self pushViewController:vc animated:YES];
}

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    [super setNavigationBarHidden:hidden animated:animated];
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"GZTipGoundView")]) {
            [self.view bringSubviewToFront:view];
        }
    }
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
	BOOL showLine = [toVC isKindOfClass:NSClassFromString(@"GZMainViewController")] || [toVC isKindOfClass:NSClassFromString(@"GZSettingsViewController")] || [toVC isKindOfClass:NSClassFromString(@"GZFeedbackViewController")];
	[(GZNavigationBar *)self.navigationBar setHideLine:!showLine];
	if (operation == UINavigationControllerOperationPush) {
		return [GZPushTransition new];
	} else {
		return [GZPopTransition new];
	}
}

#pragma mark - getter

- (GZMenuBar *)menuBar
{
	if (!_menuBar) {
		NSMutableArray *arr = [NSMutableArray array];
		for (NSDictionary *dic in self.itemList) {
			[arr addObject:[dic valueForKey:@"title"]];
		}
		_menuBar = [[GZMenuBar alloc] initWithItemTitles:[arr copy] andFrame:self.navigationBar.frame];
		_menuBar.hidden = YES;
	}
	return _menuBar;
}

- (NSArray *)itemList
{
	if (!_itemList) {
		_itemList = @[@{ @"title": @"通识统计", @"vc": @"GZGeneralViewController", @"needLogin": @(YES) }, @{ @"title": @"设置", @"vc": @"GZSettingsViewController", @"needLogin": @(NO) }];
	}
	return _itemList;
}

@end
