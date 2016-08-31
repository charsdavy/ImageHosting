//
//  IHPreferencesAccountsViewController.m
//  ImageHosting
//
//  Created by chars on 16/8/19.
//  Copyright © 2016年 chars. All rights reserved.
//

#import "IHPreferencesAccountsViewController.h"
#import "IHAccountManager.h"
#import "IHAccount.h"
#import "const.h"

@interface IHPreferencesAccountsViewController ()

@property (weak) IBOutlet NSTextField *akTextField;
@property (weak) IBOutlet NSSecureTextField *skTextField;
@property (weak) IBOutlet NSTextField *bucketNameTextField;
@property (weak) IBOutlet NSButton *east;
@property (weak) IBOutlet NSButton *north;
@property (copy) NSString *region;

@end

@implementation IHPreferencesAccountsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do view setup here.
    _region = REGION_EAST_CHINA;
    [self fillCurrentAccount];
}

- (void)fillCurrentAccount
{
    IHAccount *currentAccount = [[IHAccountManager sharedManager] currentAccount];
    if (currentAccount && currentAccount.accountType != IHAccountTypeNone) {
        _akTextField.stringValue = currentAccount.ak;
        _skTextField.stringValue = currentAccount.sk;
        _bucketNameTextField.stringValue = currentAccount.bucketName;
        if ([currentAccount.region isEqualToString:REGION_EAST_CHINA]) {
            _east.state = 1;
            _north.state = 0;
        } else if ([currentAccount.region isEqualToString:REGION_NORTH_CHINA]) {
            _east.state = 0;
            _north.state = 1;
        }
    } else {
        _east.state = 1;
        _north.state = 0;
    }
}

- (IBAction)clickedSubmit:(id)sender
{
    IHAccount *account = [[IHAccount alloc] init];
    account.accountType = IHAccountTypeQiniu;
    account.ak = _akTextField.stringValue;
    account.sk = _skTextField.stringValue;
    account.bucketName = _bucketNameTextField.stringValue;
    account.region = self.region;
    
    BOOL success = [[IHAccountManager sharedManager] archiveAccount:account];
    if (success) {
        NSString *info = @"Config Account Info Success ! Please continue another operation ";
        NSAlert *alert = [NSAlert alertWithMessageText:@"Configure Success" defaultButton:@"Okay" alternateButton:nil otherButton:nil informativeTextWithFormat:@"%@", info];
        alert.alertStyle = NSInformationalAlertStyle;
        [alert beginSheetModalForWindow:self.preferencesWindow completionHandler:nil];
    } else {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Configure Failed" defaultButton:@"Okay" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Config Account Info Failed ! Please again "];
        alert.alertStyle = NSWarningAlertStyle;
        [alert beginSheetModalForWindow:self.preferencesWindow completionHandler:nil];
        [self clearAccountViewContent];
    }
}

- (IBAction)clickedRegion:(NSButton *)sender {
    if (sender.tag == 1) {
        self.region = REGION_EAST_CHINA;
    } else if (sender.tag == 0) {
        self.region = REGION_NORTH_CHINA;
    }
}

- (void)clearAccountViewContent
{
    _akTextField.stringValue = @"";
    _skTextField.stringValue = @"";
    _bucketNameTextField.stringValue = @"";
    _east.state = 1;
    _north.state = 0;
}

@end
