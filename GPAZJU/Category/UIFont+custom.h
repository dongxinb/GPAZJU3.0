//
//  UIFont+custom.h
//  GPAZJU
//
//  Created by Xinbao Dong on 10/5/15.
//  Copyright © 2015 com.dongxinbao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GZFontStyle) {
    GZFontStyleTitle = 42,
    GZFontStyleBig = 41,
    GZFontStyleMain = 36,
    GZFontStyleNormal = 26,
    GZFontStyleBold = 27,
    GZFontStyleDescription = 20,
    GZFontStyleSmall = 18
};

@interface UIFont (custom)

+ (UIFont *)fontWithStyle:(GZFontStyle)style;

@end
