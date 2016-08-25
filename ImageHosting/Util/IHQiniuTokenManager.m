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
#include <CommonCrypto/CommonCrypto.h>
#import "JSONKit.h"
#import "QN_GTM_Base64.h"

@interface IHQiniuTokenManager ()

@property (strong) IHCache *cache;
@property (assign) NSUInteger expires;

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

- (NSString *)generateUploadTokenForAccount:(IHAccount *)account
{
    if (account.accountType == IHAccountTypeNone) {
        return nil;
    }
    
    const char *secretKeyStr = [[account.sk ih_decode] UTF8String];
    NSString *policy = [self marshal:account.bucketName];
    NSData *policyData = [policy dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encodedPolicy = [QN_GTM_Base64 stringByWebSafeEncodingData:policyData padded:TRUE];
    const char *encodedPolicyStr = [encodedPolicy cStringUsingEncoding:NSUTF8StringEncoding];
    
    char digestStr[CC_SHA1_DIGEST_LENGTH];
    bzero(digestStr, 0);
    
    CCHmac(kCCHmacAlgSHA1, secretKeyStr, strlen(secretKeyStr), encodedPolicyStr, strlen(encodedPolicyStr), digestStr);
    
    NSString *encodedDigest = [QN_GTM_Base64 stringByWebSafeEncodingBytes:digestStr length:CC_SHA1_DIGEST_LENGTH padded:TRUE];
    
    NSString *token = [NSString stringWithFormat:@"%@:%@:%@",  account.ak, encodedDigest, encodedPolicy];
    
    return token;
}

- (NSString *)marshal:(NSString *)bucketName
{
    if (!bucketName) {
        return nil;
    }
    
    time_t deadline;
    time(&deadline);//返回当前系统时间

    deadline += (self.expires > 0) ? self.expires : 3600; // +3600秒,即默认token保存1小时.
    
    NSNumber *deadlineNumber = [NSNumber numberWithLongLong:deadline];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:bucketName forKey:@"scope"];
    [dict setObject:deadlineNumber forKey:@"deadline"];
    
    NSString *json = [dict JSONString];
    
    return json;
}

@end
