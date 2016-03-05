//
//  GZExam.h
//  GPAZJU
//
//  Created by Xinbao Dong on 10/5/15.
//  Copyright © 2015 com.dongxinbao. All rights reserved.
//

#import "GZModel.h"

@interface GZExam : NSObject

/**
 *  重修标记
 */
@property (copy, nonatomic) NSString *rtag;

/**
 *  姓名
 */
@property (copy, nonatomic) NSString *name;

/**
 *  学期
 */
@property (copy, nonatomic) NSString *term;

/**
 *  考试时间
 */
@property (copy, nonatomic) NSString *time;

/**
 *  考试地点
 */
@property (copy, nonatomic) NSString *location;


/**
 *  座位号
 */
@property (copy, nonatomic) NSString *seat;

@end
