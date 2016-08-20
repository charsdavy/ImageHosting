//
//  IHQiniuTokenManager.m
//  ImageHosting
//
//  Created by dengw on 16/8/19.
//  Copyright © 2016年 chars. All rights reserved.
//

#import "IHQiniuTokenManager.h"
#import "IHAccount.h"
#import "NSString+IHAddition.h"
#import "IHCache.h"
#import "const.h"
#import "IHAccountManager.h"

@interface IHQiniuTokenManager ()

@property (strong) IHCache *cache;

@end

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

- (NSString *)searchTokenForLocalWithAccount:(IHAccount *)account
{
    NSString *token = nil;
    NSArray *accounts = [[IHAccountManager sharedManager] unarchive];
    for (NSDictionary *dict in accounts) {
        if ([dict[AK_KEY] isEqualToString:account.ak] && [dict[SK_KEY] isEqualToString:account.sk]) {
            token = dict[TOKEN_KEY];
        }
    }
    return token;
}

- (NSString *)tokenForAcount:(IHAccount *)account
{
    NSString *token = nil;
    
    if (self.cache) {
        token = [self.cache objectForKey:TOKEN_KEY];
    } else {
        token = [self searchTokenForLocalWithAccount:account];
        
        if (!token) {
            token = [self tokenForServerWithAccount:account];
        }
        
        if (token) {
            [self.cache setObject:token forKey:TOKEN_KEY];
        }
    }
    
    return token;
}

- (BOOL)saveTokenForLocalWithAccount:(IHAccount *)acount
{
    BOOL success = NO;
    
    return success;
}

- (NSString *)tokenForServerWithAccount:(IHAccount *)acount
{
    NSString *token = nil;
    
    return token;
}

@end
