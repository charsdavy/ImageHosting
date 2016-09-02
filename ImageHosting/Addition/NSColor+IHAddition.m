//
//  NSColor+IHAddition.m
//  ImageHosting
//
//  Created by chars on 16/9/2.
//  Copyright © 2016年 chars. All rights reserved.
//

#import "NSColor+IHAddition.h"

@implementation NSColor (IHAddition)

+ (NSColor *)ih_colorWithRGBString:(NSString *)string
{
    return [[self class] ih_colorWithRGBString:string alpha:1.0f];
}

+ (NSColor *)ih_colorWithRGBString:(NSString *)string alpha:(CGFloat)alpha
{
    if (!string || [string length] < 6) {
        return nil;
    }
    
    const char *cStr = [string cStringUsingEncoding:NSASCIIStringEncoding];
    long hex;
    if ([string length] <= 6) {
        hex = strtol(cStr, NULL, 16);
    } else {
        hex = strtol(cStr + 1, NULL, 16);
    }
    return [self ih_colorWithRGBHex:(NSUInteger)hex alpha:alpha];
}

+ (NSColor *)ih_colorWithRGBHex:(NSUInteger)hex
{
    return [self ih_colorWithRGBHex:hex alpha:1.0f];
}

+ (NSColor *)ih_colorWithRGBHex:(NSUInteger)hex alpha:(CGFloat)alpha
{
    unsigned char red = (hex >> 16) & 0xFF;
    unsigned char green = (hex >> 8) & 0xFF;
    unsigned char blue = hex & 0xFF;
    
    return [NSColor colorWithRed:(CGFloat)red / 255.0f
                           green:(CGFloat)green / 255.0f
                            blue:(CGFloat)blue / 255.0f
                           alpha:alpha];
}

@end
