//
//  GZDetailViewController.m
//  GPAZJU
//
//  Created by Xinbao Dong on 10/6/15.
//  Copyright © 2015 com.dongxinbao. All rights reserved.
//

#import "GZDetailViewController.h"

#import "GZMainTopView.h"
#import "LGWareView.h"

#import "GZCourse.h"
#import "GZExam.h"
#import "GZGrade.h"

@interface GZDetailViewController ()

@property (strong, nonatomic) LGWareView *waveView;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *creditLabel;
@property (weak, nonatomic) IBOutlet UILabel *termLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseLabel;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@end

@implementation GZDetailViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self configureUI];

	[self loadCourseWithGradeShowed:self.course.isRead];
	[self.waveView start];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	[self.waveView stop];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

#pragma mark - UI

- (void)configureUI
{
	[self customNavigationItemWithTitle:@""];
	[self.view addSubview:self.waveView];
	self.idLabel.font = [UIFont fontWithStyle:GZFontStyleDescription];
	self.termLabel.font = [UIFont fontWithStyle:GZFontStyleDescription];
	self.creditLabel.font = [UIFont fontWithStyle:GZFontStyleDescription];
	self.infoLabel.font = [UIFont fontWithStyle:GZFontStyleDescription];

	self.courseLabel.font = [UIFont fontWithStyle:GZFontStyleNormal];
	self.label1.font = [UIFont fontWithStyle:GZFontStyleNormal];
	self.label2.font = [UIFont fontWithStyle:GZFontStyleNormal];
}

- (void)loadCourseWithGradeShowed:(BOOL)gradeShowed
{
	self.courseLabel.text = self.course.cname;
	self.idLabel.text = self.course.cid;
	self.creditLabel.text = [NSString stringWithFormat:@"%.1lf 学分", self.course.credit];
	self.termLabel.text = [NSString stringWithFormat:@"%@ %@", self.course.cyear, self.course.cterm];
	self.label1.text = @"学分";
	if (self.course.grade) {
		self.label2.text = @"成绩";
        if (self.course.isRead) {
            NSString *str = [NSString stringWithFormat:@"%@", self.course.grade.score];
            if ([[self.course.grade.bscore stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) {
                str = [str stringByAppendingString:[NSString stringWithFormat:@"\n%@ (补考)", self.course.grade.bscore]];
            }
            self.infoLabel.text = str;
        }else {
            self.infoLabel.text = @"?";
        }
		self.waveView.gpa = self.course.grade.grade;
	} else {
		self.label2.text = @"考试信息";
		self.infoLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@", self.course.exam.time, self.course.exam.location, self.course.exam.seat];
		if ([[self.infoLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
			self.infoLabel.text = @"无";
		}
		self.waveView.hideGPA = YES;
	}
}

#pragma mark - GZTransitionProtocal

- (UIView *)viewForTransition
{
	return [self.view viewWithTag:1001];
}

#pragma mark - Getter & Setter

- (LGWareView *)waveView
{
	if (!_waveView) {
		_waveView = [[LGWareView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 2 / 3., SCREEN_WIDTH, SCREEN_HEIGHT / 3.)];
        WS(weakSelf);
        [_waveView setFinishedBlock:^{
            weakSelf.course.read = YES;
            [weakSelf loadCourseWithGradeShowed:YES];
            [[GZUser currentUser] saveCourseList];
            if (weakSelf.readBlock) {
                weakSelf.readBlock();
            }
        }];
	}
	return _waveView;
}

@end
