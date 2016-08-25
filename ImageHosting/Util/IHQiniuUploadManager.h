//
//  IHQiniuUploadManager.h
//  ImageHosting
//
//  Created by dengw on 16/8/21.
//  Copyright © 2016年 chars. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IHAccount;

typedef void(^IHQiniuCompletionHandler)(NSDictionary *resp);
typedef void(^IHQiniuProgressHandler)(CGFloat percent);

@interface IHQiniuUploadManager : NSObject

+ (instancetype) sharedManager;

- (void)uploadQiniuForAccount:(IHAccount *)account key:(NSString *)key filePath:(NSString *)path completion:(IHQiniuCompletionHandler)completion progress:(IHQiniuProgressHandler)progress;

@end
