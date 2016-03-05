//
//  GZUser.m
//  GPAZJU
//
//  Created by Xinbao Dong on 10/5/15.
//  Copyright © 2015 com.dongxinbao. All rights reserved.
//

#import <SSKeychain/SSKeychain.h>
#import "GZCourse.h"
#import "GZGrade.h"
#import "GZNetworkHelper.h"
#import "GZSummary.h"
#import "GZUser.h"
#import "MJExtension.h"

@interface GZUser ()

@property (strong, nonatomic) GZUser *gUser;

@end

@implementation GZUser

+ (instancetype)shareInstance
{
	static GZUser *sharedInstance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[GZUser alloc] init];
		if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"stuID"] length] > 0) {
			sharedInstance.gUser = [[GZUser alloc] initWithStuID:[[NSUserDefaults standardUserDefaults] objectForKey:@"stuID"]];
		}
	});
	return sharedInstance;
}

+ (instancetype)currentUser
{
	return [GZUser shareInstance].gUser;
}

- (instancetype)initWithStuID:(NSString *)stuID
{
	self = [super init];
	if (self) {
		_stuID = stuID;
		if ([[NSUserDefaults standardUserDefaults] objectForKey:@"courses"] && [stuID isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"stuID"]]) {
			_courseArray = [GZCourse objectArrayWithKeyValuesArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"courses"]];
			_summaryArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"summary"];
		}
	}
	return self;
}

+ (void)loginWithStuID:(NSString *)stuId andPassword:(NSString *)password withBlock:(void (^)(NSError *, GZUser *))completedBlock
{
	if (stuId == nil || stuId.length == 0 || password == nil || password.length == 0) {
		if (completedBlock) {
			completedBlock([NSError errorWithCode:GZErrorCodeIncomplete andDescription:nil], nil);
		}
	} else {
		[GZNetworkHelper callCloudFunction:@"auth" withParameters:@{
			@"stuID": stuId, @"password": password
		} block:^(id object, NSError *error) {
			if (error == nil) {
				[[NSUserDefaults standardUserDefaults] setObject:stuId forKey:@"stuID"];
				[SSKeychain setPassword:password forService:@"user" account:stuId];
				[GZUser shareInstance].gUser = [[GZUser alloc] initWithStuID:[[NSUserDefaults standardUserDefaults] objectForKey:@"stuID"]];
				[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"newLogin"];
				[[NSUserDefaults standardUserDefaults] synchronize];
			}
			if (completedBlock) {
				completedBlock(error, [GZUser shareInstance].gUser);
			}
		}];
	}
}

- (void)getCourseWithBlock:(void (^)(NSArray *, NSArray *, NSError *))completedBlock
{
	static BOOL loading;
	if (loading) {
		return;
	}
	if (![GZUser hasLogin]) {
		completedBlock ? completedBlock(nil, nil, [NSError errorWithCode:GZErrorCodeNotLogged andDescription:nil]) : nil;
		return;
	}
	if (![self checkAvailable]) {
		completedBlock ? completedBlock(nil, nil, [NSError errorWithCode:GZErrorCodeAuthenticateError andDescription:nil]) : nil;
		return;
	}
	loading = YES;
	WS(weakSelf);
	NSString *pass = [SSKeychain passwordForService:@"user" account:_stuID];
	[GZNetworkHelper callCloudFunction:@"mix" withParameters:@{
		@"stuID": _stuID, @"password": pass
	} block:^(id object, NSError *error) {
		dispatch_async(dispatch_get_global_queue(0, 0), ^{
			if (!error) {
				NSArray *array = [GZCourse objectArrayWithKeyValuesArray:[object objectForKey:@"courses"]];
				if ([[NSUserDefaults standardUserDefaults] boolForKey:@"newLogin"]) {
					[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"newLogin"];
					for (GZCourse *course in array) {
						course.read = YES;
					}
				}
				for (GZCourse *course in weakSelf.courseArray) {
					GZCourse *c;
					for (GZCourse *cc in array) {
						if ([cc.cid isEqualToString:course.cid]) {
							c = cc;
							break;
						}
					}
					if (c) {
						c.read = course.read;
					}
				}
				weakSelf.courseArray = array;
				weakSelf.summaryArray = [object objectForKey:@"summary"];
			}
			dispatch_async(dispatch_get_main_queue(), ^{
				if (!error) {
					[weakSelf saveCourseList];
				}
				if (completedBlock) {
					completedBlock(weakSelf.courseArray, weakSelf.summaryArray, error);
				}
				loading = NO;
			});

		});

	}];
}

- (void)saveCourseList
{
	@try {
		[[NSUserDefaults standardUserDefaults] setObject:[GZCourse keyValuesArrayWithObjectArray:self.courseArray] forKey:@"courses"];
		[[NSUserDefaults standardUserDefaults] setObject:self.summaryArray forKey:@"summary"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	} @catch (NSException *exception) {

	} @finally {
	}
}

- (void)setPushEnabled:(BOOL)enabled withBlock:(void (^)(BOOL push, NSString *deviceToken, NSError *error))completedBlock
{
	if (![GZUser hasLogin]) {
		completedBlock ? completedBlock(NO, nil, [NSError errorWithCode:GZErrorCodeNotLogged andDescription:nil]) : nil;
		return;
	}
	if (![self checkAvailable]) {
		completedBlock ? completedBlock(nil, nil, [NSError errorWithCode:GZErrorCodeAuthenticateError andDescription:nil]) : nil;
		return;
	}
	NSString *deviceToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"];
	if ([deviceToken length] == 0 && enabled) {
		completedBlock ? completedBlock(NO, nil, [NSError errorWithCode:GZErrorCodePushClosed andDescription:nil]) : nil;
		return;
	}
	if (!deviceToken) {
		deviceToken = @"";
	}

	NSString *pass = [SSKeychain passwordForService:@"user" account:_stuID];
	if (!pass) {
		pass = @"";
	}
	NSString *stuID = _stuID ? _stuID : @"";
	[GZNetworkHelper callCloudFunction:@"push" withParameters:@{
		@"stuID": stuID, @"password": pass, @"enabled": @(enabled), @"deviceToken": deviceToken
	} block:^(id object, NSError *error) {
		BOOL enabled = [[object objectForKey:@"enabled"] boolValue];
		NSString *dt = [object objectForKey:@"deviceToken"];
		completedBlock ? completedBlock(enabled, dt, error) : nil;
	}];
}

- (void)fetchPushEnabledWithBlock:(void (^)(BOOL push, NSString *deviceToken, NSError *))completedBlock
{
	if (![GZUser hasLogin]) {
		completedBlock ? completedBlock(NO, nil, [NSError errorWithCode:GZErrorCodeNotLogged andDescription:nil]) : nil;
		return;
	}
	if (![self checkAvailable]) {
		completedBlock ? completedBlock(nil, nil, [NSError errorWithCode:GZErrorCodeAuthenticateError andDescription:nil]) : nil;
		return;
	}
	NSString *pass = [SSKeychain passwordForService:@"user" account:_stuID];
	[GZNetworkHelper getCloudFunction:@"push" withParameters:@{
		@"stuID": _stuID, @"password": pass
	} block:^(id object, NSError *error) {
		if (error) {
			completedBlock ? completedBlock(NO, nil, error) : nil;
		} else {
			completedBlock ? completedBlock([[object valueForKey:@"enabled"] boolValue], [object valueForKey:@"deviceToken"], error) : nil;
		}
	}];
}

+ (BOOL)hasLogin
{
	return [GZUser currentUser] != nil;
}

- (void)logoutWithCompleteBlock:(void (^)(NSError *error))block
{
	if (![self checkAvailable]) {
		block ? block([NSError errorWithCode:GZErrorCodeAuthenticateError andDescription:nil]) : nil;
		return;
	}
	WS(weakSelf);
	[self setPushEnabled:NO withBlock:^(BOOL push, NSString *deviceToken, NSError *error) {
		if (error) {
			block ? block(error) : nil;
		} else {
			[SSKeychain deletePasswordForService:@"user" account:weakSelf.stuID];
			[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"stuID"];
			[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"courses"];
			[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"summary"];
			[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"newLogin"];
			[[NSUserDefaults standardUserDefaults] synchronize];
			[GZUser shareInstance].gUser = nil;
			[[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:nil];
			block ? block(error) : nil;
		}
	}];
}

- (NSArray<GZSummary *> *)getGeneralCoursesStatistics
{
	NSArray *array = [[NSArray alloc] initWithObjects:@"J", @"H", @"I", @"L", @"K", @"M", @"S", @"X", nil];
	NSDictionary *intro = @{ @"J": @"沟通与领导类", @"H": @"历史与文化类", @"I": @"文学与艺术类", @"L": @"经济与社会类", @"K": @"科学与研究类", @"S": @"通识核心课程", @"X": @"新生研讨课", @"M": @"技术与设计类" };
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	for (GZCourse *course in self.courseArray) {
		NSString *class = [course.cid substringWithRange:NSMakeRange(17, 1)];
		if ([intro objectForKey:class]) {
			GZSummary *courseSummary = [dic objectForKey:class];
			if (!courseSummary) {
				courseSummary = [GZSummary new];
				courseSummary.introduction = [intro objectForKey:class];
				[dic setObject:courseSummary forKey:class];
			}
			[courseSummary addCourse:course];
		}
	}
	NSMutableArray *result = [NSMutableArray array];
	for (NSString *class in array) {
		if ([dic objectForKey:class]) {
			[result addObject:[dic objectForKey:class]];
		}
	}
	return [result copy];
}

- (GZUser *)gUser
{
	if ([GZUser shareInstance] == self) {
		return _gUser;
	}
	return nil;
}

- (BOOL)checkAvailable
{
	NSString *pass = [SSKeychain passwordForService:@"user" account:_stuID];
	BOOL s = [GZUser currentUser] != self;
	if ([_stuID length] == 0 || [pass length] == 0 || s) {
		return NO;
	}
	return YES;
}

@end
