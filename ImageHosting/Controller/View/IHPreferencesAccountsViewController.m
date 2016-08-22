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

- (void)viewDidLoad {
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

- (IBAction)clickedSubmit:(id)sender {
    IHAccount *account = [[IHAccount alloc] init];
    account.accountType = IHAccountTypeQiniu;
    account.ak = _akTextField.stringValue;
    account.sk = _skTextField.stringValue;
    account.bucketName = _bucketNameTextField.stringValue;
    
    BOOL success = [[IHAccountManager sharedManager] archiveAccount:account];
    if (!success) {
        NSLog(@"%s submit account faild!", __FUNCTION__);
    }
}

@end
