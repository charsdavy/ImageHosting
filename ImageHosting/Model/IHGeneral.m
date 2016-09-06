//
//  IHGeneral.m
//  ImageHosting
//
//  Created by chars on 16/9/6.
//  Copyright © 2016年 chars. All rights reserved.
//

#import "IHGeneral.h"

#define USER_NOTIFICATION_KEY @"user_notification"

@implementation IHGeneral

#pragma mark - 编码 对对象属性进行编码的处理

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_userNotification forKey:USER_NOTIFICATION_KEY];
}

#pragma mark - 解码 解码归档数据来初始化对象

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _userNotification = [aDecoder decodeObjectForKey:USER_NOTIFICATION_KEY];
    }
    return self;
}

@end
