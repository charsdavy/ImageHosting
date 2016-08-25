//
//  IHGeneralManager.m
//  ImageHosting
//
//  Created by dengw on 16/8/24.
//  Copyright © 2016年 chars. All rights reserved.
//

#import "IHGeneralManager.h"
#import "IHCache.h"
#import "const.h"

@interface IHGeneralManager ()

@property (strong) IHCache *cache;

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
        _cache = [[IHCache alloc] init];
    }
    return self;
}

- (BOOL)systemNotification
{
    NSString *systemNotification = nil;
    
    if (self.cache) {
        systemNotification = [self.cache objectForKey:SYSTEM_NOTIFICATION_KEY];
    } else {
        systemNotification = [self unarchiveSystemNotification];
    }
    
    return [systemNotification isEqualToString:@"YES"] ? YES : NO;
}

- (BOOL)archiveSystemNotification:(NSString *)notificaion
{
    NSMutableArray *archive = [NSMutableArray array];
    NSString *path = [self pathOfPreferences];
    BOOL success = NO;
    BOOL replace = NO;
    
    if ([self fileExistAtPath:path]) {
        archive = [NSMutableArray arrayWithContentsOfFile:path];
    }
    
    for (NSMutableDictionary *cur in archive) {
        if (cur[SYSTEM_NOTIFICATION_KEY]) {
            cur[SYSTEM_NOTIFICATION_KEY] = notificaion;
            replace = YES;
        }
    }
    
    if (!replace) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:notificaion forKey:SYSTEM_NOTIFICATION_KEY];
        [archive addObject:dict];
    }
    
    if (self.cache) {
        [self.cache setObject:notificaion forKey:SYSTEM_NOTIFICATION_KEY];
    }
    
    success = [archive writeToFile:path atomically:YES];
    
    return success;
}

- (NSString *)unarchiveSystemNotification
{
    NSString *path = [self pathOfPreferences];
    NSArray *contents = [NSArray arrayWithContentsOfFile:path];

    for (NSDictionary *dict in contents) {
        if (dict[SYSTEM_NOTIFICATION_KEY]) {
            NSString *noti = dict[SYSTEM_NOTIFICATION_KEY];
            if (self.cache) {
                [self.cache setObject:noti forKey:SYSTEM_NOTIFICATION_KEY];
            }
            return noti;
        }
    }
    
    return nil;
}

@end
