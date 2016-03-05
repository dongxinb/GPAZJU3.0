//
//  GZGrade.h
//  GPAZJU
//
//  Created by Xinbao Dong on 10/5/15.
//  Copyright © 2015 com.dongxinbao. All rights reserved.
//

#import "GZModel.h"

@interface GZGrade : NSObject

/**
 *  成绩
 */
@property (copy, nonatomic) NSString *score;

/**
 *  绩点
 */
@property (assign, nonatomic) CGFloat grade;


/**
 *  补考成绩
 */
@property (copy, nonatomic) NSString *bscore;

@end
