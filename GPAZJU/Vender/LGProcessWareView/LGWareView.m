//
//  LGWareView.m
//  swareViewTest
//
//  Created by jamy on 15/6/9.
//  Copyright (c) 2015年 jamy. All rights reserved.
//

#import "LGProcessWareView.h"
#import "LGWareView.h"

#define MAX_GPA 5.0

@interface LGWareView ()
@property (nonatomic, strong) LGProcessWareView *processView;
@property (nonatomic, strong) UILabel *percentLabel;
@property (nonatomic, strong) UIView *pView;

@property (nonatomic, strong) CAShapeLayer *dashLayer;
@property (nonatomic, strong) UILabel *maxLabel;
@property (nonatomic, assign) BOOL finished;

@end

@implementation LGWareView
- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		[self setup];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder]) {
		[self setup];
	}
	return self;
}

- (void)setup
{
    [self.layer addSublayer:self.dashLayer];
	[self addSubview:self.processView];
    [self addSubview:self.pView];
    [self addSubview:self.maxLabel];
    
}

- (void)setGpa:(CGFloat)gpa
{
	_gpa = gpa;
	self.processView.precent = gpa / MAX_GPA;
}

- (void)setHideGPA:(BOOL)hideGPA
{
    _hideGPA = hideGPA;
    if (_hideGPA) {
        self.processView.precent = 0.01;
    }
    self.percentLabel.hidden = hideGPA;
}

- (void)start
{
    self.finished = NO;
	[self.processView start];
}

- (void)stop
{
	[self.processView stop];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	self.processView.frame = self.bounds;
}

#pragma mark - Getter

- (LGProcessWareView *)processView
{
	if (!_processView) {
		_processView = [[LGProcessWareView alloc] init];
		_processView.backgroundColor = [UIColor whiteColor];
        __weak typeof(self) weakSelf = self;
        [_processView setPercentChangeBlock:^(LGProcessWareView *sender, CGFloat percent, CGFloat y) {
            weakSelf.percentLabel.text = [NSString stringWithFormat:@"%.1f", percent * MAX_GPA];
            CGFloat offsetY = CGRectGetMinY(weakSelf.processView.frame) + CGRectGetHeight(weakSelf.processView.frame) * (1 - percent);
            weakSelf.pView.center = CGPointMake(CGRectGetMidX(weakSelf.processView.bounds), offsetY - CGRectGetHeight(weakSelf.pView.frame) / 3.2 + y);
            if (round((percent * MAX_GPA * 10)) == round(weakSelf.gpa * 10) && !weakSelf.finished) {
                weakSelf.finished = YES;
                if (weakSelf.finishedBlock) {
                    weakSelf.finishedBlock();
                }
            }
        }];
	}
	return _processView;
}

- (UIView *)pView
{
    if (!_pView) {
        _pView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 96, 96)];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:_pView.bounds];
        imgView.image = [UIImage imageNamed:@"boat"];
        [_pView addSubview:imgView];
        [_pView addSubview:self.percentLabel];
        
        CGFloat offsetY = CGRectGetMinY(self.processView.frame) + CGRectGetHeight(self.processView.frame);
        _pView.center = CGPointMake(CGRectGetMidX(self.processView.bounds), offsetY - CGRectGetHeight(_pView.frame) / 3.2);
    }
    return _pView;
}

- (UILabel *)percentLabel
{
	if (!_percentLabel) {
		_percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 18, 50, 50)];
		_percentLabel.textAlignment = NSTextAlignmentLeft;
		_percentLabel.font = [UIFont fontWithStyle:GZFontStyleNormal];
		_percentLabel.textColor = [UIColor whiteColor];
	}
	return _percentLabel;
}

- (CAShapeLayer *)dashLayer
{
    if (!_dashLayer) {
        _dashLayer = [CAShapeLayer layer];
        _dashLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        _dashLayer.lineWidth = 1.;
        _dashLayer.lineDashPattern = @[@(4), @(2)];
        _dashLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 1);
        
        UIBezierPath* bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint: CGPointMake(0, 0)];
        [bezierPath addLineToPoint: CGPointMake(CGRectGetMaxX(self.bounds), 0)];
        bezierPath.lineWidth = 1;
        [_dashLayer setPath:bezierPath.CGPath];
        
    }
    return _dashLayer;
}

- (UILabel *)maxLabel
{
    if (!_maxLabel) {
        _maxLabel = [[UILabel alloc] init];
        _maxLabel.text = @"MAX";
        _maxLabel.textColor = [UIColor lightGrayColor];
        _maxLabel.font = [UIFont fontWithStyle:GZFontStyleDescription];
        [_maxLabel sizeToFit];
        CGRect rect = _maxLabel.frame;
        rect.origin.x = 0;
        rect.origin.y = 0;
        _maxLabel.frame = rect;
    }
    return _maxLabel;
}

@end
