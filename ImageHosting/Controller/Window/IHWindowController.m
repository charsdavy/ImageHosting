//
//  IHWindowController.m
//  ImageHosting
//
//  Created by chars on 16/8/16.
//  Copyright © 2016年 chars. All rights reserved.
//

#import "IHWindowController.h"

@interface IHWindowController ()

@end

@implementation IHWindowController

- (void)showWithCompletionHandler:(IHWindowControllerCompletionHandler)handler {
}

- (void)windowWillClose:(NSNotification *)notification {
    self.completionHandler ? self.completionHandler() : nil;
}

@end
