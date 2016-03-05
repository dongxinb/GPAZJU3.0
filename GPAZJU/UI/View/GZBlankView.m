//
//  GZBlankView.m
//  GPAZJU
//
//  Created by Xinbao Dong on 2/25/16.
//  Copyright © 2016 com.dongxinbao. All rights reserved.
//

#import "GZBlankView.h"

@interface GZBlankView ()

@property (strong, nonatomic) UILabel *logo;
@property (strong, nonatomic) UILabel *infoLabel;

@end

@implementation GZBlankView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.logo];
        WS(weakSelf);
        [self.logo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.mas_centerX);
            make.centerY.equalTo(weakSelf.mas_centerY).with.offset(-30);
        }];
        
        [self addSubview:self.infoLabel];
        [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.mas_left).with.offset(20);
            make.right.equalTo(weakSelf.mas_right).with.offset(-20);
            make.top.equalTo(weakSelf.logo.mas_bottom).with.offset(20);
        }];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [self addGestureRecognizer:gesture];
    }
    return self;
}

- (void)setInfo:(NSString *)info
{
    _info = [info copy];
    self.infoLabel.text = _info;
}

- (void)onTap:(id)gesture
{
    if (self.touchBlock) {
        self.touchBlock(self);
    }
}

#pragma mark - Getter

- (UILabel *)logo
{
    if (!_logo) {
        _logo = [[UILabel alloc] init];
        _logo.text = @"GPA.ZJU";
        _logo.font = [UIFont fontWithName:@"TypeOne" size:40];
    }
    return _logo;
}

- (UILabel *)infoLabel
{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.font = [UIFont fontWithStyle:GZFontStyleDescription];
        _infoLabel.numberOfLines = 0;
        _infoLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _infoLabel;
}

@end
