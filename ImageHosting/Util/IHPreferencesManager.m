//
//  IHPreferencesManager.m
//  ImageHosting
//
//  Created by dengw on 16/8/24.
//  Copyright © 2016年 chars. All rights reserved.
//

#import "IHPreferencesManager.h"

@implementation IHPreferencesManager

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
    path = [path stringByAppendingString:@"/IHPreferences.plist"];
    return path;
}

- (BOOL)fileExistAtPath:(NSString *)path
{
    BOOL isExist = NO;
    isExist = [[NSFileManager defaultManager] fileExistsAtPath:path];
    return isExist;
}

@end
