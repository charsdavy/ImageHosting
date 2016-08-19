//
//  IHAccount.h
//  ImageHosting
//
//  Created by chars on 16/8/19.
//  Copyright © 2016年 chars. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, IHAccountType) {
    IHAccountTypeNone = 0,
    IHAccountTypeQiniu
};

@interface IHAccount : NSObject

@property (nonatomic, assign) IHAccountType accountType;

/** 七牛云账号专用 */
@property (nonatomic, copy) NSString *ak;
@property (nonatomic, copy) NSString *sk;
@property (nonatomic, copy) NSString *bucketName;

@end
