//
//  GZGuideView.m
//  GPAZJU
//
//  Created by Xinbao Dong on 3/3/16.
//  Copyright © 2016 com.dongxinbao. All rights reserved.
//

#import "GZGuideView.h"

@interface GZGuideView ()

@property (strong, nonatomic) UIImageView *gestureImgView;
@property (strong, nonatomic) UILabel *label;
@property (assign, nonatomic) NSInteger step;

@end

@implementation GZGuideView

+ (void)judgeAndShowInTheView:(UIView *)view
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"oldUser30"]) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"oldUser30"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    GZGuideView *v = [GZGuideView new];
    v.alpha = 0.;
    [view addSubview:v];
    [UIView animateWithDuration:0.5 animations:^{
        v.alpha = 1.;
    } completion:nil];
}

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self) {
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
        [self addSubview:self.gestureImgView];
        [self addSubview:self.label];
        self.step = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tap:(UITapGestureRecognizer *)ges
{
    if (self.step == 0) {
        self.gestureImgView.image = [[UIImage imageNamed:@"tap"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.label.text = @"点击这里刷新";
        [self.gestureImgView sizeToFit];
        [self.label sizeToFit];
        self.gestureImgView.center = CGPointMake(SCREEN_WIDTH - 45, 90);
        self.label.center = CGPointMake(CGRectGetMidX(self.gestureImgView.frame), CGRectGetMaxY(self.gestureImgView.frame) + 20);
        self.step = 1;
    }else {
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 0.;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

- (UIImageView *)gestureImgView
{
    if (!_gestureImgView) {
        _gestureImgView = [[UIImageView alloc] init];
        _gestureImgView.image = [[UIImage imageNamed:@"pull"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_gestureImgView sizeToFit];
        _gestureImgView.center = CGPointMake(SCREEN_WIDTH / 2., 90);
        _gestureImgView.tintColor = [UIColor whiteColor];
    }
    return _gestureImgView;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.font = [UIFont fontWithStyle:GZFontStyleDescription];
        _label.textColor = [UIColor whiteColor];
        _label.text = @"下拉切换菜单";
        [_label sizeToFit];
        _label.center = CGPointMake(CGRectGetMidX(self.gestureImgView.frame), CGRectGetMaxY(self.gestureImgView.frame) + 20);
    }
    return _label;
}

@end
