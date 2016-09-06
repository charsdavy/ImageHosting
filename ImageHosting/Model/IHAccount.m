//
//  IHAccount.m
//  ImageHosting
//
//  Created by chars on 16/8/19.
//  Copyright © 2016年 chars. All rights reserved.
//

#import "IHAccount.h"

#define ACCOUNT_TYPE_KEY @"account_type"
#define AK_KEY           @"ak"
#define SK_KEY           @"sk"
#define BUCKET_NAME_KEY  @"bucket_name"
#define REGION_KEY       @"region"

@implementation IHAccount

#pragma mark - 编码 对对象属性进行编码的处理

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:_accountType forKey:ACCOUNT_TYPE_KEY];
    [aCoder encodeObject:_ak forKey:AK_KEY];
    [aCoder encodeObject:_sk forKey:SK_KEY];
    [aCoder encodeObject:_bucketName forKey:BUCKET_NAME_KEY];
    [aCoder encodeObject:_region forKey:REGION_KEY];
}

#pragma mark - 解码 解码归档数据来初始化对象

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _accountType = [aDecoder decodeIntegerForKey:ACCOUNT_TYPE_KEY];
        _ak = [aDecoder decodeObjectForKey:AK_KEY];
        _sk = [aDecoder decodeObjectForKey:SK_KEY];
        _bucketName = [aDecoder decodeObjectForKey:BUCKET_NAME_KEY];
        _region = [aDecoder decodeObjectForKey:REGION_KEY];
    }
    return self;
}

@end
