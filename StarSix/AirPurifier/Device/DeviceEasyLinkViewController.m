//
//  DeviceAddViewController.m
//  AirPurifier
//
//  Created by bluE on 14-9-1.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import "DeviceEasyLinkViewController.h"
#import "AirPurifierAppDelegate.h"
#import "AlertBox.h"
#import "UserLoginedInfo.h"
#import "CitySelectedViewController.h"
#import "CityDataHelper.h"
#import "UserLoginedInfo.h"
#import "DeviceBindingViewController.h"
#import "DeviceVo.h"
#import "SkywareDeviceManagement.h"
#import "PopHintView.h"
#import "DALabeledCircularProgressView.h"
#import <CommonCrypto/CommonDigest.h>
#import "AirPurifierViewController.h"

@interface DeviceEasyLinkViewController ()
{
    BOOL isSuccess;
    int showKey;
    NSInteger times;
    NSInteger findTimes;
    int sendTimes;
    
    HFSmartLink *smtlk;
    BOOL isconnecting;
}
@property (nonatomic,strong) DALabeledCircularProgressView *circleProgressView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contraintHeight;

@end

static const NSInteger WaitTime=50;
@implementation DeviceEasyLinkViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
    [self showWifiSsid];
    smtlk = [HFSmartLink shareInstence];
    smtlk.isConfigOneDevice = true;
    smtlk.waitTimers = 30;//等待时间120s
    isconnecting = false;
    self.settingBottomDown.hidden = YES;
}


-(void)initView
{
    if (_isFromWifi) {
        [self addBarItemTitle:@"设备配网"];
        _viewTextTitle.hidden = YES;
        _contraintHeight.constant = 0.1;//隐藏
    }else{
        [self addBarItemTitle:@"添加设备"];
    }
        [self addBarBackButtonItemWithImageName:@"back_normal" selImageName:@"back_pressed" action:@selector(onBack:)];
        _configureView.frame = self.view.frame;
        _configureFailureView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
        _configureView.hidden = YES;
        _configureFailureView.hidden = YES;
        [self.view addSubview:_configureView];
        [self.view addSubview:_configureFailureView];
        _titleWiFi.textColor = kTextColor;
        [self addWifilinkView];
}

-(void)addWifilinkView
{
    UILabel *_lblWifi = [[UILabel alloc] initWithFrame:CGRectMake(0,0,140, 36)];
    _lblWifi.text = @"手机连接上WiFi";
    _lblWifi.textAlignment = NSTextAlignmentCenter;
    _lblWifi.textColor = kTextColor;
    [_wifiContainView addSubview:_lblWifi];
    if (IS_IPHONE_5_OR_LESS) {
        _heightWifiView.constant = 120;
        _lblWifi.center = CGPointMake(210, 48);
        _lblWifi.font = [UIFont systemFontOfSize:14];
    }else if(IS_IPHONE_6){
        _heightWifiView.constant = 140;
        _lblWifi.center = CGPointMake(248, 56);
        _lblWifi.font = [UIFont systemFontOfSize:18];

    }else{
        _heightWifiView.constant = 160;
        [_lblWifi setCenter:CGPointMake(280, 64)];
        _lblWifi.font = [UIFont systemFontOfSize:18];
    }
    
//    UILabel *_lblWifiKey = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100, 36)];
//    _lblWifiKey.text = @"WiFi键";
//    _lblWifiKey.textAlignment = NSTextAlignmentCenter;
//    _lblWifiKey.textColor = kTextColor;
//    [_wifiFlickView addSubview:_lblWifiKey];
//    if (IS_IPHONE_5_OR_LESS) {
//        _lblWifiKey.center = CGPointMake(60, 70);
//        _lblWifiKey.font = [UIFont systemFontOfSize:14];
//    }else if(IS_IPHONE_6){
//        _lblWifiKey.center = CGPointMake(70, 80);
//        _lblWifiKey.font = [UIFont systemFontOfSize:18];
//    }else{
//        [_lblWifiKey setCenter:CGPointMake(72, 86)];
//        _lblWifiKey.font = [UIFont systemFontOfSize:18];
//    }
//    
//    UILabel *_lblWifiTint = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100, 36)];
//    _lblWifiTint.text = @"提示灯";
//    _lblWifiTint.textAlignment = NSTextAlignmentCenter;
//    _lblWifiTint.textColor = kTextColor;
//    [_wifiFlickView addSubview:_lblWifiTint];
//    if (IS_IPHONE_5_OR_LESS) {
//        _lblWifiTint.center = CGPointMake(276, 34);
//        _lblWifiTint.font = [UIFont systemFontOfSize:14];
//    }else if(IS_IPHONE_6){
//        _lblWifiTint.center = CGPointMake(324, 40);
//        _lblWifiTint.font = [UIFont systemFontOfSize:18];
//        
//    }else{
//        [_lblWifiTint setCenter:CGPointMake(358, 44)];
//        _lblWifiTint.font = [UIFont systemFontOfSize:18];
//    }
}


#pragma mark easyLink--获取WiFi
- (void)showWifiSsid
{
    BOOL wifiOK= FALSE;
    NSDictionary *ifs;
    NSString *ssid;
    UIAlertView *alert;
    if (!wifiOK)
    {
        ifs = [self fetchSSIDInfo];
        ssid = [ifs objectForKey:@"SSID"];
        if (ssid!= nil)
        {
            wifiOK= TRUE;
            _txtWiFi.text = ssid;
        }
        else
        {
            alert= [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"请连接Wi-Fi"] delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            alert.delegate=self;
            [alert show];
        }
    }
}


- (id)fetchSSIDInfo {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSLog(@"Supported interfaces: %@", ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSLog(@"%@ => %@", ifnam, info);
        if (info && [info count]) { break; }
        //        if (info ) { break; }
    }
    return info;
}
#pragma mark 是否显示密码
- (IBAction)isShowingPassword:(id)sender {
    self.btnShowPassword.selected = !self.btnShowPassword.selected;
    if (self.btnShowPassword.selected) {
        self.txtWiFiPassword.secureTextEntry = NO;
    }
    else{
        self.txtWiFiPassword.secureTextEntry = YES;
    }
}

#pragma mark --开始配置-----
- (IBAction)onStartConfigure:(id)sender {
    [self.imageView stopAnimating];
    if(!isconnecting){
        //配置中界面
        isconnecting = true;
        if (_configureView.hidden) {
            _configureView.hidden = NO;
            //进度条
            if (self.circleProgressView==nil) {
                self.circleProgressView = [[DALabeledCircularProgressView alloc] initWithFrame:CGRectMake(200.0f, 40.0f, 90.0f, 90.0f)];
                self.circleProgressView.roundedCorners = NO;
                CGPoint center = CGPointMake(_configureView.center.x, self.lblIsConfigure.frame.origin.y-80);
                self.circleProgressView.center = center;
                self.circleProgressView.progressTintColor = kTextColor;
                [_configureView addSubview:self.circleProgressView];
            }
            [self initCircleProgressView];
        }
        [self.view bringSubviewToFront:_configureView];
        [self SmtlkTimeOut];
        [smtlk startWithKey:_txtWiFiPassword.text processblock:^(NSInteger process) {
            //            self.progress.progress = process/18.0;
        } successBlock:^(HFSmartLinkDeviceInfo *dev) {
            NSLog(@"----device测试------%@",[NSString stringWithFormat:@"%@:%@",dev.mac,dev.ip]);
            //判断mac是否为对应的sn
            [NSThread sleepForTimeInterval:1.0f];//
            [self getSnFromMAC:dev.mac count:0];
        } failBlock:^(NSString *failmsg) {  //配置失败
            isconnecting  = false;
        } endBlock:^(NSDictionary *deviceDic) {
            isconnecting  = false;
        }];
    }else{
    }
}

- (IBAction)onBack:(id)sender {
    if ( MainDelegate.isFromRegister ) {
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
    if (MainDelegate.isFromWifi) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else{
        [self.navigationController
         popViewControllerAnimated:YES];
    }
}

// do smartLink
#pragma mark ----smartLink------
- (void)SmtlkTimeOut
{
    findTimes++;
   //进度条显示进度
    CGFloat progress = findTimes/(float)WaitTime ;
    [self.circleProgressView setProgress:progress animated:YES];
    self.circleProgressView.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", self.circleProgressView.progress*100];
    //超时处理
    if (findTimes == WaitTime)   //连接120s无响应，认为超时
    {
        [self initCircleProgressView];
        findTimes = 0;
        [smtlk stopWithBlock:^(NSString *stopMsg, BOOL isOk) {
        }];
        [self.view sendSubviewToBack:_configureView];
        _configureFailureView.hidden = NO;
        [self.view bringSubviewToFront:_configureFailureView];
        return;
    }
    //找到之后，停止发送广播
    if (!isconnecting)
    {
        [self initCircleProgressView];
        [smtlk stopWithBlock:nil];
        return;
    }
    if (findTimes%10 == 0) {
    
    }
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(SmtlkTimeOut) userInfo:nil repeats:NO];
}//end

-(void)initCircleProgressView
{
    [self.circleProgressView setProgress:0.0 animated:YES];
    self.circleProgressView.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", self.circleProgressView.progress];
}

//通过获得的Mac请求对应的Sn，判断是否正确
-(void)getSnFromMAC:(NSString *)mac count:(NSInteger )requestCount
{
    if (_isFromWifi) {
        SkywareDeviceQueryInfoModel *deviceModel = [[SkywareDeviceQueryInfoModel alloc] init];
        deviceModel.mac = mac;
        [SkywareDeviceManagement DeviceQueryInfo:deviceModel  Success:^(SkywareResult *result) {
            [SVProgressHUD dismiss];
            if ([result.message intValue] == 200) {
                [SVProgressHUD showSuccessWithStatus:@"设置WIFI成功"];
                [NotificationCenter postNotificationName:AirDeviceAddedNotification object:nil];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        } failure:^(SkywareResult *result) {
            [SVProgressHUD dismiss];
        }];
    }
    else{
        SkywareDeviceQueryInfoModel *deviceModel = [[SkywareDeviceQueryInfoModel alloc] init];
        deviceModel.mac = mac;
        [SkywareDeviceManagement DeviceQueryInfo:deviceModel  Success:^(SkywareResult *result) {
            [SVProgressHUD dismiss];
            if ([result.message intValue] == 200) {
                if (!isSuccess) {
                    isSuccess = YES;
                    NSDictionary *deviceInfomation = result.result;
                    DeviceVo *tempDevice = [[DeviceVo alloc] initWithDic:deviceInfomation];
                    if (!tempDevice.deviceSn) {//首次加入,deviceSn为nil
                        DeviceBindingViewController *deviceBinding = [[DeviceBindingViewController alloc] initWithNibName:@"DeviceBindingViewController" bundle:nil];
                        deviceBinding.curDevice = [[DeviceVo alloc] initWithDic:deviceInfomation];
                        deviceBinding.curDevice.deviceSn = _deviceSn;
                        [self.navigationController pushViewController:deviceBinding animated:YES];
                    }
                    else{
                        if ([tempDevice.deviceSn isEqualToString:_deviceSn]) {//检验sn码是否正确
                            DeviceBindingViewController *deviceBinding = [[DeviceBindingViewController alloc] initWithNibName:@"DeviceBindingViewController" bundle:nil];
                            deviceBinding.curDevice = [[DeviceVo alloc] initWithDic:deviceInfomation];
                            [self.navigationController pushViewController:deviceBinding animated:YES];
                        }
                        else{//sn不正确，重新绑定
                            [AlertBox showWithMessage:@"该设备与SN号不匹配，请重新输入"];
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    }
                }
            }
        } failure:^(SkywareResult *result) {
            if(requestCount < 3)
            {
                [NSThread sleepForTimeInterval:5.0f];//
                [self getSnFromMAC:mac count:requestCount + 1];
            }
            else{
                [AlertBox showWithMessage:@"该设备未成功登录"];//提示信息
                [self.navigationController
                 popViewControllerAnimated:YES];
            }
            [SVProgressHUD dismiss];
        }];
    }
}

//取消配置
- (IBAction)onCancelConfigure:(id)sender {
    [self initCircleProgressView];
    findTimes = 0;
    [self.view sendSubviewToBack:_configureView];
    [smtlk stopWithBlock:^(NSString *stopMsg, BOOL isOk) {
        isconnecting  = false;
    }];
    self.settingBottomDown.hidden = YES;
    self.settingBottomUP.hidden = NO;
    [self.view bringSubviewToFront:self.settingBottomUP];
//    [self beginAnimationImages];
}

//配置失败
- (IBAction)onTryAgain:(id)sender {
    findTimes = 0;
    _configureFailureView.hidden = YES;
    if (self.viewWIFISetting.hidden) {
        self.viewWIFISetting.hidden = NO;
    }
    [self.view bringSubviewToFront:_viewWIFISetting];
    [self beginAnimationImages];
}
- (IBAction)onFailureCancel:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (IBAction)gotoInstruction:(UIButton *)sender {
    [self beginAnimationImages];//
    [UIView animateWithDuration:1.0 animations:^{
        self.settingBottomUP.hidden = YES;
        self.settingBottomDown.hidden = NO;
        [self.view bringSubviewToFront:self.settingBottomDown];
    } completion:^(BOOL finished) {
    }];
}

- (void)beginAnimationImages
{
    if(self.imageView.isAnimating) return ;
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      [UIImage imageNamed:@"wifi_normal"],[UIImage imageNamed:@"wifi_flick"],nil];
    self.imageView.animationRepeatCount = MAXFLOAT;
    self.imageView.animationDuration = 0.3;
    [self.imageView startAnimating];
}

- (IBAction)cancelCancel:(UIButton *)sender {
    [UIView animateWithDuration:1.0 animations:^{
        self.settingBottomDown.hidden = YES;
        self.settingBottomUP.hidden = NO;
        [self.view bringSubviewToFront:self.settingBottomUP];
    } completion:^(BOOL finished) {
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
