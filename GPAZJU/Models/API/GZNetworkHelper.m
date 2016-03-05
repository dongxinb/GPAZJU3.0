//
//  GZNetworkHelper.m
//  GPAZJU
//
//  Created by Xinbao Dong on 10/5/15.
//  Copyright © 2015 com.dongxinbao. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import "AFNetworking.h"
#import "GZNetworkHelper.h"

static NSString *domain = @"com.dongxinbao.gpazju";

@implementation GZNetworkHelper

+ (NSString *)serverIp
{
	if ([[AVAnalytics getConfigParams:@"serverIp"] length] > 0) {
		return [AVAnalytics getConfigParams:@"serverIp"];
	}
	return @"https://gpazju.leanapp.cn";
}

+ (void)callCloudFunction:(NSString *)functionName withParameters:(NSDictionary *)para block:(void (^)(id, NSError *))completeBlock
{
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
	[manager.requestSerializer setTimeoutInterval:30];
	[manager POST:[NSString stringWithFormat:@"%@/api/%@", [self serverIp], functionName] parameters:para success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull res) {
		completeBlock([res objectForKey:@"data"], [[[res valueForKey:@"status"] valueForKey:@"code"] integerValue] == 200 ? nil : [NSError errorWithCode:[[[res valueForKey:@"status"] valueForKey:@"code"] integerValue] andDescription:[[res valueForKey:@"status"] valueForKey:@"msg"]]);
	} failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
		completeBlock(nil, [NSError errorWithCode:GZErrorCodeNetworkError andDescription:nil]);
	}];
}

+ (void)getCloudFunction:(NSString *)functionName withParameters:(NSDictionary *)para block:(void (^)(id, NSError *))completeBlock
{
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
	[manager.requestSerializer setTimeoutInterval:30];
	[manager GET:[NSString stringWithFormat:@"%@/api/%@", [self serverIp], functionName] parameters:para success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull res) {
		completeBlock([res objectForKey:@"data"], [[[res valueForKey:@"status"] valueForKey:@"code"] integerValue] == 200 ? nil : [NSError errorWithCode:[[[res valueForKey:@"status"] valueForKey:@"code"] integerValue] andDescription:[[res valueForKey:@"status"] valueForKey:@"msg"]]);
	} failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
		completeBlock(nil, [NSError errorWithCode:GZErrorCodeNetworkError andDescription:nil]);
	}];
}

@end
