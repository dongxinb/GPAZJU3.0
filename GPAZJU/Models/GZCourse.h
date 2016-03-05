//
//  GZCourse.h
//  GPAZJU
//
//  Created by Xinbao Dong on 10/5/15.
//  Copyright © 2015 com.dongxinbao. All rights reserved.
//

#import "GZModel.h"

@class GZExam, GZGrade;

@interface GZCourse : NSObject

/**
 *  课程id
 */
@property (copy, nonatomic) NSString *cid;

/**
 *  课程名
 */
@property (copy, nonatomic) NSString *cname;

/**
 *  学分
 */
@property (assign, nonatomic) CGFloat credit;

/**
 *  考试信息
 */
@property (strong, nonatomic) GZExam *exam;

/**
 *  成绩信息
 */
@property (strong, nonatomic) GZGrade *grade;

/**
 *  学年
 */
@property (copy, nonatomic) NSString *cyear;

/**
 *  学期
 */
@property (copy, nonatomic) NSString *cterm;

/**
 *  是否已读
 */
@property (assign, nonatomic, getter=isRead) BOOL read;

@end
