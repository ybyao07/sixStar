//
//  DeviceSettingViewController.m
//  AirPurifier
//
//  Created by bluE on 14-9-28.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import "DeviceAddViewController.h"
#import "AirPurifierAppDelegate.h"
#import "AlertBox.h"
#import "UserLoginedInfo.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "DeviceBindingViewController.h"
#import "DeviceVo.h"
#import "DeviceEasyLinkViewController.h"
#import "AirPurifierViewController.h"
#import "RootViewController.h"
#import "CityDataHelper.h"
#import "NSString+IsValidCharNumber.h"
#import "SkywareDeviceManagement.h"
#import "CitySelectedViewController.h"

#define kLeftW 20
@interface DeviceAddViewController ()
{
    UIButton *doneInKeyboardButton;
    /*
     二维码
     */
    int num;
    BOOL upOrdown;
    NSTimer * timer;
}
@property (nonatomic, strong) UIImageView * line;//二维码
@end

@implementation DeviceAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
}
-(void)initNav
{
    [self addBarItemTitle:@"添加设备"];
    [self addBarBackButtonItemWithImageName:@"back_normal" selImageName:@"back_pressed" action:@selector(onBack:)];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _txtActiveDevice.textColor = kTextColor;
    _txtDeviceSN.text=@"";
}

#pragma  mark 二维码扫描
- (IBAction)onErWeiMa:(id)sender {
    [self setupCamera];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [timer invalidate];
    _line.frame = CGRectMake(kLeftW, 10, kScreenW-2*kLeftW-40, 2);
    num = 0;
    upOrdown = NO;
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
    }];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [timer invalidate];
    _line.frame = CGRectMake(kLeftW, 10, kScreenW-2*kLeftW-40, 2);
    num = 0;
    upOrdown = NO;
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
        id<NSFastEnumeration> results =
        [info objectForKey: ZBarReaderControllerResults];
        ZBarSymbol *symbol = nil;
        for(symbol in results)
            break;
        NSString *dataNum=symbol.data;
        //这里过滤除数字之外的其它字符
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([dataNum isCharNumberString]) {
                
            }else{
              [[[UIAlertView alloc] initWithTitle:@"" message:@"您扫描的二维码不符合要求" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            }
            self.txtDeviceSN.text = [dataNum isCharNumberString]?dataNum:@"";
        });
    }];
}
-(void)setupCamera
{
    if(!IOS7)
    {
        RootViewController * rt = [[RootViewController alloc]init];
        [self presentViewController:rt animated:YES completion:^{
        }];
    }
    else
    {
        [self scanBtnAction];
    }
}
-(void)scanBtnAction
{
    num = 0;
    upOrdown = NO;
    //初始话ZBar
    ZBarReaderViewController * reader = [ZBarReaderViewController new];
    //设置代理
    reader.readerDelegate = self;
    //支持界面旋转
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    reader.showsHelpOnFail = NO;
    reader.scanCrop = CGRectMake(0.1, 0.2, 0.8, 0.8);//扫描的感应框
    ZBarImageScanner * scanner = reader.scanner;
    [scanner setSymbology:ZBAR_I25
                   config:ZBAR_CFG_ENABLE
                       to:0];
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 420)];
    view.backgroundColor = [UIColor clearColor];
    reader.cameraOverlayView = view;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(kLeftW, 20, kScreenW-2*kLeftW, 40)];
    label.text = @"请将扫描的二维码至于下面的框内\n谢谢！";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 2;
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    
    UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pick_bg.png"]];
    image.frame = CGRectMake(kLeftW, 80,  kScreenW-2*kLeftW, 280);
    [view addSubview:image];
    
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(kLeftW, 10, kScreenW-2*kLeftW-40, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [image addSubview:_line];
    //定时器，设定时间过1.5秒，
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animationLine) userInfo:nil repeats:YES];
    [self presentViewController:reader animated:YES completion:^{
    }];
}
-(void)animationLine
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(kLeftW, 10+2*num, kScreenW-2*kLeftW-40, 2);
        if (2*num == 260) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(kLeftW, 10+2*num, kScreenW-2*kLeftW-40, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
}
#pragma mark 开始设备连接
//先通过sn判断设备是否存在，如果存在就直接跳转到绑定设备，不存在走easyLink的设置WiFi
- (IBAction)onActiveDevice:(id)sender {
    [_txtDeviceSN resignFirstResponder];
    if (isEmptyString(self.txtDeviceSN.text)) {
        [AlertBox showWithMessage:@"请输入设备编码，你可以扫描二维码"];
        return;
    }
    //如果没有网路（没有wifi，没有移动网络）
    if (!MainDelegate.isNetworkAvailable) {
        return;
    }
//    #warning  test--start------
//        DeviceEasyLinkViewController *easyLink =[[DeviceEasyLinkViewController alloc] initWithNibName:@"DeviceEasyLinkViewController" bundle:nil];
//        easyLink.deviceSn = _txtDeviceSN.text;
//        [self.navigationController pushViewController:easyLink animated:YES];
//    #warning  test---end-------
    [SVProgressHUD show];
    [SkywareDeviceManagement DeviceVerifySN:_txtDeviceSN.text Success:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
        if ([result.message intValue] == 200) {
            //调取获取设备接口检验该sn号是否属于已经绑定的设备
            SkywareDeviceQueryInfoModel *queryModel = [[SkywareDeviceQueryInfoModel alloc] init];
            queryModel.sn = self.txtDeviceSN.text;
            
            [SkywareDeviceManagement DeviceQueryInfo:queryModel Success:^(SkywareResult *result) {
                if ([result.message intValue] == 200) {
                    NSDictionary *deviceInfomation = result.result;
                    DeviceBindingViewController *deviceBinding = [[DeviceBindingViewController alloc] initWithNibName:@"DeviceBindingViewController" bundle:nil];
                    deviceBinding.curDevice = [[DeviceVo alloc] initWithDic:deviceInfomation];

                    [SkywareDeviceManagement DeviceGetAllDevicesSuccess:^(SkywareResult *result) {
                        BOOL isHaveBinded = NO;
                        if ([result.message intValue] == 200) {
                            NSArray *jsonArray =result.result;
                            if([jsonArray count] > 0){
                                NSMutableString *deviceIdBuffer = [[NSMutableString alloc] init];
                                for (int i=0; i<[jsonArray count]; i++) {
                                    NSDictionary *dictionary = [jsonArray objectAtIndex:i];
                                    if ([dictionary objectForKey:@"id"]) {
                                        [deviceIdBuffer appendString:[dictionary objectForKey:@"id"]];
                                        [deviceIdBuffer appendString:@","];
                                    }
                                    DeviceVo *vo= [[DeviceVo alloc] initWithDic:dictionary];
                                    if ([deviceBinding.curDevice.deviceMac isEqualToString:vo.deviceMac]) {
                                        isHaveBinded = YES;
                                    }
                                }
                            }
                        }
                        //判断设备是否已经被自己绑定过了，如果已绑定过，则提示
                        if(isHaveBinded)
                        {
                            [SVProgressHUD showErrorWithStatus:@"此设备已经被绑定不能重复添加"];
                        }
                        //判断设备是否已经锁定,未锁定则直接跳到第三步
                        else if ([deviceBinding.curDevice.deviceLock intValue] == DeviceUnLock) {
                            [self.navigationController pushViewController:deviceBinding animated:YES];
                            [SVProgressHUD dismiss];
                        }else if ([deviceBinding.curDevice.deviceLock intValue] == DeviceLock) {
                            [SVProgressHUD showErrorWithStatus:@"设备已锁定不能添加"];
                        }
                    } failure:^(SkywareResult *result) {//没有绑定设备
                        [SVProgressHUD dismiss];
                        if ([deviceBinding.curDevice.deviceLock intValue] == DeviceUnLock) {
                            [self.navigationController pushViewController:deviceBinding animated:YES];
                        }else if ([deviceBinding.curDevice.deviceLock intValue] == DeviceLock) {
                            [SVProgressHUD showErrorWithStatus:@"设备已锁定不能添加"];
                        }

                    }];
                }
            } failure:^(SkywareResult *result) {
                if ([result.message intValue] == 404) {//第一次绑定--设备不存在
                    [SVProgressHUD dismiss];
                    //跳转到EasyLink
                    [self.view sendSubviewToBack:_viewActive];
                    DeviceEasyLinkViewController *easyLink =[[DeviceEasyLinkViewController alloc] initWithNibName:@"DeviceEasyLinkViewController" bundle:nil];
                    easyLink.deviceSn = _txtDeviceSN.text;
                    [self.navigationController pushViewController:easyLink animated:YES];
                }else{
                    [SVProgressHUD dismiss];
                }
            }];
        }
    } failure:^(SkywareResult *result) {
        if([result.message intValue] == 404){        //404没查到
            [SVProgressHUD showErrorWithStatus:@"您输入的Sn号不合法，请重新输入"];
        }
        else{//参数错误
            [SVProgressHUD showErrorWithStatus:@"网络过慢"];
        }
    }];
}

#pragma mark Wifi
- (IBAction)tryAgainBackToMainView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tryGoIntoWifiEnvironment:(id)sender {
    DeviceEasyLinkViewController *easyLink =[[DeviceEasyLinkViewController alloc] initWithNibName:@"DeviceEasyLinkViewController" bundle:nil];
    easyLink.deviceSn = _txtDeviceSN.text;
    easyLink.isFromWifi = YES;
    [self.navigationController pushViewController:easyLink animated:YES];
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
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark UITextFieldDelegate
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    return [string isCharNumberString];
//}
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
