//
//  GZBlankView.h
//  GPAZJU
//
//  Created by Xinbao Dong on 2/25/16.
//  Copyright © 2016 com.dongxinbao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GZBlankView : UIView

@property (copy, nonatomic) NSString *info;
@property (copy, nonatomic) void (^touchBlock)(GZBlankView *sender);

@end
