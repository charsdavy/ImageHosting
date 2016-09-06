//
//  IHDragTableView.m
//  ImageHosting
//
//  Created by chars on 16/9/6.
//  Copyright © 2016年 chars. All rights reserved.
//

#import "IHDragTableView.h"

@interface IHDragTableView ()<NSDraggingDestination>

@end

@implementation IHDragTableView

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

#pragma mark - NSDraggingDestination Protocol

- (NSDragOperation)draggingUpdated:(id <NSDraggingInfo>)sender
{
    NSPasteboard *pasteBoard = nil;
    NSDragOperation sourceDragMask;
    
    sourceDragMask = [sender draggingSourceOperationMask];
    pasteBoard = [sender draggingPasteboard];
    
    NSLog(@"%s drag operation updated",__FUNCTION__);
    
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
    NSLog(@"%s drag operation finished", __FUNCTION__);
}

- (BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender
{
    return YES;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender
{
    NSPasteboard *pasteBoard = [sender draggingPasteboard];
    
    NSLog(@"%s drag now", __FUNCTION__);
    if ([[pasteBoard types] containsObject:NSFilenamesPboardType]) {
        NSArray *files = [pasteBoard propertyListForType:NSFilenamesPboardType];
        NSUInteger numberOfFiles = files.count;
        if (numberOfFiles > 0) {
            for (NSString *filePath in files) {
                if ([_dragDelegate respondsToSelector:@selector(didFinishedDragWithFile:)]) {
                    [_dragDelegate didFinishedDragWithFile:filePath];
                }
            }
            return YES;
        } else {
            NSLog(@"%s not drag file", __FUNCTION__);
        }
    } else {
        NSLog(@"%s pasteBoard types(%@) not register",__FUNCTION__, [pasteBoard types]);
    }
    return YES;
}

@end
