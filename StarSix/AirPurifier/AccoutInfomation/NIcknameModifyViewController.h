//
//  NIcknameModifyViewController.h
//  AirPurifier
//
//  Created by bluE on 14-8-15.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelUser.h"
#import "YBBaseViewController.h"
@interface NIcknameModifyViewController : YBBaseViewController

@property (weak, nonatomic) IBOutlet UINavigationBar *headNavigationBar;

@property (weak, nonatomic) IBOutlet UITextField *txtUserName;

- (IBAction)onModifyNickname:(id)sender;
- (IBAction)back:(id)sender;

@property (nonatomic,strong) ModelUser *model;


@end
