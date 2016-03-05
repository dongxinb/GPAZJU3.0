//
//  UIFont+custom.m
//  GPAZJU
//
//  Created by Xinbao Dong on 10/5/15.
//  Copyright © 2015 com.dongxinbao. All rights reserved.
//

#import "UIFont+custom.h"

@implementation UIFont (custom)

+ (UIFont *)fontWithStyle:(GZFontStyle)style
{
	CGFloat fix = 2;
	if (iPhone6Plus) {
		fix += 1;
	}
	switch (style) {
		case GZFontStyleTitle:
			return [UIFont boldSystemFontOfSize:21 + fix];
			break;
		case GZFontStyleBig:
			return [UIFont systemFontOfSize:21 + fix];
			break;
		case GZFontStyleMain:
			return [UIFont systemFontOfSize:18 + fix];
			break;
		case GZFontStyleNormal:
			return [UIFont systemFontOfSize:13 + fix];
			break;
		case GZFontStyleBold:
			return [UIFont boldSystemFontOfSize:13 + fix];
			break;
		case GZFontStyleDescription:
			return [UIFont systemFontOfSize:10 + fix];
			break;
		case GZFontStyleSmall:
			return [UIFont systemFontOfSize:8 + fix];
			break;
		default:
			break;
	}
}

@end
