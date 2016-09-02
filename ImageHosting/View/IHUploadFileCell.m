//
//  IHUploadFileCell.m
//  ImageHosting
//
//  Created by chars on 16/9/1.
//  Copyright © 2016年 chars. All rights reserved.
//

#import "IHUploadFileCell.h"
#import "IHProgressIndicator.h"

#define PERCENT_THROSHED              100

#define WIDTH                         380

#define TITLE_WIDTH                   300
#define TITLE_HEIGHT                  20

#define PROGRESS_BAR_INDICATOR_WIDTH  300
#define PROGRESS_BAR_INDICATOR_HEIGHT 3

#define IMAGE_WIDTH                   20
#define IMAGE_HEIGHT                  20

#define PROGRESS_INDICATOR_WIDTH      16
#define PROGRESS_INDICATOR_HEIGHT     16

@interface IHUploadFileCell ()

@property (strong) NSTextField *titleTextField;
@property (strong) IHProgressIndicator *progressBarIndicator;
@property (strong) NSImageView *hintImageView;
@property (strong) NSProgressIndicator *progressIndicator;

@end

@implementation IHUploadFileCell

- (void)awakeFromNib
{
    [self initSubViews];
}

- (void)initSubViews
{
    _progressBarIndicator = [[IHProgressIndicator alloc] initWithFrame:NSMakeRect(57, 5, PROGRESS_BAR_INDICATOR_WIDTH, PROGRESS_BAR_INDICATOR_HEIGHT)];
    _progressBarIndicator.style = NSProgressIndicatorBarStyle;
    _progressBarIndicator.indeterminate = NO;
    _progressBarIndicator.minValue = 0;
    _progressBarIndicator.maxValue = 100;
    [self addSubview:_progressBarIndicator];
    
    _titleTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(57, 8, TITLE_WIDTH, TITLE_HEIGHT)];
    _titleTextField.editable = NO;
    _titleTextField.lineBreakMode = NSLineBreakByTruncatingTail;
    _titleTextField.bordered = NO;
    _titleTextField.alignment = NSTextAlignmentLeft;
    _titleTextField.backgroundColor = [NSColor clearColor];
    _titleTextField.textColor = [NSColor darkGrayColor];
    [self addSubview:_titleTextField];
    
    _hintImageView = [[NSImageView alloc] initWithFrame:NSMakeRect(21, 8, IMAGE_WIDTH, IMAGE_HEIGHT)];
    _hintImageView.image = [NSImage imageNamed:@"success"];
    [self addSubview:_hintImageView];
    
    _progressIndicator = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect(23, 10, PROGRESS_INDICATOR_WIDTH, PROGRESS_INDICATOR_HEIGHT)];
    _progressIndicator.style = NSProgressIndicatorSpinningStyle;
    _progressIndicator.controlSize = NSRegularControlSize;
    _progressIndicator.displayedWhenStopped = NO;
    [self addSubview:_progressIndicator];
}

- (void)setTitle:(NSString *)title
{
    if (!title) {
        return;
    }
    
    if (_title != title) {
        _title = title;
    }
    
    self.titleTextField.stringValue = title;
}

- (void)setProgress:(NSString *)progress
{
    if (_progress != progress) {
        _progress = progress;
    }
    NSInteger percent = [progress integerValue];
    
    self.progressBarIndicator.percent = percent;
    
    if (percent < PERCENT_THROSHED && percent != 0) {
        [self.progressIndicator startAnimation:self];
    } else {
        [self.progressIndicator stopAnimation:self];
    }
}

- (void)setImage:(NSImage *)image
{
    if (_image != image) {
        _image = image;
    }
    
    self.hintImageView.image = image;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
    
    NSColor *lineColor = [NSColor grayColor];
    
    CGRect lineRect = CGRectMake(21, 0, WIDTH - 21 * 2, 1);
    CGContextSaveGState(ctx);
    CGContextSetFillColorWithColor(ctx, lineColor.CGColor);
    CGContextFillRect(ctx, lineRect);
    CGContextRestoreGState(ctx);
}

@end
