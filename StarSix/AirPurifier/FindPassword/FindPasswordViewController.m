//
//  FindPasswordViewController.m
//  AirPurifier
//
//  Created by bluE on 14-8-13.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import "FindPasswordViewController.h"
#import "Identifier.h"
#import "AlertBox.h"
#import "AirPurifierAppDelegate.h"
#import "UserLoginedInfo.h"
#import "Identifier.h"
#import "SkywareUserManagement.h"
#import <SMS_SDK/SMS_SDK.h>

#define GETCODEAGAGIN @"重新获取"
#define SECONDS 60

@interface FindPasswordViewController ()
{
}
@end
@implementation FindPasswordViewController
@synthesize strPhoneNumber;

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self.headNavigationBar setBackgroundImage:[UIImage imageNamed:@"view_settingheader.png"] forBarMetrics:UIBarMetricsDefault];
    [self initNavView];
    _txtPhoneNumber.text = strPhoneNumber;
    _txtSecond.enabled = NO;
    _txtIdentifyNumber.enabled = NO;
    _btnSendIdentifier.enabled = NO;
    _txtNewPassword.enabled = NO;
    _txtNewPassword2.enabled = NO;
    _btnComplete.layer.cornerRadius = 4;
    _btnComplete.enabled = NO;
}
-(void)initNavView
{
    [self addBarItemTitle:@"找回密码"];
     [self addBarBackButtonItemWithImageName:@"back_normal" selImageName:@"back_pressed" action:@selector(onBackLogin:)];
    
}
- (IBAction)onBackLogin:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onGetIdentifier:(id)sender {
    strPhoneNumber = _txtPhoneNumber.text;
    if(![MainDelegate isNetworkAvailable])return;
    if ([_txtPhoneNumber.text length] == 0) {
        [AlertBox showWithMessage:Localized(@"帐号不能为空")];
        return;
    }
    else if(![MainDelegate isMobileNumber:_txtPhoneNumber.text])
    {
        [AlertBox showWithMessage:Localized(@"请输入正确的手机号码格式")];
        return;
    }

    [SkywareUserManagement UserVerifyLoginIdExistsWithLoginid:strPhoneNumber Success:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
        if ([result.message isEqualToString:@"200"]) {//用户存在
            [Identifier getCodeAgain:strPhoneNumber onView:self.view];
            _btnSendIdentifier.enabled = YES;
            _txtIdentifyNumber.enabled = YES;
            [_txtIdentifyNumber becomeFirstResponder];
        }
    } failure:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
        [AlertBox showWithMessage:@"此账号还未注册"];
    }];
   
    __block int timeout = 60;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if (timeout <= 0) {//倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //刷新页面
                _txtSecond.text = GETCODEAGAGIN;
                _btnGetIdentifier.enabled = YES;
            });
        }
        else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%d秒",seconds==0?60:seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                _txtSecond.text = strTime;
                _btnGetIdentifier.enabled = NO;
            });
            timeout --;
        };
    });
    dispatch_resume(_timer);
    
}

- (IBAction)onSendIdentifier:(id)sender {
    [self.txtIdentifyNumber resignFirstResponder];
    
    [MainDelegate showProgressHubInView:self.view];
    if(self.txtIdentifyNumber.text.length!=4)
    {
        [MainDelegate hiddenProgressHubInView:self.view];
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码格式错误,请重新填写" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        NSLog(@"去服务端进行验证中...");
        [SMS_SDK commitVerifyCode:self.txtIdentifyNumber.text result:^(enum SMS_ResponseState state) {
            [MainDelegate hiddenProgressHubInView:self.view];
            if (1==state) {
                NSString *succeed = Localized(@"验证成功");
                [AlertBox showWithMessage:succeed];
                _btnSendIdentifier.enabled = NO;
                _txtNewPassword.enabled = YES;
                _txtNewPassword2.enabled = YES;
                _btnComplete.enabled = YES;
            }
            else if(0==state)
            {
                NSLog(@"block 验证失败");
                NSString *errorInfo = Localized(@"发送验证码有误");
//                _txtSecond.text = GETCODEAGAGIN;
                [AlertBox showWithMessage:errorInfo];
            }
        }];
    }
}

- (IBAction)onComplete:(id)sender {
    if ([_txtNewPassword.text length] > 16 || [_txtNewPassword.text  length] < 6)
    {
        [AlertBox showWithMessage:Localized(@"密码不符合要求,请输入6~16位数字或字符")];
        return;
    }
    NSString *regex = @"^[A-Za-z0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![predicate evaluateWithObject:_txtNewPassword.text])
    {
        [AlertBox showWithMessage:Localized(@"密码由字母或数字组成，不能包含其他符号")];
        return;
    }
    if(_txtNewPassword2.text.length == 0)
    {
        [AlertBox showWithMessage:Localized(@"请输入确认密码")];
        return;
    }
    if(![_txtNewPassword.text isEqualToString:_txtNewPassword2.text])
    {
        [AlertBox showWithMessage:Localized(@"输入密码不一致")];
        return;
    }
    else{
        if(![MainDelegate isNetworkAvailable])return;
        [self startChangePwd];
    }
}

- (void)startChangePwd
{
    [SVProgressHUD show];
    [SkywareUserManagement UserVerifyLoginIdExistsWithLoginid:strPhoneNumber Success:^(SkywareResult *result) {
        if ([result.message intValue] == 200) {
            [SVProgressHUD dismiss];
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:strPhoneNumber forKey:@"login_id"];
            [param setObject:_txtNewPassword.text forKey:@"login_pwd"];
            [SkywareUserManagement UserRetrievePasswordWithParamesers:param Success:^(SkywareResult *result) {
                if ([result.message intValue] == 200) {
                    [AlertBox showWithMessage:@"修改密码成功"];
                    [NotificationCenter postNotificationName:@"PasswordChanged" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } failure:^(SkywareResult *result) {
                [AlertBox showWithMessage:@"修改失败"];
            }];
        }
    } failure:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
        [AlertBox showWithMessage:@"网络异常"];
    }];
}

#pragma mark-UITextFieldDelegate
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
