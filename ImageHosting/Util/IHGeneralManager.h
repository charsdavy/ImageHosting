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

- (BOOL)archive:(id)object key:(NSString *)key;

- (id)unarchiveForKey:(NSString *)key;

- (void)startupAppWhenLogin:(BOOL)startup;

@end
