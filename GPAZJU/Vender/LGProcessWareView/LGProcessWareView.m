//
//  LGProcessWareView.m
//  swareViewTest
//
//  Created by jamy on 15/6/9.
//  Copyright (c) 2015年 jamy. All rights reserved.
//

#import "LGProcessWareView.h"

#define jamyColor(r, g, b) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1]

@interface LGProcessWareView ()
{
	CGFloat ampVariable;
	CGFloat ampLitude;
	CGFloat ampSpeed;

	CGFloat offsetX;
	CGFloat offsetY;

	CGFloat offsetXSpeed;
	CGFloat offsetYSpeed;

	BOOL needAdd;

	CGFloat waterH;
	CGFloat waterW;
}

@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, strong) CAShapeLayer *firstLayer;
@property (nonatomic, strong) CAShapeLayer *secondLayer;

@end

@implementation LGProcessWareView

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
	[self setUpLayer];
}

- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	[self setProperty];
}

- (void)setProperty
{
	ampVariable = 1.5;
	ampSpeed = 3.0 * M_PI / self.frame.size.width;
	offsetX = 0;
	offsetY = self.frame.size.height;
	needAdd = NO;

	offsetXSpeed = 0.4 / M_PI;
	offsetYSpeed = 0.5;

	waterW = self.frame.size.width;
	waterH = self.frame.size.height;
}

- (void)setUpLayer
{
	if (_firstLayer == nil) {
		_firstLayer = [CAShapeLayer layer];
		//        _firstLayer.fillColor = [jamyColor(63, 193, 173) CGColor];
		_firstLayer.fillColor = [UIColor colorWithWhite:0. alpha:0.6].CGColor;
		[self.layer addSublayer:_firstLayer];
	}

	if (_secondLayer == nil) {
		_secondLayer = [CAShapeLayer layer];
		//        _secondLayer.fillColor = [jamyColor(166, 226, 217) CGColor];
		_secondLayer.fillColor = [UIColor colorWithWhite:0. alpha:0.6].CGColor;
		[self.layer addSublayer:_secondLayer];
	}
}

- (void)setPrecent:(CGFloat)precent
{
	if (precent < 0) {
		precent = 0.;
	} else if (precent > 1) {
		precent = 1.;
	}
	_precent = precent;
}

- (void)removeLayer
{
	if (_firstLayer != nil) {
		[_firstLayer removeFromSuperlayer];
		_firstLayer = nil;
	}

	if (_secondLayer != nil) {
		[_secondLayer removeFromSuperlayer];
		_secondLayer = nil;
	}
}

- (void)start
{
	if (_firstLayer == nil && _secondLayer == nil) {
		[self setUpLayer];
	}
	_link = [CADisplayLink displayLinkWithTarget:self selector:@selector(begin)];
	[_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
}

- (void)stop
{
	if (_link) {
		[_link invalidate];
		_link = nil;
	}
	[self removeLayer];
	[self setProperty];
}

- (void)animationWave
{
	if (needAdd) {
		ampVariable += 0.1;
	} else {
		ampVariable -= 0.1;
	}

	if (ampVariable <= 0.5) {
		needAdd = YES;
	} else if (ampVariable >= 2) {
		needAdd = NO;
	}

	ampLitude = 3 * ampVariable;

	CGFloat percent = (self.precent - 1 + offsetY / waterH) / self.precent;
	percent = percent < 0 ? 0 : percent;
	ampSpeed = 3.0 * M_PI / self.frame.size.width * (1 + percent * 1) / 2;
	offsetXSpeed = 0.4 / M_PI * (1 + percent * 4) / 5;
}

- (void)begin
{
	[self animationWave];
	if (offsetY > (waterH * (1 - self.precent))) {
		offsetY -= offsetYSpeed;
	}

	offsetX += offsetXSpeed;

	CGFloat a = [self setfirstWare];
	CGFloat b = [self setSeondWare];
//    NSLog(@"%lf", offsetY);
    static CGFloat p = 0;
    if (self.percentChangeBlock) {
        CGFloat percent = 1 - offsetY / waterH;
//        if (p !=
        self.percentChangeBlock(self, percent, MAX(a, b));
//        }
        p = percent;
    }
}

- (CGFloat)setfirstWare
{
	CGMutablePathRef path = CGPathCreateMutable();
	CGFloat y = offsetY / 2.;
	CGPathMoveToPoint(path, nil, 0, y);
	for (CGFloat x = 0; x < waterW; x++) {
		y = ampLitude * sin((ampSpeed)*x + offsetX) + offsetY;
		CGPathAddLineToPoint(path, nil, x, y);
	}

	CGPathAddLineToPoint(path, nil, waterW, waterH);
	CGPathAddLineToPoint(path, nil, 0, waterH);
	CGPathCloseSubpath(path);

	_firstLayer.path = path;
	CGPathRelease(path);
    return ampLitude * sin((ampSpeed)*waterW / 2. + offsetX);
}

- (CGFloat)setSeondWare
{
	CGMutablePathRef path = CGPathCreateMutable();
	CGFloat y = offsetY;
	CGPathMoveToPoint(path, nil, 0, y);
	for (CGFloat x = 0; x < waterW; x++) {
		y = ampLitude * cos((ampSpeed)*x + offsetX) + offsetY;
		CGPathAddLineToPoint(path, nil, x, y);
	}

	CGPathAddLineToPoint(path, nil, waterW, waterH);
	CGPathAddLineToPoint(path, nil, 0, waterH);
	CGPathCloseSubpath(path);

	_secondLayer.path = path;
	CGPathRelease(path);
    return ampLitude * cos((ampSpeed)*waterW/2 + offsetX);
}

@end
