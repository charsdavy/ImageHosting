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

- (IHAccount *)currentAccount
{
    IHAccount *currentAccount = nil;
    if (self.cache) {
        currentAccount = [self.cache objectForKey:CURRENT_ACCOUNT_KEY];
    }

    if (!currentAccount) {
        NSString *path = [self pathOfPreferences];
        NSArray *contents = [NSArray arrayWithContentsOfFile:path];
        for (NSDictionary *dict in contents) {
            if (dict[ACCOUNTS_KEY]) {
                NSDictionary *cur = dict[ACCOUNTS_KEY];
                currentAccount = [[IHAccount alloc] init];
                currentAccount.accountType = [cur[TYPE_KEY] integerValue];
                currentAccount.ak = cur[AK_KEY];
                currentAccount.sk = cur[SK_KEY];
                currentAccount.bucketName = cur[BUCKET_KEY];
                currentAccount.region = cur[REGION_KEY];
                [self.cache setObject:currentAccount forKey:CURRENT_ACCOUNT_KEY];
            }
        }
    }
    NSLog(@"%s path of preferences file:%@ currentAccount:%@", __FUNCTION__, [self pathOfPreferences], currentAccount);
    return currentAccount;
}

- (BOOL)archiveAccount:(IHAccount *)account
{
    NSMutableArray *archive = [NSMutableArray array];
    NSString *path = [self pathOfPreferences];
    BOOL success = NO;
    BOOL replace = NO;

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@(account.accountType) forKey:TYPE_KEY];
    [dict setObject:account.ak forKey:AK_KEY];
    [dict setObject:[account.sk ih_encrypt] forKey:SK_KEY];
    [dict setObject:account.bucketName forKey:BUCKET_KEY];
    [dict setObject:account.region forKey:REGION_KEY];

    if ([self fileExistAtPath:path]) {
        archive = [NSMutableArray arrayWithContentsOfFile:path];
    }

    for (NSDictionary *curArchive in archive) {
        if (curArchive[ACCOUNTS_KEY]) {
            NSMutableDictionary *cur = curArchive[ACCOUNTS_KEY];
            cur[TYPE_KEY] = dict[TYPE_KEY];
            cur[AK_KEY] = dict[AK_KEY];
            cur[SK_KEY] = dict[SK_KEY];
            cur[BUCKET_KEY] = dict[BUCKET_KEY];
            cur[REGION_KEY] = dict[REGION_KEY];
            replace = YES;
        }
    }

    if (!replace) {
        NSMutableDictionary *append = [NSMutableDictionary dictionary];
        [append setObject:dict forKey:ACCOUNTS_KEY];
        [archive addObject:append];
    }
    success = [archive writeToFile:path atomically:YES];
    
    return success;
}

- (NSArray<IHAccount *> *)unarchive
{
    NSString *path = [self pathOfPreferences];
    NSArray *contents = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *unarchive = [NSMutableArray array];
    for (NSDictionary *dict in contents) {
        if (dict[ACCOUNTS_KEY]) {
            IHAccount *account = [[IHAccount alloc] init];
            account.accountType = [dict[TYPE_KEY] integerValue];
            account.ak = dict[AK_KEY];
            account.sk = dict[SK_KEY];
            account.bucketName = dict[BUCKET_KEY];
            account.region = dict[REGION_KEY];
            [unarchive addObject:account];
        }
    }

    return unarchive;
}

- (BOOL)archive:(id)object key:(NSString *)key
{
    NSMutableArray *archive = [NSMutableArray array];
    NSString *path = [self pathOfPreferences];
    BOOL success = NO;
    BOOL replace = NO;

    if ([self fileExistAtPath:path]) {
        archive = [NSMutableArray arrayWithContentsOfFile:path];
    }

    for (NSMutableDictionary *cur in archive) {
        if (cur[key]) {
            cur[key] = object;
            replace = YES;
        }
    }

    if (!replace) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:object forKey:key];
        [archive addObject:dict];
    }

    if (self.cache) {
        [self.cache setObject:object forKey:key];
    }

    success = [archive writeToFile:path atomically:YES];

    return success;
}

- (NSString *)unarchiveForKey:(NSString *)key
{
    NSString *path = [self pathOfPreferences];
    NSArray *contents = [NSArray arrayWithContentsOfFile:path];
    NSString *unarchive = nil;
    for (NSDictionary *dict in contents) {
        if (dict[key]) {
            unarchive = dict[key];
        }
    }

    return unarchive;
}

@end
