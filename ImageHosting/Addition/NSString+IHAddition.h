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
- (NSString *)ih_encrypt;

/** 解密 */
- (NSString *)ih_decode;

/** 是否有效字符串 */
- (BOOL)ih_isValid;

@end
