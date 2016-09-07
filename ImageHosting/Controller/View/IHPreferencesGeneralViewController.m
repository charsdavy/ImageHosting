//
//  IHPreferencesGeneralViewController.m
//  ImageHosting
//
//  Created by chars on 16/8/19.
//  Copyright © 2016年 chars. All rights reserved.
//

#import "IHPreferencesGeneralViewController.h"
#import "IHGeneralManager.h"
#import "IHGeneral.h"
#import "const.h"

@interface IHPreferencesGeneralViewController ()

@property (weak) IBOutlet NSButton *launch;
@property (weak) IBOutlet NSButton *systemNotification;

@end

@implementation IHPreferencesGeneralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self initSubViews];
}

- (void)initSubViews
{
    IHGeneral *general = [[IHGeneral alloc] init];
    general = [[IHGeneralManager sharedManager] unarchiveForKey:SYSTEM_NOTIFICATION_KEY];
    
    if ([general.launchStartUp isEqualToString:@"YES"]) {
        _launch.state = 1;
        [[IHGeneralManager sharedManager] startupAppWhenLogin:YES];
    } else {
        _launch.state = 0;
        [[IHGeneralManager sharedManager] startupAppWhenLogin:NO];
    }
    
    if ([general.userNotification isEqualToString:@"YES"]) {
        _systemNotification.state = 1;
    } else {
        _systemNotification.state = 0;
    }
}

- (IBAction)launchStartUp:(NSButton *)sender {
    IHLog(@"state:%zi", sender.state);
    NSString *launch = sender.state ? @"YES" : @"NO";
    
    if (sender.state) {
        [[IHGeneralManager sharedManager] startupAppWhenLogin:YES];
    } else {
        [[IHGeneralManager sharedManager] startupAppWhenLogin:NO];
    }
    
    IHGeneral *general = [[IHGeneral alloc] init];
    general = [[IHGeneralManager sharedManager] unarchiveForKey:SYSTEM_NOTIFICATION_KEY];
    general.launchStartUp = launch;
    
    [[IHGeneralManager sharedManager] archive:general key:SYSTEM_NOTIFICATION_KEY];
}

- (IBAction)systemNotification:(NSButton *)sender {
    IHLog(@"state:%zi", sender.state);
    NSString *noti = sender.state ? @"YES" : @"NO";
    IHGeneral *general = [[IHGeneral alloc] init];
    general = [[IHGeneralManager sharedManager] unarchiveForKey:SYSTEM_NOTIFICATION_KEY];
    general.userNotification = noti;
    
    [[IHGeneralManager sharedManager] archive:general key:SYSTEM_NOTIFICATION_KEY];
}

@end
