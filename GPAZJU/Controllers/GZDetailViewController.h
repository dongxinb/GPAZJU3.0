//
//  GZDetailViewController.h
//  GPAZJU
//
//  Created by Xinbao Dong on 10/6/15.
//  Copyright © 2015 com.dongxinbao. All rights reserved.
//

#import "GZRootViewController.h"

@class GZCourse;

@interface GZDetailViewController : GZRootViewController

@property (strong, nonatomic) GZCourse *course;
@property (copy, nonatomic) void (^readBlock)();

@end
