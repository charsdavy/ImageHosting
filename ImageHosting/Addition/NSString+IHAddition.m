//
//  NSString+IHAddition.m
//  ImageHosting
//
//  Created by dengw on 16/8/20.
//  Copyright © 2016年 chars. All rights reserved.
//

#import "NSString+IHAddition.h"

@implementation NSString (IHAddition)

- (NSString *)ih_encrypt:(NSString *)string
{
    NSString *encrypt = nil;
    return encrypt;
}

- (NSString *)ih_decode:(NSString *)string
{
    NSString *decode = nil;
    return decode;
}

- (BOOL)ih_isValid
{
    if (self.length > 0) {
        return YES;
    }
    return NO;
}

@end
