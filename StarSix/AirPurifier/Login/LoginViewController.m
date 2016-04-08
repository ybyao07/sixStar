//
//  LoginViewController.m
//  AirPurifier
//
//  Created by bluE on 14-8-13.
//  Copyright (c) 2014年 skyware. All rights reserved.
//
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "AlertBox.h"
#import "AirPurifierAppDelegate.h"
#import "FindPasswordViewController.h"
#import "AirPurifierViewController.h"
#import "DrawerView.h"
#import "CitySelectedViewController.h"
#import "UserLoginedInfo.h"
#import "JSON.h"
#import "SkywareUserManagement.h"
#import "JSONKit.h"
#import "UIView+Toast.h"

#define QQ @"QQ"
#define SinaWeibo @"SinaWeibo"
@interface LoginViewController ()
{
    UIButton *btnQQ;
    UIButton *btnWeibo;
    int loginType;
}
@property (weak, nonatomic) IBOutlet UIButton *roundBtnLogin;

@end

@implementation LoginViewController
@synthesize textName;
@synthesize password;


- (void)viewDidLoad
{
    [super viewDidLoad];
    _roundBtnLogin.layer.cornerRadius = 4;
    self.navBar.hidden = YES;
    self.textName.delegate = self;
    self.password.delegate = self;
    
    NSDictionary *loginInfo = [UserDefault objectForKey:LoginInfo];
    [NotificationCenter addObserver:self selector:@selector(clearPassword) name:@"PasswordChanged" object:nil];
    if (_isLogout) { //注销之后，进入
        textName.text = loginInfo[LoginUserName];
        password.text = loginInfo[LoginPassWord];
        _btnAutoLogin.selected = [loginInfo[IsAutoLogin] boolValue];
        return;
    }
    
    if([loginInfo[IsAutoLogin] boolValue])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            textName.text = loginInfo[LoginUserName];
            password.text = loginInfo[LoginPassWord];
            _btnAutoLogin.selected = [loginInfo[IsAutoLogin] boolValue];
             });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            textName.text = loginInfo[LoginUserName];
            _btnAutoLogin.selected = [loginInfo[IsAutoLogin] boolValue];
        });
    }
    if ([loginInfo[IsAutoLogin] boolValue]) {
        if ([loginInfo[LoginType] intValue]==NormalType ) {
            textName.text = loginInfo[LoginUserName];
            password.text = loginInfo[LoginPassWord];
            _btnAutoLogin.selected = [loginInfo[IsAutoLogin] boolValue];
            loginType = [loginInfo[LoginType] intValue];
            [self startLogin];
        }
        else{
            [self gotoMainViewLoginType:[loginInfo[LoginType] intValue] userInfo:loginInfo[UserID]];
        }
    }
}

#pragma mark -  登录
- (IBAction)onLogin:(id)sender {
    [self.password resignFirstResponder];
    //a,网络异常，b用户名密码错误，c
    if(![MainDelegate isNetworkAvailable])return;
    if ([textName.text length] == 0)
    {
        [AlertBox showWithMessage:Localized(@"帐号不能为空")];
        return;
    }
    else if([password.text length] == 0)
    {
        [AlertBox showWithMessage:Localized(@"密码不能为空")];
        return;
    }
    else if(![MainDelegate isMobileNumber:textName.text])
    {
        [AlertBox showWithMessage:Localized(@"请输入正确的手机号码格式")];
        return;
    }
    NSString *regex = @"^[A-Za-z0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![predicate evaluateWithObject:password.text])
    {
        [AlertBox showWithMessage:Localized(@"密码由字母或数字组成，不能包含其他符号")];
        return;
    }
    loginType = NormalType;
    [self startLogin];
}

#pragma mark - Login Process
//登陆成功1）未绑定进入定位，2）绑定设备跳转到3.2
- (void)startLogin
{
    [MainDelegate storeLoginInfoUseName:textName.text withPassword:password.text loginType:loginType isAutoLogin:_btnAutoLogin.selected userId:@""];
    [MainDelegate showProgressHubInView:self.view];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:textName.text forKey:@"login_id"];
    [param setObject:password.text forKey:@"login_pwd"];
    [SkywareUserManagement UserLoginWithParamesers:param Success:^(SkywareResult *result) {
        [MainDelegate hiddenProgressHubInView:self.view];
        NSString *respCode = result.message;
        if ([respCode intValue] == 200) {
            MainDelegate.loginedInfo = [[UserLoginedInfo alloc] initWithDeviceToken:result.token withUserDic:@{@"login_id":textName.text,@"login_pwd":password.text}];
            SkywareInstanceModel *instance = [SkywareInstanceModel sharedSkywareInstanceModel];
            instance.token = result.token;
            NSString *newName;
            if (IS_IPHONE_5_OR_LESS ) {
                newName = @"AirPurifierViewController";
            }else{
                newName = @"AirPurifierViewController6";
            }
            AirPurifierViewController *mainView = [[AirPurifierViewController alloc] initWithNibName:newName bundle:nil];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mainView];
//            navController.navigationBarHidden = YES;
            MainDelegate.window.rootViewController = navController;
            [MainDelegate reloadInputViews];
        }
    } failure:^(SkywareResult *result) {
        NSString *respCode = result.message;
        if([respCode intValue] == 404){
            [AlertBox showWithMessage:@"用户名不存在"];
        }
        else if([respCode intValue]== 500){
            [AlertBox showWithMessage:@"用户名或密码错误，请重试."];
        }else{
            [AlertBox showWithMessage:@"未知错误"];
        }
        [MainDelegate hiddenProgressHubInView:self.view];
    }];
}


-(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
}


//忘记密码
- (IBAction)onForgetPassword:(id)sender {
    [UserDefault setObject:textName.text forKey:@"phone"];
    [UserDefault synchronize];
    FindPasswordViewController *findPassword = [[FindPasswordViewController alloc] initWithNibName:@"FindPasswordViewController" bundle:nil];
    findPassword.strPhoneNumber =textName.text;
    findPassword.view.frame = self.view.frame;
    [self.navigationController pushViewController:findPassword animated:YES];
}

//注册
- (IBAction)onRegister:(id)sender {
    RegisterViewController *userRegister = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    userRegister.view.frame = self.view.frame;
    [self.navigationController pushViewController:userRegister animated:YES];
}

//是否自动登陆
- (IBAction)onAutoLogin:(UIButton *)sender {
    self.btnAutoLogin.selected = !self.btnAutoLogin.selected;
    NSDictionary *dicLoginInfo = [UserDefault objectForKey:LoginInfo];
    if(dicLoginInfo!= nil)
    {
        NSString *userName = [dicLoginInfo objectForKey:LoginUserName];
        NSString *passWord = [dicLoginInfo objectForKey:LoginPassWord];
        NSNumber *isAutoLogin= [NSNumber numberWithBool:self.btnAutoLogin.selected] ;
        NSDictionary *dicAutoLoginInfoTmp = @{IsAutoLogin:isAutoLogin,
                                              LoginUserName:userName,
                                              LoginPassWord:passWord};
        [UserDefault setObject:dicAutoLoginInfoTmp forKey:LoginInfo];
        [UserDefault synchronize];
    }
}
#pragma mark 第三方登陆
-(void)gotoMainViewLoginType:(int)type userInfo:(NSString*)userId
{
    [MainDelegate storeLoginInfoUseName:textName.text withPassword:password.text loginType:loginType isAutoLogin:_btnAutoLogin.selected userId:@""];
    [MainDelegate showProgressHubInView:self.view];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:textName.text forKey:@"login_id"];
    [param setObject:password.text forKey:@"login_pwd"];
    [SkywareUserManagement UserLoginWithParamesers:param Success:^(SkywareResult *result) {
        [MainDelegate hiddenProgressHubInView:self.view];
        NSString *respCode = result.message;
        if ([respCode intValue] == 200) {
            MainDelegate.loginedInfo = [[UserLoginedInfo alloc] initWithDeviceToken:result.token withUserDic:@{@"login_id":textName.text,@"login_pwd":password.text}];
            SkywareInstanceModel *instance = [SkywareInstanceModel sharedSkywareInstanceModel];
            instance.token = result.token;
            NSString *newName;
            if (IS_IPHONE_5_OR_LESS ) {
                newName = @"AirPurifierViewController";
            }else{
                newName = @"AirPurifierViewController6";
            }
            AirPurifierViewController *mainView = [[AirPurifierViewController alloc] initWithNibName:newName bundle:nil];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mainView];
//            navController.navigationBarHidden = YES;
            MainDelegate.window.rootViewController = navController;
            [MainDelegate reloadInputViews];
        }
    } failure:^(SkywareResult *result) {
        NSString *respCode = result.message;
        if([respCode intValue] == 404){
            [AlertBox showWithMessage:@"用户名不存在"];
        }
        else if([respCode intValue]== 500){
            [AlertBox showWithMessage:@"用户名或密码错误，请重试."];
        }
        [MainDelegate hiddenProgressHubInView:self.view];
    }];
}

-(void)clearPassword
{
    self.password.text = @"";
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}




@end
