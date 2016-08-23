//
//  IHQiniuUploadManager.h
//  ImageHosting
//
//  Created by dengw on 16/8/21.
//  Copyright © 2016年 chars. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QiniuSDK.h"

@class IHAccount;

@interface IHQiniuUploadManager : NSObject

+ (instancetype) sharedManager;

- (void)uploadQiniuForAccount:(IHAccount *)account key:(NSString *)key filePath:(NSString *)path complete:(QNUpCompletionHandler)complete;

@end
