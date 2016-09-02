//
//  BRLinkLabel.m
//  BRLinkLabel
//
//  Created by Yang on 16/2/29.
//  Copyright © 2016年 sgyang. All rights reserved.
//

#import "BRLinkLabel.h"

#define BRStringFont 14.0f

@interface BRLinkLabel ()

@property (nonatomic, assign) BOOL mouseIn;
@property (retain) NSTrackingArea *trackingArea;

@end

@implementation BRLinkLabel

@dynamic displayString;

- (void)initialProperties
{
    self.textColor = [NSColor blueColor];
    self.linkString = @"";
    self.mouseIn = NO;
    
    self.showBackground = NO;
    self.backgroundColor = [NSColor lightGrayColor];
}

- (instancetype)initWithFrame:(NSRect)frameRect attibutedString:(NSAttributedString *)displayString
{
    self = [super initWithFrame:frameRect];
    if (self) {
        [self initialProperties];
        [self setDisplayString:displayString];
        
        self.trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways owner:self userInfo:nil];
        [self addTrackingArea:self.trackingArea];
    }
    
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialProperties];
        
        self.trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways owner:self userInfo:nil];
        [self addTrackingArea:self.trackingArea];
    }
    
    return self;
}

- (void)awakeFromNib
{
}

- (void)setTextColor:(NSColor *)textColor
{
    if (_textColor != textColor) {
        _textColor = textColor;
    }
    [self setNeedsDisplay:YES];
}

- (void)setTextString:(NSString *)textString
{
    if (_textString != textString) {
        _textString = textString;
        [self setNeedsDisplay:YES];
    }
}

- (void)setMouseIn:(BOOL)mouseIn
{
    if (_mouseIn != mouseIn) {
        _mouseIn = mouseIn;
        [self setNeedsDisplay:YES];
    }
}

- (NSAttributedString *)displayString
{
    NSAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:self.textString attributes:@{ NSLinkAttributeName: self.linkString, NSFontAttributeName: [NSFont systemFontOfSize:BRStringFont], NSUnderlineStyleAttributeName: @(self.mouseIn), NSForegroundColorAttributeName: self.textColor }];
    
    return attString;
}

- (void)setDisplayString:(NSAttributedString *)displayString
{
    NSDictionary *dicAttibutes = [displayString attributesAtIndex:0 effectiveRange:NULL];
    self.textString = displayString.string;
    for (NSString *key in dicAttibutes.allKeys) {
        if ([key isEqualToString:NSForegroundColorAttributeName]) {
            self.textColor = dicAttibutes[NSForegroundColorAttributeName];
        } else if ([key isEqualToString:NSLinkAttributeName]) {
            id value = dicAttibutes[NSLinkAttributeName];
            if ([value isKindOfClass:[NSString class]]) {
                self.linkString = dicAttibutes[NSLinkAttributeName];
            } else {
                self.linkString = [dicAttibutes[NSLinkAttributeName] stringValue];
            }
        }
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    if (self.showBackground) {
        [self.backgroundColor setFill];
        NSRectFill(self.bounds);
    }
    
    [self.displayString drawAtPoint:NSMakePoint((NSWidth(self.bounds) - self.displayString.size.width) / 2, (NSHeight(self.bounds) - self.displayString.size.height) / 2)];
}

- (void)updateTrackingAreas
{
    if (self.trackingArea) {
        [self removeTrackingArea:self.trackingArea];
        self.trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways owner:self userInfo:nil];
        [self addTrackingArea:self.trackingArea];
    }
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    self.mouseIn = YES;
}

- (void)mouseExited:(NSEvent *)theEvent
{
    self.mouseIn = NO;
}

- (void)mouseDown:(NSEvent *)theEvent
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:self.linkString]];
}

- (void)mouseUp:(NSEvent *)theEvent
{
}

@end
