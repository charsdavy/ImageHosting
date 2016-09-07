//
//  IHTableView.m
//  ImageHosting
//
//  Created by chars on 16/9/6.
//  Copyright © 2016年 chars. All rights reserved.
//

#import "IHTableView.h"
#import "NSColor+IHAddition.h"

@interface IHTableView ()<NSDraggingDestination, NSMenuDelegate>

@end

@implementation IHTableView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil]];
    }
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        [self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil]];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)dragAreaFadeIn
{
    self.backgroundColor = [NSColor ih_colorWithRGBString:@"#A26DCA"];
    [self setAlphaValue:0.2];
}

- (void)dragAreaFadeOut
{
    self.backgroundColor = [NSColor clearColor];
    [self setAlphaValue:1.0];
}

- (void)clearAllUpload:(NSMenuItem *)sender
{
    if ([_ihDelegate respondsToSelector:@selector(ihTableView:didClickedClearAllUpload:)]) {
        [_ihDelegate ihTableView:self didClickedClearAllUpload:sender];
    }
}

#pragma mark - Overwrite

- (void)rightMouseDown:(NSEvent *)theEvent
{
    NSMenu *popupMenu = [[NSMenu alloc] init];
    popupMenu.delegate = self;
    
    [popupMenu addItemWithTitle:@"Clear All Upload" action:@selector(clearAllUpload:) keyEquivalent:@"c"];
    
    [NSMenu popUpContextMenu:popupMenu withEvent:theEvent forView:self];
}

#pragma mark - NSDraggingDestination Protocol

- (NSDragOperation)draggingUpdated:(id <NSDraggingInfo>)sender
{
    NSPasteboard *pasteBoard = nil;
    NSDragOperation sourceDragMask;
    
    sourceDragMask = [sender draggingSourceOperationMask];
    pasteBoard = [sender draggingPasteboard];
    
    IHLog(@"drag operation updated");
    
    if ([[pasteBoard types] containsObject:NSFilenamesPboardType]) {
        if (sourceDragMask & NSDragOperationLink) {
            return NSDragOperationLink;
        } else if (sourceDragMask & NSDragOperationCopy) {
            return NSDragOperationCopy;
        }
    }
    return NSDragOperationNone;
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
    IHLog(@"drag operation entered");
    NSPasteboard *pasteBoard = nil;
    NSDragOperation sourceDragMask;
    
    sourceDragMask = [sender draggingSourceOperationMask];
    pasteBoard = [sender draggingPasteboard];
    
    [self dragAreaFadeIn];
    
    if ([[pasteBoard types] containsObject:NSFilenamesPboardType]) {
        if (sourceDragMask & NSDragOperationLink) {
            return NSDragOperationLink;
        } else if (sourceDragMask & NSDragOperationCopy) {
            return NSDragOperationCopy;
        }
    }
    return NSDragOperationNone;
}

- (void)draggingExited:(id<NSDraggingInfo>)sender
{
    IHLog(@"drag operation finished");
    [self dragAreaFadeOut];
}

- (void)draggingEnded:(nullable id <NSDraggingInfo>)sender
{
    IHLog(@"drag operation ended");
    [self dragAreaFadeOut];
}

- (BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender
{
    return YES;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender
{
    NSPasteboard *pasteBoard = [sender draggingPasteboard];
    
    IHLog(@"drag now");
    if ([[pasteBoard types] containsObject:NSFilenamesPboardType]) {
        NSArray *files = [pasteBoard propertyListForType:NSFilenamesPboardType];
        NSUInteger numberOfFiles = files.count;
        if (numberOfFiles > 0) {
            for (NSString *filePath in files) {
                if ([_ihDelegate respondsToSelector:@selector(ihTableView:didFinishedDragWithFile:)]) {
                    [_ihDelegate ihTableView:self didFinishedDragWithFile:filePath];
                }
            }
            return YES;
        } else {
            IHLog(@"not drag file");
        }
    } else {
        IHLog(@"pasteBoard types(%@) not register", [pasteBoard types]);
    }
    return YES;
}

@end
