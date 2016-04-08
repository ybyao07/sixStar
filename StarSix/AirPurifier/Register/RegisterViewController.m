//
//  RegisterViewController.m
//  AirPurifier
//
//  Created by bluE on 14-8-13.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import "RegisterViewController.h"
#import <QuartzCore/CATransaction.h>
#import "AirPurifierAppDelegate.h"
#import "AlertBox.h"
#import "AFNetworking.h"
#import "Identifier.h"
#import "UserLoginedInfo.h"
#import <SMS_SDK/SMS_SDK.h>
#import "DeviceAddViewController.h"
#import "UIColor+Utility.h"
#import "Identifier.h"
#import "SkywareUserManagement.h"
#import "AirPurifierViewController.h"
#import "UserLoginedInfo.h"

#define SECONDS 60
#define GETCODEAGAGIN @"重新获取验证码"

@interface RegisterViewController ()
{
    NSString *strPhoneNumber;
    NSString *strPassword;
    NSTimer *timer;
    NSMutableArray* _areaArray;
    NSArray *views;
}
@property (weak, nonatomic) IBOutlet UIButton *roundBtnGetCode;
@property (weak, nonatomic) IBOutlet UIButton *roundBtnSeconds;

@property (weak, nonatomic) IBOutlet UIButton *roundBtnComplete;
@property (weak, nonatomic) IBOutlet UIButton *roundBtnComplete2;


@end

@implementation RegisterViewController
@synthesize txtSecond;

- (void)viewDidLoad
{
    views= [[NSBundle mainBundle] loadNibNamed:@"RegisterViewController" owner:self options:nil];
    [super viewDidLoad];
    _roundBtnGetCode.layer.cornerRadius = 4;
    _roundBtnSeconds.layer.cornerRadius = 2;
    _roundBtnComplete.layer.cornerRadius = 4;
    _roundBtnComplete2.layer.cornerRadius = 4;
    
    [self createViews];
    [self initNavView];
     MainDelegate.isFromRegister= YES;
    [NotificationCenter addObserver:self
                           selector:@selector(acceptAgreementOnAgreePage)
                               name:AgreeUserAgreementNotification
                             object:nil];
    _areaArray=[NSMutableArray array];
    //获取支持的地区列表
    [SMS_SDK getZone:^(enum SMS_ResponseState state, NSArray *array) {
        if (1==state)
        {
            NSLog(@"block 获取区号成功");
            _areaArray=[NSMutableArray arrayWithArray:array];
        }
        else if (0==state)
        {
            NSLog(@"block 获取区号失败");
        }
    }];
}

- (void)acceptAgreementOnAgreePage
{
    _btnAgreement.selected = YES;
}

-(void)initNavView
{
    [self addBarItemTitle:@"快速注册"];
    [self addBarBackButtonItemWithImageName:@"back_normal" selImageName:@"back_pressed" action:@selector(onBack:)];
}
-(void)createViews
{
    self.txtStep1.enabled = NO;
    self.txtStep2.enabled = NO;
    self.txtStep3.enabled = NO;
    self.txtSecond.enabled = NO;
    _lblUserAgreement.shouldUnderline = YES;
    _btnAgreement.selected = YES;
}
#pragma-mark 第一步----获取验证码
- (IBAction)onGetIdentifier:(id)sender {
    [self.txtPhoneNumber resignFirstResponder];
    if (![MainDelegate isNetworkAvailable]) {
        return;
    }
    strPhoneNumber = _txtPhoneNumber.text;
    if ([_txtPhoneNumber.text length] == 0) {
        [AlertBox showWithMessage:Localized(@"帐号不能为空")];
        return;
    }
    else if(![MainDelegate isMobileNumber:_txtPhoneNumber.text])
    {
        [AlertBox showWithMessage:Localized(@"请正确填写手机号码")];
        return;
    }
//    if(!_btnAgreement.selected)
//    {
//        [AlertBox showWithMessage:Localized(@"请确认您已经阅读了<<用户协议>>")];
//        return;
//    }
    //验证手机是否已经注册过，注册过则不能再注册
    else{
        [SkywareUserManagement UserVerifyLoginIdExistsWithLoginid:strPhoneNumber Success:^(SkywareResult *result) {
            //message = 200 找到 = 已经注册过
            [SVProgressHUD dismiss];
            if ([result.message isEqualToString:@"200"]) {
                [AlertBox showWithMessage:@"手机号码已被注册"];
            }
         } failure:^(SkywareResult *result) {
            [SVProgressHUD showSuccessWithStatus:@"验证码已发送"];
            [SMS_SDK getVerifyCodeByPhoneNumber:strPhoneNumber AndZone:@"86" result:^(enum SMS_GetVerifyCodeResponseState state) {
                if (1==state) {
                    NSLog(@"block 获取验证码成功");
                    self.txtStep1.textColor = [UIColor lightGrayColor];
                    self.txtStep2.textColor = kTextColor;
                    txtSecond.text = [NSString stringWithFormat:@"%d", SECONDS];
                    self.lblPhone.text =strPhoneNumber;
                    //多线程启动定时器
                    [NSThread detachNewThreadSelector:@selector(startTimerReg) toTarget:self withObject:nil];
                    //移除所有子控件
                    for (UIView *subview in [self.inputPhonenumberView subviews]) {
                        [subview removeFromSuperview];
                    }
                    for (UIView *view in views) {
                        if (view.tag == 2) {
                            view.frame = CGRectMake(0, 0, kScreenW, kScreenH-CGRectGetMaxY(self.titleVIew.frame));
                            [UIView animateWithDuration:1.0 animations:^{
                                [self.inputPhonenumberView addSubview:view];
                            }];
                        }
                    }
                }
                else if(0==state)
                {
                    NSLog(@"block 获取验证码失败");
                    NSString* str=[NSString stringWithFormat:@"验证码发送失败 请稍后重试"];
                    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"发送失败" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
                else if (SMS_ResponseStateMaxVerifyCode==state)
                {
                    NSString* str=[NSString stringWithFormat:@"请求验证码超上限 请稍后重试"];
                    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"超过上限" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
                else if(SMS_ResponseStateGetVerifyCodeTooOften==state)
                {
                    NSString* str=[NSString stringWithFormat:@"客户端请求发送短信验证过于频繁"];
                    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }];
        }];
    }
}




- (void)startTimerReg
 {
     timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFiredReg) userInfo:nil repeats:YES];
     [timer setFireDate:[NSDate distantPast]];
    [[NSRunLoop currentRunLoop] run];
}

-(void)timerFiredReg
{
    int i = [txtSecond.text intValue];
    i--;
    txtSecond.text=[NSString stringWithFormat:@"%d", i];    
    if (i==0) {
        txtSecond.text = GETCODEAGAGIN;
        //结束定时器
        [timer invalidate];
    }
}
- (IBAction)onUserAgreement:(id)sender {
    
}

- (IBAction)onAgreement:(id)sender {
    _btnAgreement.selected = !_btnAgreement.selected;
}


#pragma mark 第二步---重新获取验证码
- (IBAction)getIndentifierAgain:(id)sender {
    [self.txtIdentifierCode resignFirstResponder];
    if ([txtSecond.text isEqualToString:GETCODEAGAGIN]) {
        txtSecond.text =  [NSString stringWithFormat:@"%d", SECONDS];
        //开启定时器
        [self startTimerReg];
        //重新获取验证码
        [Identifier getCodeAgain:strPhoneNumber onView:self.view];
    }
}

- (IBAction)onGotoSettingPassword:(id)sender {
    [self.txtIdentifierCode resignFirstResponder];
    [self  submit:sender];
}

-(void)submit:(id)sender
{
    if(self.txtIdentifierCode.text.length!=4)
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码格式错误,请重新填写" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        [MainDelegate showProgressHubInView:self.view];
        [SMS_SDK commitVerifyCode:self.txtIdentifierCode.text result:^(enum SMS_ResponseState state) {
            [MainDelegate hiddenProgressHubInView:self.view];
            if (SMS_ResponseStateSuccess ==state) {
                
                [timer invalidate];
                NSLog(@"block 验证成功");
                self.txtStep2.textColor = [UIColor lightGrayColor];
                self.txtStep3.textColor = kTextColor;
                //移除所有子控件
                for (UIView *subview in [self.inputPhonenumberView subviews]) {
                    [subview removeFromSuperview];
                }
                
                _settingPasswordView.frame = CGRectMake(0, 0, kScreenW, kScreenH-CGRectGetMaxY(self.titleVIew.frame));
                [UIView animateWithDuration:1.0f animations:^{
                    [self.inputPhonenumberView addSubview:_settingPasswordView];
                }];
                for (UIView *view in views) {
                    if (view.tag == 3) {
                        view.frame = CGRectMake(0, 0, kScreenW, kScreenH-CGRectGetMaxY(self.titleVIew.frame));
                        [UIView animateWithDuration:1.0f animations:^{
                            [self.inputPhonenumberView addSubview:view];
                        }];
                    }
                }
            }
            else if(SMS_ResponseStateFail ==state)
            {
                NSLog(@"block 验证失败");
                NSString *errorInfo = Localized(@"发送验证码有误");
                [AlertBox showWithMessage:errorInfo];
            }
        }];
    }
}


#pragma mark 第三步设置密码
- (IBAction)onComplete:(id)sender {
    strPassword = _txtPassword.text;
    if ([strPassword length]>16 || [strPassword length]<6)
    {
        [AlertBox showWithMessage:Localized(@"密码不符合要求")];
        return;
    }
    NSString *regex = @"^[A-Za-z0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![predicate evaluateWithObject:strPassword])
    {
        [AlertBox showWithMessage:Localized(@"密码由字母或数字组成，不能包含其他符号")];
        return;
    }
    if(_confirmPassword.text.length == 0)
    {
        [AlertBox showWithMessage:Localized(@"请输入确认密码")];
        return;
    }
    if(![strPassword isEqualToString:_confirmPassword.text])
    {
        [AlertBox showWithMessage:Localized(@"两次输入密码不一致")];
        return;
    }
    else{
        if(![MainDelegate isNetworkAvailable])return;
        [self startRegister:0];
    }
}

- (void)startRegister:(NSInteger)requestCount
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:strPhoneNumber forKey:@"login_id"];
    [param setObject:strPassword forKey:@"login_pwd"];
    [SVProgressHUD show];
    [SkywareUserManagement UserRegisterWithParamesers:param Success:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
        if ([result.message intValue] == 200) {
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
            [SkywareUserManagement UserLoginWithParamesers:param Success:^(SkywareResult *result) {
                if ([result.message intValue] == 200) {
                    MainDelegate.loginedInfo =[[UserLoginedInfo alloc] initWithDeviceToken:result.token withUserDic:@{@"login_id":strPhoneNumber,@"login_pwd":strPassword}];
                    SkywareInstanceModel *instance = [SkywareInstanceModel sharedSkywareInstanceModel];
                    instance.token = result.token;
                    MainDelegate.isFromWifi= NO;
                    NSString *newName;
                    if (IS_IPHONE_5_OR_LESS ) {
                        newName = @"AirPurifierViewController";
                    }else{
                        newName = @"AirPurifierViewController6";
                    }
                    AirPurifierViewController *mainView = [[AirPurifierViewController alloc] initWithNibName:newName bundle:nil];
                    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mainView];
                    navController.navigationBarHidden = YES;
                    MainDelegate.window.rootViewController = navController;
                    [MainDelegate reloadInputViews];
                }
            } failure:^(SkywareResult *result) {
                NSLog(@"the status is %@",result.status);
            }];
        }
    } failure:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
    }];
}

- (void)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
