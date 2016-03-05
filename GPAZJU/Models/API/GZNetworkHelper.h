//
//  GZNetworkHelper.h
//  GPAZJU
//
//  Created by Xinbao Dong on 10/5/15.
//  Copyright © 2015 com.dongxinbao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GZNetworkHelper : NSObject

+ (void)getCloudFunction:(NSString *)functionName withParameters:(NSDictionary *)para block:(void (^)(id, NSError *))completeBlock;

+ (void)callCloudFunction:(NSString *)functionName withParameters:(NSDictionary *)para block:(void (^)(id object, NSError *error))completeBlock;

@end
