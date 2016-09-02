//
//  IHPreferencesFeedbackViewController.m
//  ImageHosting
//
//  Created by chars on 16/8/22.
//  Copyright © 2016年 chars. All rights reserved.
//

#import "IHPreferencesFeedbackViewController.h"
#import "BRLinkLabel.h"

#define FONT_FEED_BACK 14.0f

@interface IHPreferencesFeedbackViewController ()

@end

@implementation IHPreferencesFeedbackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do view setup here.

    [self emailLabel];
    [self githubLabel];
    [self weiboLabel];
    [self tiwtterLabel];
}

- (void)emailLabel
{
    NSString *title = @"chars.davy@gmail.com";
    CGSize size = [title sizeWithAttributes:@{ NSFontAttributeName: [NSFont systemFontOfSize:FONT_FEED_BACK] }];
    NSRect frame = NSMakeRect(144, 220, size.width, 20);
    NSString *email = @"mailto:chars.davy@gmail.com";;
    email = [email stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    BRLinkLabel *linkLabel = [self linkLabel:title link:email frame:frame];
    linkLabel.accessibilitySelected = YES;
    [self.view addSubview:linkLabel];
}

- (void)githubLabel
{
    NSString *title = @"@charsdavy";
    CGSize size = [title sizeWithAttributes:@{ NSFontAttributeName: [NSFont systemFontOfSize:FONT_FEED_BACK] }];
    NSRect frame = NSMakeRect(144, 167, size.width, 20);
    NSString *link = @"https://github.com/charsdavy";
    BRLinkLabel *linkLabel = [self linkLabel:title link:link frame:frame];
    [self.view addSubview:linkLabel];
}

- (void)weiboLabel
{
    NSString *title = @"@Chars-D";
    CGSize size = [title sizeWithAttributes:@{ NSFontAttributeName: [NSFont systemFontOfSize:FONT_FEED_BACK] }];
    NSRect frame = NSMakeRect(144, 115, size.width, 20);
    NSString *link = @"http://weibo.com/u/3875245858";
    BRLinkLabel *linkLabel = [self linkLabel:title link:link frame:frame];
    [self.view addSubview:linkLabel];
}

- (void)tiwtterLabel
{
    NSString *title = @"@charsdavy";
    CGSize size = [title sizeWithAttributes:@{ NSFontAttributeName: [NSFont systemFontOfSize:FONT_FEED_BACK] }];
    NSRect frame = NSMakeRect(144, 65, size.width, 20);
    NSString *link = @"https://twitter.com/charsdavy";
    BRLinkLabel *linkLabel = [self linkLabel:title link:link frame:frame];
    [self.view addSubview:linkLabel];
}

- (BRLinkLabel *)linkLabel:(NSString *)title link:(NSString *)link frame:(CGRect)frame
{
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{ NSLinkAttributeName:link, NSForegroundColorAttributeName: [NSColor colorWithRed:16 / 255.0 green:64 / 255.0 blue:251 / 255.0 alpha:1.0f] }];
    BRLinkLabel *linkLabel = [[BRLinkLabel alloc] initWithFrame:frame attibutedString:attString];
    linkLabel.showBackground = NO;
    return linkLabel;
}

@end
