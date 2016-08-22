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

- (void)uploadQiniuForAccount:(IHAccount *)account filePath:(NSString *)path complete:(QNUpCompletionHandler)complete
{
    NSString *token = [[IHQiniuTokenManager sharedManager] generateUploadTokenForAccount:account];
    QNUploadManager *manager = [[QNUploadManager alloc] init];
    
    [manager putFile:path key:nil token:token complete:complete option:nil];
}

@end
