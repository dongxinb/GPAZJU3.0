//
//  GZSummary.m
//  GPAZJU
//
//  Created by Xinbao Dong on 2/24/16.
//  Copyright © 2016 com.dongxinbao. All rights reserved.
//

#import "GZSummary.h"
#import "GZCourse.h"
#import "GZGrade.h"

@interface GZSummary ()

@property (assign, nonatomic) CGFloat gradeAllTemp;

@end

@implementation GZSummary

- (instancetype)init
{
    self = [super init];
    if (self) {
        _gradeAllTemp = 0;
        _GPA = 0;
        _creditSummary = 0;
    }
    return self;
}

- (void)addCourse:(GZCourse *)course
{
    _courseArray = [self.courseArray arrayByAddingObject:course];
    _gradeAllTemp += course.grade.grade * course.credit;
    _creditSummary += course.credit;
    _GPA = _gradeAllTemp / _creditSummary;
}
@end
