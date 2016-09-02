//
//  IHUploadFileCell.h
//  ImageHosting
//
//  Created by chars on 16/9/1.
//  Copyright © 2016年 chars. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IHUploadFileCell : NSTableCellView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, strong) NSImage *image;
@property (nonatomic, copy) NSString *progress;

@end
