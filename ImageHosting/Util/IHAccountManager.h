//
//  IHAccountManager.h
//  ImageHosting
//
//  Created by dengw on 16/8/19.
//  Copyright © 2016年 chars. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IHAccount;

@interface IHAccountManager : NSObject

+ (instancetype)sharedManager;

- (IHAccount *)currentAccount;

- (BOOL)archiveAccount:(IHAccount *)account;

- (NSArray *)unarchive;

- (NSString *)pathOfPreferences;

@end
