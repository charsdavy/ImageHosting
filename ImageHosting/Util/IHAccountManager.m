//
//  IHAccountManager.m
//  ImageHosting
//
//  Created by dengw on 16/8/19.
//  Copyright © 2016年 chars. All rights reserved.
//

#import "IHAccountManager.h"
#import "IHAccount.h"

@implementation IHAccountManager

+ (instancetype)sharedManager
{
    static IHAccountManager *sharedManager = nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        sharedManager = [[IHAccountManager alloc] init];
    });
    return sharedManager;
}

- (BOOL)isFileExistAtPath:(NSString *)fileFullPath
{
    BOOL isExist = NO;
    isExist = [[NSFileManager defaultManager] fileExistsAtPath:fileFullPath];
    return isExist;
}

- (NSString *)pathLibraryPreferences
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = paths[0];
    libraryDirectory = [libraryDirectory stringByAppendingString:@"/Preferences"];
    return libraryDirectory;
}

- (NSString *)pathOfPreferences
{
    NSString *path = [self pathLibraryPreferences];
    path = [path stringByAppendingString:@"/IHAccount.json"];
    return path;
}

- (IHAccount *)currentAccount
{
    IHAccount *currentAccount = [[IHAccount alloc] init];
    NSString *path = [self pathOfPreferences];
    NSArray *accounts = [NSArray arrayWithContentsOfFile:path];
    NSDictionary *dict = [accounts lastObject];
    
    currentAccount.accountType = [dict[@"type"] integerValue];
    currentAccount.ak = dict[@"ak"];
    currentAccount.sk = dict[@"sk"];
    currentAccount.bucketName = dict[@"bucket"];
    
    return currentAccount;
}

- (NSString *)encryptString:(NSString *)string
{
    NSString *encrypt = nil;
    return encrypt;
}

- (NSString *)decodeString:(NSString *)string
{
    NSString *decode = nil;
    return decode;
}

- (BOOL)archiveAccount:(IHAccount *)account
{
    NSMutableArray *archive = [NSMutableArray array];
    NSString *path = [self pathOfPreferences];
    BOOL success = NO;
    BOOL replace = NO;
    
    if ([self isFileExistAtPath:path]) {
        archive = [NSMutableArray arrayWithContentsOfFile:path];
    }
    
    for (NSMutableDictionary *cur in archive) {
        if ([cur[@"type"] integerValue] == account.accountType) {
            cur[@"ak"] = account.ak;
            cur[@"sk"] = account.sk;
            cur[@"bucket"] = account.bucketName;
            replace = YES;
        }
    }
    
    if (!replace) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@(account.accountType) forKey:@"type"];
        [dict setObject:account.ak forKey:@"ak"];
        [dict setObject:account.sk forKey:@"sk"];
        [dict setObject:account.bucketName forKey:@"bucket"];
        [archive addObject:dict];
    }
    
    success = [archive writeToFile:path atomically:YES];
    
    if (success) {
        return YES;
    }
    
    return NO;
}

- (NSArray *)unarchive
{
    NSString *path = [self pathOfPreferences];
    NSArray *accounts = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *unarchive = [NSMutableArray array];
    for (NSDictionary *dict in accounts) {
        IHAccount *account = [[IHAccount alloc] init];
        account.accountType = [dict[@"type"] integerValue];
        account.ak = dict[@"ak"];
        account.sk = dict[@"sk"];
        account.bucketName = dict[@"bucket"];
        [unarchive addObject:account];
    }
    
    return unarchive;
}

@end
