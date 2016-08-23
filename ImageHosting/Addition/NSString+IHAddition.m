//
//  NSString+IHAddition.m
//  ImageHosting
//
//  Created by dengw on 16/8/20.
//  Copyright © 2016年 chars. All rights reserved.
//

#import "NSString+IHAddition.h"
#import "GTMBase64.h"

@implementation NSString (IHAddition)

- (NSString *)ih_encrypt
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];    
    return [GTMBase64 stringByEncodingData:data];
}

- (NSString *)ih_decode
{
    NSData *data = [GTMBase64 decodeString:self];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (BOOL)ih_isValid
{
    if (self.length > 0) {
        return YES;
    }
    return NO;
}

@end
