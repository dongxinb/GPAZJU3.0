//
//  GZTipSquare.m
//  GPAZJU
//
//  Created by Xinbao Dong on 1/27/16.
//  Copyright © 2016 com.dongxinbao. All rights reserved.
//

#import "GZTipSquare.h"

@interface GZTipSquare ()

@property (strong, nonatomic) UILabel *gpaLabel;
@property (strong, nonatomic) UILabel *label;

@end

@implementation GZTipSquare

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 2.;
        [self addSubview:self.gpaLabel];
        [self addSubview:self.label];
        [self addSubview:self.indicator];
    }
    return self;
}

- (void)layoutSubviews
{
    self.gpaLabel.frame = CGRectMake(5, CGRectGetHeight(self.bounds) - 70 , 50, 33);
    self.label.frame = CGRectMake(5, CGRectGetHeight(self.bounds) - 20 , 45, 15);
    self.indicator.frame = CGRectMake(CGRectGetWidth(self.bounds) - 27, CGRectGetHeight(self.bounds) - 25, 20, 20);
}

- (void)setGpa:(NSString *)gpa
{
    _gpa = gpa;
    self.gpaLabel.text = gpa;
}

#pragma mark - getter

- (UILabel *)gpaLabel
{
    if (!_gpaLabel) {
        _gpaLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetHeight(self.frame) - 70 , 45, 33)];
        _gpaLabel.font = [UIFont fontWithStyle:GZFontStyleTitle];
//        _gpaLabel.font = [UIFont fontWithName:@"TypeOne" size:24];
        _gpaLabel.textColor = [UIColor blackColor];
        _gpaLabel.adjustsFontSizeToFitWidth = YES;
        _gpaLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _gpaLabel;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetHeight(self.frame) - 20 , 45, 15)];
//        _label.font = [UIFont fontWithStyle:GZFontStyleDescription];
        _label.font = [UIFont fontWithName:@"TypeOne" size:18];
        _label.textColor = [UIColor blackColor];
        _label.text = @"GPA";
    }
    return _label;
}

- (WDActivityIndicator *)indicator
{
    if (!_indicator) {
        _indicator = [[WDActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _indicator.hidesWhenStopped = YES;
        _indicator.indicatorStyle = WDActivityIndicatorStyleGradient;
        [_indicator stopAnimating];
    }
    return _indicator;
}

@end
