//
//  DeviceBindingViewController.m
//  AirPurifier
//
//  Created by bluE on 14-9-2.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import "DeviceBindingViewController.h"
#import "CitySelectedViewController.h"
#import "CityDataHelper.h"
#import "AirPurifierAppDelegate.h"
#import "DeviceAddViewController.h"
#import "UserLoginedInfo.h"
#import "AlertBox.h"
#import "DeviceVo.h"
#import "DeviceManageViewController.h"
#import "DetailViewController.h"
#import "AirPurifierViewController.h"
#import "SkywareDeviceManagement.h"
#import "Util.h"
#import "UIColor+Utility.h"

#define  kMaxLength  8

@interface DeviceBindingViewController()<AlertBoxDelegate>

@end

@implementation DeviceBindingViewController
@synthesize curDevice;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addBarItemTitle:@"添加设备"];
    [self addBarBackButtonItemWithImageName:@"back_normal" selImageName:@"back_pressed" action:@selector(onBack:)];
    
    [self registerObserver];
    [self initView];
}
-(void)initView
{
    _titleBind.textColor = kTextColor;
    [self.view addSubview:_viewBindSucceed];
    _viewBindSucceed.frame =  CGRectMake(0, 0, kScreenW, kScreenH);
    _viewBindSucceed.hidden = YES;
    _txtDeviceName.text = curDevice.deviceName;
    //增加监听
    [NotificationCenter addObserver:self selector:@selector(textFieldEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:_txtDeviceName];

    NSString *city = [NSString stringWithFormat:@"%@",isEmptyString(curDevice.deviceCity)?@"":curDevice.deviceCity];
    _txtDeviceAddress.text = isEmptyString(city)?@"":city;
    _txtDeviceStatus.tag = [curDevice.deviceLock intValue];//未锁定
    
    //将图层的边框设置为圆脚
    _viewInfo.layer.cornerRadius = 8;
    _viewInfo.layer.masksToBounds = YES;
    //给图层添加一个有色边框
    _viewInfo.layer.borderWidth = 1;
    _viewInfo.layer.borderColor =[UIColor colorWithHex:0xa7a7aa alpha:1].CGColor;
    
    if ([curDevice.deviceLock isEqual:@"0"]) {
        _txtDeviceStatus.text = @"已锁定";
        [_btnStatus setTitle:@"解锁" forState:UIControlStateNormal];
    }
    else if([curDevice.deviceLock isEqual:@"1"]){
        _txtDeviceStatus.text = @"未锁定";
        [_btnStatus setTitle:@"锁定" forState:UIControlStateNormal];
    }

}
#pragma mark 更改设备地址
- (IBAction)onChangeAddress:(id)sender {
    CitySelectedViewController *citySelectedView = [[CitySelectedViewController alloc] initWithNibName:@"CitySelectedViewController" bundle:nil];
    citySelectedView.isFromDeviceBind= YES;
    [self.navigationController pushViewController:citySelectedView animated:YES];
}



- (IBAction)onLocking:(id)sender {
    //0锁定，1未锁定
    if ([_btnStatus.titleLabel.text isEqual:@"锁定"]) {
        [AlertBox showBindLockView:UNLOCKINGSTRING delegate:self];
    }else{
        [AlertBox showBindLockView:LOCKINGSTRING delegate:self];
    }
}

-(void) getLockStatus
{
    if ([_btnStatus.titleLabel.text isEqual:@"锁定"]) {
        _txtDeviceStatus.tag = 1;
    }
    else{
        _txtDeviceStatus.tag = 0;
    }
}

/**锁定,解锁设备
 **/
-(void)onBindLockUnlockOKButtonOnClicked:(NSString *)msgUnlockOrUnbinding
{
    NSLog(@"BindindDevice is successful@");
    if([msgUnlockOrUnbinding isEqualToString:UNLOCKINGSTRING]
       || [msgUnlockOrUnbinding isEqualToString:LOCKINGSTRING] ){//解锁，锁定
        if ([_btnStatus.titleLabel.text isEqual:@"锁定"]) {
            [_btnStatus setTitle:@"解锁" forState:UIControlStateNormal];
            _txtDeviceStatus.text = @"已锁定";
            _txtDeviceStatus.tag = 0;
        }else {
              [_btnStatus setTitle:@"锁定" forState:UIControlStateNormal];
            _txtDeviceStatus.text = @"未锁定";
            _txtDeviceStatus.tag = 1;
        }
    }
}

#pragma mark 绑定设备
- (IBAction)onBinding:(id)sender {
    //通过Mac修改设备
    if ([_txtDeviceName.text length]==0 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"设备名称不能为空" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert addButtonWithTitle:@"Yes"];
        [alert show];
        return;
    }
    if ([_txtDeviceAddress.text length]==0 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@" 设备地址不能为空" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert addButtonWithTitle:@"Yes"];
        [alert show];
        return;
    }
    [self getLockStatus];
    
    //保存设备信息
    curDevice.deviceLock = [NSString stringWithFormat:@"%d",_txtDeviceStatus.tag];
    curDevice.deviceName = _txtDeviceName.text;
    curDevice.deviceAddress = _txtDeviceAddress.text;
    //绑定设备之后更新设备信息
    [SVProgressHUD show];
    [SkywareDeviceManagement DeviceBindUser:@{@"device_id":curDevice.deviceId} Success:^(SkywareResult *result) {
        if ([result.message intValue] == 200) {
            [SVProgressHUD showSuccessWithStatus:@"绑定成功"];
            //获取已经绑定的设备的个数
            [SkywareDeviceManagement DeviceGetAllDevicesSuccess:^(SkywareResult *result) {
                [SVProgressHUD dismiss];
                if ([result.message intValue] == 200) {
                    NSArray *jsonArray =result.result;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (jsonArray != nil) {
                            _lblWhichDevice.text = [NSString stringWithFormat:@"恭喜你已成功添加第%d台设备",jsonArray.count];
                        }
                        else{
                            _lblWhichDevice.text = @"恭喜你已成功添加第1台设备";
                        }
                    });
                }
            } failure:^(SkywareResult *result) {
                [SVProgressHUD dismiss];
            }];

            SkywareDeviceUpdateInfoModel *device_info = [[SkywareDeviceUpdateInfoModel alloc] init];
            device_info.device_lock = curDevice.deviceLock;
            device_info.device_address = curDevice.deviceAddress;
            device_info.device_sn = curDevice.deviceSn;
            device_info.device_mac = curDevice.deviceMac;
            device_info.device_name = curDevice.deviceName;
            device_info.area_id = [CityDataHelper cityIDOfSelectedCity];
            device_info.province = curDevice.deviceProvince;
            device_info.city = curDevice.deviceCity;
            device_info.district = isEmptyString(curDevice.deviceDistrict)?@"":curDevice.deviceDistrict;
            [SkywareDeviceManagement DeviceUpdateDeviceInfo:device_info Success:^(SkywareResult *result) {
                [SVProgressHUD dismiss];
                if ([result.message intValue] == 200) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _viewBindSucceed.hidden = NO;
                        _deviceName.text = curDevice.deviceName;
                        _deviceLocation.text = curDevice.deviceAddress;
                        _deviceStatus.text = [curDevice.deviceLock isEqualToString:@"1"]?@"未锁定":@"已锁定" ;
                        [self.view bringSubviewToFront:_viewBindSucceed];
                    });
                }
            } failure:^(SkywareResult *result) {
                [SVProgressHUD dismiss];
            }];
        }else{
            [SVProgressHUD showErrorWithStatus:@"绑定设备失败"];
        }
    } failure:^(SkywareResult *result) {
        [SVProgressHUD showErrorWithStatus:@"绑定设备失败"];
    }];
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
    if (MainDelegate.isFromMain){//从首页添加
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[AirPurifierViewController class]]) {
                [self.navigationController popToViewController:temp animated:YES];
            }
        }
    }
    else{
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[DeviceAddViewController class]]) {
                [self.navigationController popToViewController:temp animated:YES];
            }
        }
    }
}



#pragma mark-Observer
- (void)registerObserver
{
    [NotificationCenter addObserver:self
                           selector:@selector(cityChanged)
                               name:CityChangedNotification
                             object:nil];
}
-(void )dealloc{
    [NotificationCenter removeObserver:self];
}

- (void)cityChanged
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _txtDeviceAddress.text = [NSString stringWithFormat:@"%@",[CityDataHelper cityNameOfSelectedCity]];
        curDevice.deviceCity = [[CityDataHelper selectedCity] objectForKey:kCityName];
        curDevice.deviceProvince = [[CityDataHelper selectedCity]objectForKey: kProvinceName];
        curDevice.deviceDistrict = [[CityDataHelper selectedCity] objectForKey:kDistrict];
    });
}
#pragma mark ——绑定成功Delegate
- (IBAction)onBinddingSucceed:(id)sender {
    
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
    else{
        for (UIViewController *temp in self.navigationController.viewControllers) {
//            if ([temp isKindOfClass:[DetailViewController class]]) {
//                [self.navigationController popToViewController:temp animated:YES];
//            }
            if ([temp isKindOfClass:[AirPurifierViewController class]]) {
                [self.navigationController popToViewController:temp animated:YES];
            }
        }
    }
    [NotificationCenter postNotificationName:AirDeviceAddedNotification object:nil];
}
- (IBAction)onAddAnotherDevice:(id)sender {
     [NotificationCenter postNotificationName:AirDeviceAddedNotification object:nil];
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[DeviceAddViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
}

- (IBAction)onClose:(id)sender {
    _viewBindSucceed.hidden = YES;
     [NotificationCenter postNotificationName:AirDeviceAddedNotification object:nil];
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

-(void)textFieldEditChanged:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;
//    [textField setText:[Util disable_emoji:[textField text]]];
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];//键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) {//简体中文输入
        UITextRange *selectedRange = [textField  markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
        }
        //有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    //中文输入法以外的直接对其统计限制即可
    else{
        if (toBeString.length > kMaxLength) {
            textField.text = [toBeString substringToIndex:kMaxLength];
        }
    }
    
}
@end
