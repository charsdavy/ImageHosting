//
//  IHPreferencesManager.m
//  ImageHosting
//
//  Created by dengw on 16/8/24.
//  Copyright © 2016年 chars. All rights reserved.
//

#import "IHPreferencesManager.h"

@implementation IHPreferencesManager

+ (instancetype)sharedManager
{
    static IHPreferencesManager *sharedManager = nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        sharedManager = [[IHPreferencesManager alloc] init];
    });
    return sharedManager;
}

- (NSString *)pathLibraryPreferences
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths lastObject];
    libraryDirectory = [libraryDirectory stringByAppendingString:@"/Preferences"];
    return libraryDirectory;
}

- (NSString *)pathOfPreferences:(NSString *)fileName
{
    NSString *path = [self pathLibraryPreferences];
    NSString *append = [NSString stringWithFormat:@"/%@", fileName];
    path = [path stringByAppendingString:append];
    return path;
}

- (BOOL)fileExistAtPath:(NSString *)path
{
    BOOL isExist = NO;
    isExist = [[NSFileManager defaultManager] fileExistsAtPath:path];
    return isExist;
}

@end
