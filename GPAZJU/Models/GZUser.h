//
//  GZUser.h
//  GPAZJU
//
//  Created by Xinbao Dong on 10/5/15.
//  Copyright © 2015 com.dongxinbao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GZCourse;
@class GZSummary;

@interface GZUser : NSObject

/**
 *  Single Instance of User
 *
 *  @return user
 */
+ (instancetype)currentUser;

/**
 *  stuID
 */
@property (copy, nonatomic, readonly) NSString *stuID;

@property (copy, nonatomic, readonly) NSString *name;

/**
 *  The array of all the courses;
 */
@property (strong, nonatomic) NSArray<GZCourse *> *courseArray;

/**
 *  course summary
 */
@property (strong, nonatomic) NSArray *summaryArray;

/**
 *  Judge whether user has login
 *
 *  @return whether user has login
 */
+ (BOOL)hasLogin;

/**
 *  login method
 *
 *  @param stuId          stuID
 *  @param password       password
 *  @param completedBlock complete block
 */
+ (void)loginWithStuID:(NSString *)stuId andPassword:(NSString *)password withBlock:(void (^)(NSError *error, GZUser *user))completedBlock;

/**
 *  Log out
 *
 *  @param block complete block
 */
- (void)logoutWithCompleteBlock:(void (^)(NSError *error))block;


/**
 *  get course array of current user
 *
 *  @param completedBlock complete block
 */
- (void)getCourseWithBlock:(void (^)(NSArray *result, NSArray *summary, NSError *error))completedBlock;

- (void)setPushEnabled:(BOOL)enabled withBlock:(void (^)(BOOL push, NSString *deviceToken, NSError *))completedBlock;

- (void)fetchPushEnabledWithBlock:(void (^)(BOOL push, NSString *deviceToken, NSError *error))completedBlock;

- (NSArray<GZSummary *> *)getGeneralCoursesStatistics;

- (void)saveCourseList;

@end
