//
//  GZTranparentView.m
//  GPAZJU
//
//  Created by Xinbao Dong on 1/30/16.
//  Copyright © 2016 com.dongxinbao. All rights reserved.
//

#import "GZTranparentView.h"

@implementation GZTranparentView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self) {
        return nil;
    } else {
        return hitView;
    }
}

@end
