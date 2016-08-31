//
//  BRLinkLabel.h
//  BRLinkLabel
//
//  Created by Yang on 16/2/29.
//  Copyright © 2016年 sgyang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

IB_DESIGNABLE
@interface BRLinkLabel : NSView

- (instancetype)initWithFrame:(NSRect)frameRect attibutedString:(NSAttributedString *)displayString;
//也可以用- (instancetype)initWithFrame:(NSRect)frameRect来创建

@property (nonatomic, copy) NSAttributedString *displayString;

//方便直接设置attibute
@property (nonatomic, copy) IBInspectable NSString *textString;
@property (nonatomic, copy) IBInspectable NSString *linkString;
@property (nonatomic, retain) IBInspectable NSColor *textColor;

//背景相关
@property (nonatomic) BOOL IBInspectable showBackground;
@property (nonatomic, retain) IBInspectable NSColor *backgroundColor;

@end