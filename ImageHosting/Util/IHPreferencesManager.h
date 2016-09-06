//
//  IHPreferencesManager.h
//  ImageHosting
//
//  Created by dengw on 16/8/24.
//  Copyright © 2016年 chars. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IHPreferencesManager : NSObject

- (NSString *)pathOfPreferences:(NSString *)fileName;

- (BOOL)fileExistAtPath:(NSString *)path;

@end
