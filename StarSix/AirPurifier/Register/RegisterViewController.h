//
//  RegisterViewController.h
//  AirPurifier
//
//  Created by bluE on 14-8-13.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnderLineLabel.h"
#import "YBBaseViewController.h"
@interface RegisterViewController : YBBaseViewController
@property (weak, nonatomic) IBOutlet UITextField *txtStep1;
@property (weak, nonatomic) IBOutlet UITextField *txtStep2;
@property (weak, nonatomic) IBOutlet UITextField *txtStep3;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtIdentifierCode;

@property (weak, nonatomic) IBOutlet UIButton *btnAgreement;

@property (weak, nonatomic) IBOutlet UnderLineLabel *lblUserAgreement;

- (IBAction)onAgreement:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *titleVIew;

#pragma 注册第一步
@property (weak, nonatomic) IBOutlet UIView *inputPhonenumberView;

- (IBAction)onGetIdentifier:(id)sender;
- (IBAction)onUserAgreement:(id)sender;
#pragma 注册第二步

@property (weak, nonatomic) IBOutlet UILabel *lblPhone;

@property (weak, nonatomic) IBOutlet UIView *inputIdentifierView;
@property (weak, nonatomic) IBOutlet UITextField *txtSecond;
- (IBAction)onGotoSettingPassword:(id)sender;
#pragma 注册第三步
@property (weak, nonatomic) IBOutlet UIView *settingPasswordView;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnComplete;

- (IBAction)onComplete:(id)sender;
@end
