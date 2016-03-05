//
//  GZModel.m
//  GPAZJU
//
//  Created by Xinbao Dong on 10/5/15.
//  Copyright © 2015 com.dongxinbao. All rights reserved.
//

#import "GZModel.h"
#import "MJExtension.h"

@implementation GZModel

+ (instancetype)modelWithJson:(NSDictionary *)dic
{
    return [self objectWithKeyValues:dic];

}

@end
