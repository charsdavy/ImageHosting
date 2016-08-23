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

@interface IHPreferencesAccountsViewController ()

@property (weak) IBOutlet NSTextField *akTextField;
@property (weak) IBOutlet NSSecureTextField *skTextField;
@property (weak) IBOutlet NSTextField *bucketNameTextField;

@end

@implementation IHPreferencesAccountsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do view setup here.
    [self fillCurrentAccount];
}

- (void)fillCurrentAccount
{
    IHAccount *currentAccount = [[IHAccountManager sharedManager] currentAccount];
    if (currentAccount && currentAccount.accountType != IHAccountTypeNone) {
        _akTextField.stringValue = currentAccount.ak;
        _skTextField.stringValue = currentAccount.sk;
        _bucketNameTextField.stringValue = currentAccount.bucketName;
    }
}

- (IBAction)clickedSubmit:(id)sender
{
    IHAccount *account = [[IHAccount alloc] init];
    account.accountType = IHAccountTypeQiniu;
    account.ak = _akTextField.stringValue;
    account.sk = _skTextField.stringValue;
    account.bucketName = _bucketNameTextField.stringValue;
    
    BOOL success = [[IHAccountManager sharedManager] archiveAccount:account];
    if (success) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"" defaultButton:@"Okay" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Config Account Info Success ! Please continue another operation "];
        [alert runModal];
    } else {
        NSAlert *alert = [NSAlert alertWithMessageText:@"" defaultButton:@"Okay" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Config Account Info Failed ! Please again "];
        [alert runModal];
        [self clearAccountViewContent];
    }
}

- (void)clearAccountViewContent
{
    _akTextField.stringValue = @"";
    _skTextField.stringValue = @"";
    _bucketNameTextField.stringValue = @"";
}

@end
