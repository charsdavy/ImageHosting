//
//  NSString+IHAddition.h
//  ImageHosting
//
//  Created by dengw on 16/8/20.
//  Copyright © 2016年 chars. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (IHAddition)

/** 加密 */
- (NSString *)encrypt:(NSString *)string;

/** 解密 */
- (NSString *)decode:(NSString *)string;

@end
