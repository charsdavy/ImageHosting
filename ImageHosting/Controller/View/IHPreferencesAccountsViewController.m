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
        NSString *title = @"Configure Success";
        NSString *msg = @"Config Account Info Success ! Please continue another operation ";
        [self showAlertTitle:title message:msg style:IHAlertStyleInformational];
    } else {
        NSString *title = @"Configure Failed";
        NSString *msg = @"Config Account Info Failed ! Please again ";
        [self showAlertTitle:title message:msg style:IHAlertStyleWarning];
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

- (void)showAlertTitle:(NSString *)title message:(NSString *)message style:(IHAlertStyle)style
{
    NSAlertStyle alertStyle = NSInformationalAlertStyle;
    if (style == IHAlertStyleWarning) {
        alertStyle = NSWarningAlertStyle;
    } else if (style == IHAlertStyleCritical) {
        alertStyle = NSCriticalAlertStyle;
    } else if (style == IHAlertStyleInformational) {
        alertStyle = NSInformationalAlertStyle;
    } else {
        alertStyle = NSInformationalAlertStyle;
    }
    
    NSAlert *alert = [NSAlert alertWithMessageText:title defaultButton:@"Okay" alternateButton:nil otherButton:nil informativeTextWithFormat:@"%@", message];
    alert.alertStyle = alertStyle;
    [alert beginSheetModalForWindow:self.preferencesWindow completionHandler:nil];
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
