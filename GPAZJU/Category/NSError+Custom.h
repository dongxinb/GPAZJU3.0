//
//  NSError+Custom.h
//  GPAZJU
//
//  Created by Xinbao Dong on 1/30/16.
//  Copyright © 2016 com.dongxinbao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, GZErrorCode) {
    GZErrorCodeNetworkError = 1001,
    GZErrorCodeNotLogged = 1002,
    GZErrorCodeAuthenticateError = 1003,
    GZErrorCodeIncomplete = 1004,
    GZErrorCodePushClosed = 1005,
    GZErrorCodeUnknown = 1099
};

@interface NSError (Custom)

+ (instancetype)errorWithCode:(GZErrorCode)code andDescription:(NSString *)description;
+ (NSString *)reasonForCode:(GZErrorCode)code;

@end
