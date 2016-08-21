//
//  IHQiniuUploadManager.h
//  ImageHosting
//
//  Created by dengw on 16/8/21.
//  Copyright © 2016年 chars. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IHAccount;

@interface IHQiniuUploadManager : NSObject

+ (instancetype) sharedManager;

- (BOOL)uploadQiniuForAccount:(IHAccount *)account;

@end
