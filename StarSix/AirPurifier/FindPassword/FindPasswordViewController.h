//
//  FindPasswordViewController.h
//  AirPurifier
//
//  Created by bluE on 14-8-13.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBBaseViewController.h"
@interface FindPasswordViewController : YBBaseViewController

- (IBAction)onBackLogin:(id)sender;
@property (weak, nonatomic) IBOutlet UINavigationBar *headNavigationBar;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtIdentifyNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtNewPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtNewPassword2;
- (IBAction)onGetIdentifier:(id)sender;
- (IBAction)onSendIdentifier:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnGetIdentifier;
@property (weak, nonatomic) IBOutlet UITextField *txtSecond;
@property (weak, nonatomic) IBOutlet UIButton *btnSendIdentifier;
@property (weak, nonatomic) IBOutlet UIButton *btnComplete;

@property (strong,nonatomic) NSString *strPhoneNumber;

- (IBAction)onComplete:(id)sender;

@end
