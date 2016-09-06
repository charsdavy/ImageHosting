//
//  IHDragTableView.h
//  ImageHosting
//
//  Created by chars on 16/9/6.
//  Copyright © 2016年 chars. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol IHDragFileDelegate <NSObject>

@optional
- (void)didFinishedDragWithFile:(NSString *)path;

@end

@interface IHDragTableView : NSTableView

@property (weak) id<IHDragFileDelegate> dragDelegate;

@end
