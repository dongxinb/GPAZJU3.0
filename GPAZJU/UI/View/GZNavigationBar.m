//
//  GZNavigationBar.m
//  GPAZJU
//
//  Created by Xinbao Dong on 1/27/16.
//  Copyright © 2016 com.dongxinbao. All rights reserved.
//

#import "GZNavigationBar.h"

@interface GZNavigationBar ()

@property (strong, nonatomic) UIView *line;

@end

@implementation GZNavigationBar

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		self.backgroundColor = [UIColor whiteColor];
		[self addSubview:self.line];
//		WS(weakSelf);
//		[self.line mas_makeConstraints:^(MASConstraintMaker *make) {
//			make.left.equalTo(weakSelf).with.offset(10);
//			make.right.equalTo(weakSelf).with.offset(-10);
//			make.bottom.equalTo(weakSelf).with.offset(0);
//			make.height.mas_equalTo(SINGLE_LINE_WIDTH);
//		}];
	}
	return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect rect = self.frame;
    rect.origin.y = 0;
    self.frame = rect;
    self.line.frame = CGRectMake(10, CGRectGetHeight(self.frame) - SINGLE_LINE_WIDTH, CGRectGetWidth(self.frame) - 20, SINGLE_LINE_WIDTH);
    [self layoutIfNeeded];
}

- (void)setHideLine:(BOOL)hideLine
{
	if (hideLine != _hideLine) {
		_hideLine = hideLine;
		[UIView animateWithDuration:0.6 animations:^{
			self.line.alpha = hideLine ? 0. : 1.;
		}];
	}
}

- (UIView *)line
{
	if (!_line) {
		_line = [[UIView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, SINGLE_LINE_WIDTH)];
		_line.backgroundColor = [UIColor blackColor];
	}
	return _line;
}

//- (void)drawRect:(CGRect)rect
//{
//	if (!self.hideLine) {
//		CGContextRef context = UIGraphicsGetCurrentContext();
//
//		CGContextBeginPath(context);
//
//		CGFloat pixelAdjustOffset = 0;
//		if (((int)(SINGLE_LINE_WIDTH * [UIScreen mainScreen].scale) + 1) % 2 == 0) {
//			pixelAdjustOffset = SINGLE_LINE_ADJUST_OFFSET;
//		}
//
//		CGContextMoveToPoint(context, 10, CGRectGetMaxY(rect) - pixelAdjustOffset);
//		CGContextAddLineToPoint(context, CGRectGetMaxX(rect) - 10, CGRectGetMaxY(rect) - pixelAdjustOffset);
//
//		CGContextSetLineWidth(context, SINGLE_LINE_WIDTH);
//		CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
//		CGContextStrokePath(context);
//	}
//}

@end
