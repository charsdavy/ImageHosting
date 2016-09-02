//
//  IHLevelIndicator.m
//  ImageHosting
//
//  Created by chars on 16/9/2.
//  Copyright © 2016年 chars. All rights reserved.
//

#import "IHLevelIndicator.h"
#import "NSColor+IHAddition.h"

@implementation IHLevelIndicator

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    NSRect fillingRect = dirtyRect;
    fillingRect.size.width = dirtyRect.size.width * _percent / 100;
    NSColor *indicatorColor;
    
    if (_percent >= 99) {
        indicatorColor = [NSColor ih_colorWithRGBString:@"#24A061"];
    } else if (_percent > 60) {
        indicatorColor = [NSColor ih_colorWithRGBString:@"#C28F30"];
    } else {
        indicatorColor = [NSColor ih_colorWithRGBString:@"#289ECE"];
    }
    [indicatorColor set];
    NSRectFill(fillingRect);
}

- (void)setPercent:(NSInteger)percent
{
    if (_percent != percent) {
        _percent = percent;
    }
    [self setNeedsDisplay:YES];
}

@end
