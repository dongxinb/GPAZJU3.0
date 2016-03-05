//
//  GZMainItemCell.m
//  GPAZJU
//
//  Created by Xinbao Dong on 10/5/15.
//  Copyright © 2015 com.dongxinbao. All rights reserved.
//

#import "GZCourse.h"
#import "GZExam.h"
#import "GZGrade.h"
#import "GZMainItemCell.h"
#import "WDActivityIndicator.h"

@interface GZMainItemCell ()

@end

@implementation GZMainItemCell

- (void)bindCourse:(GZCourse *)course
{
	self.cnameLabel.text = course.cname;
	self.cinfoLabel.text = [NSString stringWithFormat:@"%.1lf学分", course.credit];
	if (course.grade.score != nil) {
		if (course.isRead) {
			self.gradeLabel.text = [NSString stringWithFormat:@"%.1lf", course.grade.grade];
		} else {
			self.gradeLabel.text = @"!";
		}
	} else {
		if ([[course.exam.time stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
			self.gradeLabel.text = @"?";
		} else {
			NSString *date = [[course.exam.time componentsSeparatedByString:@"("] firstObject];
			NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
			[formatter setDateFormat:@"yyyy年MM月dd日"];
			[formatter setTimeZone:[NSTimeZone localTimeZone]];
			NSDate *examDate = [formatter dateFromString:date];
			if ([examDate timeIntervalSinceNow] < 0) {
				self.gradeLabel.text = @"?";
			} else {
				NSDate *current = [NSDate date];
				NSString *cstr = [formatter stringFromDate:current];
				current = [formatter dateFromString:cstr];
				NSInteger ti = examDate.timeIntervalSince1970 - current.timeIntervalSince1970;
				ti = ti / (60 * 60 * 24);
				self.gradeLabel.text = [NSString stringWithFormat:@"%ld 天后", (long)ti];
			}
		}
	}
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	[self setNeedsDisplay];
}

- (void)awakeFromNib
{
	self.cnameLabel.font = [UIFont fontWithStyle:GZFontStyleBold];
	self.cinfoLabel.font = [UIFont fontWithStyle:GZFontStyleDescription];
	self.gradeLabel.font = [UIFont fontWithStyle:GZFontStyleMain];
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();

	CGContextBeginPath(context);

	BOOL top = NO;
	BOOL left = NO;
	BOOL right = CGRectGetMinX(self.frame) == 10 && CGRectGetWidth(rect) == (SCREEN_WIDTH - 20) / 2 ? YES : NO;
	BOOL bottom = !self.lastLine;

	CGFloat pixelAdjustOffset = 0;
	if (((int)(SINGLE_LINE_WIDTH * [UIScreen mainScreen].scale) + 1) % 2 == 0) {
		pixelAdjustOffset = SINGLE_LINE_ADJUST_OFFSET;
	}

	if (top) {
		CGContextMoveToPoint(context, 0, 1 - pixelAdjustOffset);
		CGContextAddLineToPoint(context, CGRectGetMaxX(rect), 1 - pixelAdjustOffset);
	}
	if (right) {
		CGContextMoveToPoint(context, CGRectGetMaxX(rect) - pixelAdjustOffset, 0);
		CGContextAddLineToPoint(context, CGRectGetMaxX(rect) - pixelAdjustOffset, CGRectGetMaxY(rect));
	}
	if (bottom) {
		CGContextMoveToPoint(context, 0, CGRectGetMaxY(rect) - pixelAdjustOffset);
		CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect) - pixelAdjustOffset);
	}
	if (left) {
		CGContextMoveToPoint(context, 1 - pixelAdjustOffset, 0);
		CGContextAddLineToPoint(context, 1 - pixelAdjustOffset, CGRectGetMaxY(rect));
	}

	CGContextSetLineWidth(context, SINGLE_LINE_WIDTH);
	CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xD2D2D2).CGColor);
	CGContextStrokePath(context);
}

- (void)setLoading:(BOOL)loading
{
	_loading = loading;
	UIView *view1 = [self.contentView viewWithTag:111];
	if (view1) {
		[view1 removeFromSuperview];
	}
	if (loading) {
		WDActivityIndicator *indicator = [[WDActivityIndicator alloc] initWithFrame:CGRectMake(16, CGRectGetHeight(self.frame) - 20 - 15, 20, 20)];
		indicator.tag = 111;
		[self.contentView addSubview:indicator];
		[indicator startAnimating];
	}
}

@end
