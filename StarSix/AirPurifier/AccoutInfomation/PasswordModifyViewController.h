//
//  PasswordModifyViewController.h
//  AirPurifier
//
//  Created by bluE on 14-8-15.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelUser.h"
#import "YBBaseViewController.h"
@interface PasswordModifyViewController : YBBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *txtOldPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtNewPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;

- (IBAction)back:(id)sender;

- (IBAction)onPassword:(id)sender;

@property (nonatomic,strong) ModelUser *model;

@end
