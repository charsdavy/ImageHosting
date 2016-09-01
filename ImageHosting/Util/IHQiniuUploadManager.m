//
//  IHQiniuUploadManager.m
//  ImageHosting
//
//  Created by dengw on 16/8/21.
//  Copyright © 2016年 chars. All rights reserved.
//

#import "IHQiniuUploadManager.h"
#import "const.h"
#import "IHAccount.h"
#import "IHQiniuTokenManager.h"
#import "QiniuSDK.h"

@interface IHQiniuUploadManager ()

@end

@implementation IHQiniuUploadManager

+ (instancetype)sharedManager
{
    static IHQiniuUploadManager *sharedManager = nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        sharedManager = [[IHQiniuUploadManager alloc] init];
    });
    return sharedManager;
}

- (void)uploadQiniuForAccount:(IHAccount *)account key:(NSString *)key filePath:(NSString *)path completion:(IHQiniuCompletionHandler)completion progress:(IHQiniuProgressHandler)progress
{
    NSString *token = [[IHQiniuTokenManager sharedManager] generateUploadTokenForAccount:account];
    QNUploadManager *manager = [[QNUploadManager alloc] init];
    
    QNUploadOption *option = [[QNUploadOption alloc] initWithProgressHandler:^(NSString *key, float percent) {
        if (progress) {
            progress(key, percent);
        }
    }];
    [manager putFile:path key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        NSLog(@"%s info:%@", __FUNCTION__, info);
        if (completion) {
            completion(resp);
        }
    } option:option];
}

@end
