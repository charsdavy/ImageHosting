//
//  IHGeneralManager.m
//  ImageHosting
//
//  Created by dengw on 16/8/24.
//  Copyright © 2016年 chars. All rights reserved.
//

#import "IHGeneralManager.h"
#import "const.h"
#import <Cocoa/Cocoa.h>
#import <ServiceManagement/ServiceManagement.h>

#define GENERAL_FILE_NAME @"IHGeneral.db"

@interface IHGeneralManager ()

@end

@implementation IHGeneralManager

+ (instancetype)sharedManager
{
    static IHGeneralManager *sharedManager = nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        sharedManager = [[IHGeneralManager alloc] init];
    });
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (BOOL)archive:(id)object key:(NSString *)key
{
    if (!object || !key) {
        return NO;
    }
    
    NSString *filePath = [self pathOfPreferences:GENERAL_FILE_NAME];
    NSMutableData *archiverData = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:archiverData];
    
    [archiver encodeObject:object forKey:key];
    
    [archiver finishEncoding];
    
    return [archiverData writeToFile:filePath atomically:YES];
    
}

- (id)unarchiveForKey:(NSString *)key
{
    NSString *filePath = [self pathOfPreferences:GENERAL_FILE_NAME];
    NSData *unarchiverData = [NSData dataWithContentsOfFile:filePath];
    NSKeyedUnarchiver *unachiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:unarchiverData];
    
    return [unachiver decodeObjectForKey:key];
}

- (void)startupAppWhenLogin:(BOOL)startup
{
    SMLoginItemSetEnabled((CFStringRef)@"cn.zaker.chars.ImageHostingHelper", startup);
    BOOL startedAtLogin = NO;
    NSArray *apps = [NSWorkspace sharedWorkspace].runningApplications;
    for (NSRunningApplication *app in apps) {
        if ([app.bundleIdentifier isEqualToString:@"cn.zaker.chars.ImageHostingHelper"]) {
            startedAtLogin = YES;
            break;
        }
    }
    if (startedAtLogin) {
        [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"killIHhelper" object:[NSBundle mainBundle].bundleIdentifier];
    }
}

@end
