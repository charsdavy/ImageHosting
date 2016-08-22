//
//  IHQiniuTokenManager.h
//  ImageHosting
//
//  Created by dengw on 16/8/19.
//  Copyright © 2016年 chars. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IHAccount;

@interface IHQiniuTokenManager : NSObject

+ (instancetype) sharedManager;

- (NSString *)generateUploadTokenForAccount:(IHAccount *)account;

@end
