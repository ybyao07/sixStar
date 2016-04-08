//
//  LoginViewController.h
//  AirPurifier
//
//  Created by bluE on 14-8-13.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBBaseViewController.h"
@interface LoginViewController : YBBaseViewController <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *textName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *btnAutoLogin;


@property (weak, nonatomic) IBOutlet UIView *viewDraw;

@property (assign,nonatomic) BOOL isLogout;


- (IBAction)onLogin:(id)sender;
- (IBAction)onForgetPassword:(id)sender;

- (IBAction)onRegister:(id)sender;

@end
