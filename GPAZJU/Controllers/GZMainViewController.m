//
//  GZMainViewController.m
//  GPAZJU
//
//  Created by Xinbao Dong on 1/27/16.
//  Copyright © 2016 com.dongxinbao. All rights reserved.
//

#import "GZMainItemViewController.h"
#import "GZMainViewController.h"
#import "GZNavigationController.h"

#import "GZMainTopView.h"
#import "GZTipGoundView.h"
#import "GZGuideView.h"

#import "GZCourse.h"

@interface GZMainViewController ()<DBPageViewControllerDelegate, GZMainItemViewControllerDelegate>

@property (strong, nonatomic) GZMainTopView *titleView;
@property (strong, nonatomic) GZTipGoundView *tipView;

@property (strong, nonatomic) NSArray *courseArray;
@property (strong, nonatomic) NSArray *summaryArray;

@end

@implementation GZMainViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self configureUI];
	[self loadData];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"refresh" object:nil];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self.tipView setSquareHidden:NO];
    [GZGuideView judgeAndShowInTheView:self.navigationController.view];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[self.tipView setSquareHidden:YES];
	[self.tipView setAccelerometerEnabled:NO];
}

- (void)configureUI
{
	self.delegate = self;
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.titleView];
	[self.navigationController.view addSubview:self.tipView];
}

- (void)loadData
{
	WS(weakSelf);
	if ([GZUser hasLogin]) {
        if (!self.courseArray) {
            [self processCoursesWithSuccessBlock:nil];
        }
		[self.tipView startLoadingAnimation];
		[[GZUser currentUser] getCourseWithBlock:^(NSArray *result, NSArray *summary, NSError *error) {
			if (error) {
				[DBMessageView showWithMessage:[error localizedDescription]];
				[weakSelf.tipView stopLoadingAnimation];
				if (weakSelf.courseArray.count == 0) {
					[weakSelf noDataSet];
				}
			} else {
				[weakSelf processCoursesWithSuccessBlock:^{
                    [weakSelf.tipView stopLoadingAnimation];
                }];
			}
		}];
	} else {
		self.courseArray = nil;
		GZMainItemViewController *vc = [GZMainItemViewController viewControllerFromStoryboard];
		vc.loginMode = YES;
		vc.delegate = self;
		[self setViewControllers:@[vc]];
	}
}

- (void)processCoursesWithSuccessBlock:(void (^)())block
{
    if ([GZUser currentUser].courseArray.count == 0) {
        [self noDataSet];
        return;
    }
	dispatch_async(dispatch_get_global_queue(0, 0), ^{
		NSMutableArray *array = [@[] mutableCopy];
		for (GZCourse *course in [GZUser currentUser].courseArray) {
			BOOL find = NO;
			for (NSMutableArray *subArray in array) {
				GZCourse *c = [subArray firstObject];
				if (c != nil && [c isKindOfClass:[GZCourse class]]) {
					if ([c.cyear isEqualToString:course.cyear] && [c.cterm isEqualToString:course.cterm]) {
						[subArray addObject:course];
						find = YES;
					}
				}
			}
			if (!find) {
				NSMutableArray *a = [NSMutableArray arrayWithObject:course];
				[array addObject:a];
			}
		}

		NSMutableArray *aa = [NSMutableArray array];
		for (NSInteger i = 0; i < array.count; i++) {
			GZMainItemViewController *vc = [GZMainItemViewController viewControllerFromStoryboard];
			vc.delegate = self;
			vc.courses = array[i];
			[aa addObject:vc];
		}

		dispatch_async(dispatch_get_main_queue(), ^{
			self.courseArray = [array copy];
			[self setViewControllers:[aa copy]];
            if (block) {
                block();
            }
		});
	});
}

- (void)noDataSet
{
	GZMainItemViewController *vc = [GZMainItemViewController viewControllerFromStoryboard];
	vc.delegate = self;
	self.viewControllers = @[vc];
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"refresh" object:nil];
}

#pragma mark - GZMainItemViewControllerDelegate

- (void)mainItemViewController:(GZMainItemViewController *)vc didScrollToOffset:(CGPoint)point dragging:(BOOL)dragging
{
	if (dragging && point.y < -30) {
		[(GZNavigationController *)self.navigationController setMenuDisplay:YES animated:YES andOffset:point dragging:dragging];
		[self.tipView setSquareHidden:YES];
	} else {
		[(GZNavigationController *)self.navigationController setMenuDisplay:NO animated:YES andOffset:point dragging:dragging];
		if (![(GZNavigationController *)self.navigationController willTransition]) {
			[self.tipView setSquareHidden:NO];
		}
	}
}

#pragma mark - DBPageViewControllerDelegate

- (void)scrollPageViewController:(DBPageViewController *)scrollPageViewController didScrollToIndex:(NSUInteger)index
{
	for (NSDictionary *dic in [GZUser currentUser].summaryArray) {
		GZCourse *course = [self.courseArray[index] firstObject];
		if ([[dic objectForKey:@"year"] isEqualToString:course.cyear] && [[dic objectForKey:@"term"] isEqualToString:course.cterm]) {
			self.titleView.year = [NSString stringWithFormat:@"%@ %@", [dic objectForKey:@"year"], [dic objectForKey:@"term"]];
			self.titleView.info = [NSString stringWithFormat:@"已修%ld门课程 | %.1lf学分", [[dic objectForKey:@"finish"] longValue], [[dic objectForKey:@"credits"] doubleValue]];
			[self.tipView setGPA:[NSString stringWithFormat:@"%.2lf", [[dic objectForKey:@"gpa"] doubleValue]] animated:YES];
			return;
		}
	}
	self.titleView.year = nil;
	self.titleView.info = nil;
	[self.tipView setGPA:@"" animated:NO];
}

#pragma mark - Getter & Setter

- (GZMainTopView *)titleView
{
	if (!_titleView) {
		_titleView = [[GZMainTopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 120, 42)];
	}
	return _titleView;
}

- (GZTipGoundView *)tipView
{
	if (!_tipView) {
		_tipView = [[GZTipGoundView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
		WS(weakSelf);
		[_tipView setTouchBlock:^(GZTranparentView *view) {
			[weakSelf loadData];
		}];
	}
	return _tipView;
}

@end
