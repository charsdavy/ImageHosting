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

#define ACCOUNT_FILE_NAME @"IHAccount.db"

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

- (BOOL)archive:(id)object key:(NSString *)key
{
    if (!object || !key) {
        return NO;
    }
    
    NSString *filePath = [self pathOfPreferences:ACCOUNT_FILE_NAME];
    NSMutableData *archiverData = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:archiverData];
    NSData *unarchiverData = [NSData dataWithContentsOfFile:filePath];
    NSKeyedUnarchiver *unachiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:unarchiverData];
    
    if ([object isKindOfClass:[IHAccount class]]) {
        NSMutableArray *accounts = [unachiver decodeObjectForKey:key];
        if (accounts) {
            BOOL replace = NO;
            for (IHAccount *cur in accounts) {
                if (cur.accountType == ((IHAccount *)object).accountType) {
                    cur.ak = ((IHAccount *)object).ak;
                    cur.sk = ((IHAccount *)object).sk;
                    cur.bucketName = ((IHAccount *)object).bucketName;
                    cur.region = ((IHAccount *)object).region;
                    replace = YES;
                    break;
                }
            }
            
            if (!replace) {
                [accounts addObject:object];
            }
        } else {
            accounts = [NSMutableArray arrayWithObject:object];
        }
        
        [archiver encodeObject:accounts forKey:key];
    } else {
        [archiver encodeObject:object forKey:key];
    }
    
    [archiver finishEncoding];
    
    return [archiverData writeToFile:filePath atomically:YES];
    
}

- (id)unarchiveForKey:(NSString *)key
{
    NSString *filePath = [self pathOfPreferences:ACCOUNT_FILE_NAME];
    NSData *unarchiverData = [NSData dataWithContentsOfFile:filePath];
    NSKeyedUnarchiver *unachiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:unarchiverData];
    
    return [unachiver decodeObjectForKey:key];
}

- (IHAccount *)currentAccount
{
    IHAccount *currentAccount = nil;
    if (self.cache) {
        currentAccount = [self.cache objectForKey:CURRENT_ACCOUNT_KEY];
    }
    
    if (!currentAccount) {
        NSMutableArray *accounts = [self unarchiveForKey:ACCOUNTS_KEY];
        currentAccount = [accounts lastObject];
        
        [self.cache setObject:currentAccount forKey:CURRENT_ACCOUNT_KEY];
    }
    NSLog(@"%s path of preferences file:%@ currentAccount:%@", __FUNCTION__, [self pathOfPreferences:ACCOUNT_FILE_NAME], currentAccount);
    return currentAccount;
}

@end
