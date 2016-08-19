//
//  IHQiniuTokenManager.m
//  ImageHosting
//
//  Created by dengw on 16/8/19.
//  Copyright © 2016年 chars. All rights reserved.
//

#import "IHQiniuTokenManager.h"
#import "IHAccount.h"

@implementation IHQiniuTokenManager

+ (instancetype)sharedManager
{
    static IHQiniuTokenManager *sharedManager = nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        sharedManager = [[IHQiniuTokenManager alloc] init];
    });
    return sharedManager;
}

- (NSString *)tokenForAcount:(IHAccount *)account
{
    NSString *token = nil;
    return token;
}

@end
