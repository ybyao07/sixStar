//
//  AccountManageViewController.h
//  AirPurifier
//
//  Created by bluE on 14-8-15.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertBox.h"
#import "ModelUser.h"
#import "YBBaseViewController.h"
@interface AccountManageViewController : YBBaseViewController <UITableViewDataSource,UITableViewDelegate,AlertBoxDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imgUser;

@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtMail;

@property (weak, nonatomic) IBOutlet UITableView *settingTableView;


@property (weak, nonatomic) IBOutlet UIView *tapView;

@property (copy,nonatomic) NSArray *listSettings;
- (IBAction)back:(id)sender;

@property (nonatomic,strong) ModelUser *model;

@end
