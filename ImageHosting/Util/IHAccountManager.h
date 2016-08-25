//
//  IHAccountManager.h
//  ImageHosting
//
//  Created by dengw on 16/8/19.
//  Copyright © 2016年 chars. All rights reserved.
//

#import "IHPreferencesManager.h"

@class IHAccount;

@interface IHAccountManager : IHPreferencesManager

+ (instancetype)sharedManager;

- (IHAccount *)currentAccount;

- (BOOL)archiveAccount:(IHAccount *)account;

- (NSArray *)unarchive;

@end
