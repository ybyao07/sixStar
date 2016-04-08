//
//  PasswordModifyViewController.m
//  AirPurifier
//
//  Created by bluE on 14-8-15.
//  Copyright (c) 2014年 skyware. All rights reserved.
//
/**
 *
 *如果用联合账号登陆的话，不允许修改密码，只有普通方式登陆才可以修改密码
 **/

#import "PasswordModifyViewController.h"
#import "AirPurifierAppDelegate.h"
#import "AlertBox.h"
#import "SkywareUserManagement.h"
#import "UserLoginedInfo.h"

@interface PasswordModifyViewController ()<UITextFieldDelegate>
{
    NSString *oldPassword;
    NSString *newPassword;
    NSString *newPasswordConfirm;
}
@property (weak, nonatomic) IBOutlet UIButton *roundBtnSure;

@end

@implementation PasswordModifyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _roundBtnSure.layer.cornerRadius = 4;
    [self initNavView];
}
-(void)initNavView
{
    [self addBarItemTitle:@"修改密码"];
    [self addBarBackButtonItemWithImageName:@"back_normal" selImageName:@"back_press" action:@selector(back:)];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onPassword:(id)sender {
    [_txtOldPassword resignFirstResponder];
    [_txtNewPassword resignFirstResponder];
    [_txtConfirmPassword resignFirstResponder];
    oldPassword = _txtOldPassword.text;
    newPassword = _txtNewPassword.text;
    newPasswordConfirm = _txtConfirmPassword.text;
    if (oldPassword.length == 0) {
        [AlertBox showWithMessage:Localized(@"输入不能为空")];
        return;
    }
    if (oldPassword.length>16 || oldPassword.length<6) {
        [AlertBox showWithMessage:Localized(@"旧密码格式不正确")];
        return;
    }
    
    if ([newPassword length]>16 || [newPassword  length]<6)
    {
        [AlertBox showWithMessage:Localized(@"密码不符合要求")];
        return;
    }
    NSString *regex = @"^[A-Za-z0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![predicate evaluateWithObject:newPassword])
    {
        [AlertBox showWithMessage:Localized(@"密码由字母或数字组成，不能包含其他符号")];
        return;
    }
    if(newPasswordConfirm.length == 0)
    {
        [AlertBox showWithMessage:Localized(@"请输入确认密码")];
        return;
    }
    if(![newPassword isEqualToString:newPasswordConfirm])
    {
        [AlertBox showWithMessage:Localized(@"输入密码不一致")];
        return;
    }
    [self changePassword:newPassword];
}

-(void)changePassword:(NSString *)password
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:newPassword forKey:@"login_pwd"];
    [param setObject:oldPassword forKey:@"login_pwd_old"];
    [SkywareUserManagement UserEditUserPasswordWithParamesers:param Success:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
        if ([result.message intValue] == 200) {
            [AlertBox showWithMessage:@"修改密码成功"];
            //刷新账号管理界面
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
        if ([result.message intValue] == 404) {
            [AlertBox showWithMessage:@"旧密码不正确"];
        }else{
            [AlertBox showWithMessage:@"服务器请求失败"];
        }
    }];
}


#pragma mark- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}



@end
