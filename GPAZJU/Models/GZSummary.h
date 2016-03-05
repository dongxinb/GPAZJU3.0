//
//  GZSummary.h
//  GPAZJU
//
//  Created by Xinbao Dong on 2/24/16.
//  Copyright © 2016 com.dongxinbao. All rights reserved.
//

#import "GZModel.h"

@class GZCourse;

@interface GZSummary : GZModel

@property (assign, nonatomic, readonly) CGFloat creditSummary;
@property (assign, nonatomic, readonly) CGFloat GPA;
@property (strong, nonatomic, readonly) NSArray<GZCourse *> *courseArray;
@property (copy, nonatomic) NSString *introduction;

- (void)addCourse:(GZCourse *)course;

@end
