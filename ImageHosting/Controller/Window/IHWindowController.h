//
//  IHWindowController.h
//  ImageHosting
//
//  Created by chars on 16/8/16.
//  Copyright © 2016年 chars. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef void(^IHWindowControllerCompletionHandler)(void);

@interface IHWindowController : NSWindowController

@property (nonatomic, copy) IHWindowControllerCompletionHandler completionHandler;

- (void)showWithCompletionHandler:(IHWindowControllerCompletionHandler)handler;

@end

