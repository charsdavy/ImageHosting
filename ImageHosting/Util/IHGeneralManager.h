//
//  IHGeneralManager.h
//  ImageHosting
//
//  Created by dengw on 16/8/24.
//  Copyright © 2016年 chars. All rights reserved.
//

#import "IHPreferencesManager.h"

@interface IHGeneralManager : IHPreferencesManager

+ (instancetype)sharedManager;

- (BOOL)systemNotification;

- (BOOL)archive:(id)object key:(NSString *)key;

- (NSString *)unarchiveSystemNotification;

@end
