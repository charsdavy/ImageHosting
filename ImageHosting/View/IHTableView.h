//
//  IHTableView.h
//  ImageHosting
//
//  Created by chars on 16/9/6.
//  Copyright © 2016年 chars. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class IHTableView;

@protocol IHTableViewDelegate <NSObject>

@optional
- (void)ihTableView:(IHTableView *)tableView didFinishedDragWithFile:(NSString *)path;
- (void)ihTableView:(IHTableView *)tableView didClickedClearAllUpload:(NSMenuItem *)item;

@end

@interface IHTableView : NSTableView

@property (weak) id<IHTableViewDelegate> ihDelegate;

@end
