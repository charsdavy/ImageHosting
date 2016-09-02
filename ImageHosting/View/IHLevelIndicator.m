//
//  IHLevelIndicator.m
//  ImageHosting
//
//  Created by chars on 16/9/2.
//  Copyright © 2016年 chars. All rights reserved.
//

#import "IHLevelIndicator.h"

@implementation IHLevelIndicator

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    NSRect fillingRect = dirtyRect;
    fillingRect.size.width = dirtyRect.size.width * _percent / 100;
    NSColor *indicatorColor;
    
    if (_percent >= 99) {
        indicatorColor = [self colorRed:36 green:160 blue:97];
    } else if (_percent > 60) {
        indicatorColor = [self colorRed:194 green:143 blue:48];
    } else {
        indicatorColor = [self colorRed:40 green:158 blue:206];
    }
    [indicatorColor set];
    NSRectFill(fillingRect);
}

- (NSColor *)colorRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    NSColor *color = [NSColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:1.0f];
    return color;
}

- (void)setPercent:(NSInteger)percent
{
    if (_percent != percent) {
        _percent = percent;
    }
    [self setNeedsDisplay:YES];
}

@end
