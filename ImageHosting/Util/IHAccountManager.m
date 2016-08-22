//
//  IHAccountManager.m
//  ImageHosting
//
//  Created by dengw on 16/8/19.
//  Copyright © 2016年 chars. All rights reserved.
//

#import "IHAccountManager.h"
#import "IHAccount.h"
#import "NSString+IHAddition.h"
#import "const.h"
#import "IHCache.h"

@interface IHAccountManager ()

@property (strong) IHCache *cache;

@end

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
    if (self.cache) {
        currentAccount = [self.cache objectForKey:CURRENT_ACCOUNT_KEY];
    } else {
        NSString *path = [self pathOfPreferences];
        NSArray *accounts = [NSArray arrayWithContentsOfFile:path];
        NSDictionary *dict = [accounts lastObject];

        currentAccount.accountType = [dict[TYPE_KEY] integerValue];
        currentAccount.ak = dict[AK_KEY];
        currentAccount.sk = dict[SK_KEY];
        currentAccount.bucketName = dict[BUCKET_KEY];
        [self.cache setObject:currentAccount forKey:CURRENT_ACCOUNT_KEY];
    }

    return currentAccount;
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
        if ([cur[TYPE_KEY] integerValue] == account.accountType) {
            cur[AK_KEY] = account.ak;
            cur[SK_KEY] = account.sk;
            cur[BUCKET_KEY] = account.bucketName;
            replace = YES;
        }
    }

    if (!replace) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@(account.accountType) forKey:TYPE_KEY];
        [dict setObject:account.ak forKey:AK_KEY];
        [dict setObject:account.sk forKey:SK_KEY];
        [dict setObject:account.bucketName forKey:BUCKET_KEY];
        [archive addObject:dict];
    }

    success = [archive writeToFile:path atomically:YES];

    return success;
}

- (NSArray *)unarchive
{
    NSString *path = [self pathOfPreferences];
    NSArray *accounts = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *unarchive = [NSMutableArray array];
    for (NSDictionary *dict in accounts) {
        IHAccount *account = [[IHAccount alloc] init];
        account.accountType = [dict[TYPE_KEY] integerValue];
        account.ak = dict[AK_KEY];
        account.sk = dict[SK_KEY];
        account.bucketName = dict[BUCKET_KEY];
        [unarchive addObject:account];
    }

    return unarchive;
}

@end
