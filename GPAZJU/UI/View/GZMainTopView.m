//
//  GZMainTopView.m
//  GPAZJU
//
//  Created by Xinbao Dong on 10/5/15.
//  Copyright © 2015 com.dongxinbao. All rights reserved.
//

#import "GZMainTopView.h"
#import "GPAZJU-Bridging-Header.h"

@interface GZMainTopView ()

@property (strong, nonatomic) LTMorphingLabel *yearLabel;
@property (strong, nonatomic) LTMorphingLabel *infoLabel;
//@property (strong, nonatomic) UILabel


@end

@implementation GZMainTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.yearLabel];
        [self addSubview:self.infoLabel];
    }
    return self;
}


#pragma mark - Getter & Setter

- (LTMorphingLabel *)yearLabel
{
    if (!_yearLabel) {
        _yearLabel = [[LTMorphingLabel alloc] initWithFrame:CGRectMake(0, -3, CGRectGetWidth(self.bounds), 20)];
        _yearLabel.font = [UIFont fontWithStyle:GZFontStyleNormal];
        _yearLabel.textColor = [UIColor blackColor];
        _yearLabel.text = @"";
        _yearLabel.morphingEffect = LTMorphingEffectEvaporate;
    }
    return _yearLabel;
}

- (LTMorphingLabel *)infoLabel
{
    if (!_infoLabel) {
        _infoLabel = [[LTMorphingLabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.yearLabel.frame), CGRectGetWidth(self.bounds), 20)];
        _infoLabel.font = [UIFont fontWithStyle:GZFontStyleDescription];
        _infoLabel.textColor = UIColorFromRGB(0x9B9B9B);
        _infoLabel.text = @"";
    }
    return _infoLabel;
}

- (void)setInfo:(NSString *)info
{
    _info = info;
    self.infoLabel.text = info;
}

- (void)setYear:(NSString *)year
{
    _year = year;
    self.yearLabel.text = year;
}

@end
