//
//  NSError+Custom.m
//  GPAZJU
//
//  Created by Xinbao Dong on 1/30/16.
//  Copyright © 2016 com.dongxinbao. All rights reserved.
//

#import "NSError+Custom.h"

@implementation NSError (Custom)

+ (instancetype)errorWithCode:(GZErrorCode)code andDescription:(NSString *)description
{
	if (code != GZErrorCodeUnknown) {
		if ([description length] == 0) {
			description = [self reasonForCode:code];
		}
	}
	NSError *error = [[NSError alloc] initWithDomain:@"com.dongxinbao" code:code userInfo:@{NSLocalizedDescriptionKey: description ? description : [self reasonForCode:GZErrorCodeUnknown]}];
	return error;
}

+ (NSString *)reasonForCode:(GZErrorCode)code
{
	BOOL chinese = [[[NSLocale preferredLanguages] firstObject] containsString:@"zh-Hans"];
	switch (code) {
		case GZErrorCodeNetworkError:
			return chinese ? @"连接服务器失败，请重试。" : @"Failed to connect to the server. Please try again.";
			break;
		case GZErrorCodeNotLogged:
			return chinese ? @"您还没有登录，请登录后再试。" : @"You have not logged in yet. Please sign in first.";
			break;
		case GZErrorCodeAuthenticateError:
			return chinese ? @"权限错误，请重试。" : @"Permission denied. Please try again.";
			break;
		case GZErrorCodeUnknown:
			return chinese ? @"未知错误，请与开发者联系。" : @"Unknown Error. Please contact the developer.";
			break;
		case GZErrorCodeIncomplete:
			return chinese ? @"请填写必要信息。" : @"Please enter the necessary information.";
			break;
		case GZErrorCodePushClosed:
			return chinese ? @"推送未开启，请在设置中开启推送后再试。" : @"Push notification is disabled. Please enable it and try again.";
			break;
		default:
			return nil;
			break;
	}
}

@end
