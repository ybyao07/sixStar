//
//  DeviceEditViewController.m
//  AirPurifier
//
//  Created by bluE on 14-8-27.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import "DeviceEditViewController.h"
#import "CitySelectedViewController.h"
#import "AlertBox.h"
#import "CityDataHelper.h"
#import "AirPurifierAppDelegate.h"
#import "UserLoginedInfo.h"
#import "DeviceVo.h"
#import "SkywareDeviceManagement.h"
#import "UIColor+Utility.h"
#import "Util.h"

#define  kMaxLength  8

@interface DeviceEditViewController ()
{
    int iLock;
}
@property (weak, nonatomic) IBOutlet UIButton *roundBtnAddress;
@property (weak, nonatomic) IBOutlet UIButton *roundBtnLock;
@property (weak, nonatomic) IBOutlet UIButton *roundBtnSure;

@end


@implementation DeviceEditViewController
@synthesize curDevice;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _roundBtnLock.layer.cornerRadius = 2;
    _roundBtnAddress.layer.cornerRadius = 2;
    _roundBtnSure.layer.cornerRadius = 4;
    // Do any additional setup after loading the view from its nib.
    [self registerObserver];
    [self initNavView];
    [self initView];
}

-(void)initNavView
{
    [self addBarItemTitle:@"修改设备信息"];
    [self addBarBackButtonItemWithImageName:@"back_normal" selImageName:@"back_pressed" action:@selector(onBack:)];
}
-(void)initView
{
    _txtDeviceName.text = curDevice.deviceName;
    
    //增加监听
    [NotificationCenter addObserver:self selector:@selector(textFieldEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:_txtDeviceName];
    
//    _txtDeviceAddress.text =[NSString stringWithFormat:@"%@市",curDevice.deviceAddress] ;
    _txtDeviceAddress.text =[NSString stringWithFormat:@"%@%@市",curDevice.deviceProvince,[curDevice.deviceCity stringByReplacingOccurrencesOfString:@"市" withString:@""]] ;
    
    //将图层的边框设置为圆脚
    _outLineView.layer.cornerRadius = 8;
    _outLineView.layer.masksToBounds = YES;
    //给图层添加一个有色边框
    _outLineView.layer.borderWidth = 2;
    _outLineView.layer.borderColor =[UIColor colorWithHex:0xa7a7aa alpha:1].CGColor;
    iLock = [curDevice.deviceLock intValue];
    if (iLock == DeviceLock) {
        _txtDeviceStatus.text = @"已锁定";
        _txtStatusIndicator.text = @"解锁";
    }
    else if(iLock == DeviceUnLock){
        _txtDeviceStatus.text = @"未锁定";
        _txtStatusIndicator.text = @"锁定";
    }
}

#pragma mark -----改变设备地址-----
- (IBAction)onChangeAddress:(id)sender {
    CitySelectedViewController *citySelectedView = [[CitySelectedViewController alloc] initWithNibName:@"CitySelectedViewController" bundle:nil];
    citySelectedView.isFromDeviceBind= YES;
    [self.navigationController pushViewController:citySelectedView animated:YES];
}

- (IBAction)onLocking:(id)sender {
    //0锁定，1未锁定
    if (iLock == DeviceLock) {
        [AlertBox showBindLockView:UNLOCKINGSTRING delegate:self];    
//        iLock = DeviceUnLock;
//        _txtStatusIndicator.text = @"锁定";
//        _txtDeviceStatus.text = @"未锁定";
    }else if(iLock == DeviceUnLock){
        [AlertBox showBindLockView:LOCKINGSTRING delegate:self];
//        iLock = DeviceLock;
//        _txtStatusIndicator.text = @"解锁";
//        _txtDeviceStatus.text = @"已锁定";
    }
}


/**锁定设备
 **/
-(void)onBindLockUnlockOKButtonOnClicked:(NSString *)msgUnlockOrUnbinding
{
    NSLog(@"BindindDevice is successful@");
    if([msgUnlockOrUnbinding isEqualToString:UNLOCKINGSTRING]
       || [msgUnlockOrUnbinding isEqualToString:LOCKINGSTRING] ){//解锁，锁定
        if (iLock == DeviceLock) {
            iLock = DeviceUnLock;
            _txtStatusIndicator.text = @"锁定";
            _txtDeviceStatus.text = @"未锁定";
        }else if(iLock == DeviceUnLock){
            iLock = DeviceLock;
            _txtStatusIndicator.text = @"解锁";
            _txtDeviceStatus.text = @"已锁定";
        }
    }
 
    
    
}
#pragma mark - Observer Management
- (void)registerObserver
{
    [NotificationCenter addObserver:self
                           selector:@selector(cityChanged)
                               name:CityChangedNotification
                             object:nil];
}
-(void)dealloc{
    [NotificationCenter removeObserver:self];
}



#pragma mark - Display Air Manager To View
- (void)cityChanged
{
    dispatch_async(dispatch_get_main_queue(), ^{
//        _txtDeviceAddress.text = [NSString stringWithFormat:@"%@",[CityDataHelper cityNameOfSelectedCity]];
        _txtDeviceAddress.text = [NSString stringWithFormat:@"%@%@市",[[CityDataHelper selectedCity]objectForKey: kProvinceName],[[CityDataHelper selectedCity] objectForKey:kCityName]];

        curDevice.deviceAreaId = [[CityDataHelper selectedCity] objectForKey:kCityID];
        curDevice.deviceCity = [[CityDataHelper selectedCity] objectForKey:kCityName];
        curDevice.deviceProvince = [[CityDataHelper selectedCity]objectForKey: kProvinceName];
        curDevice.deviceDistrict = [[CityDataHelper selectedCity] objectForKey:kDistrict];
    });
}

#pragma mark ---修改设备信息------
- (IBAction)onComplete:(id)sender {
    if ([_txtDeviceName.text length]==0 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"设备名称不能为空" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert addButtonWithTitle:@"Yes"];
        [alert show];
        return;
    }
    DeviceVo *temp = [curDevice copy];
    temp.deviceLock = [NSString stringWithFormat:@"%d",iLock];
    temp.deviceAddress = _txtDeviceAddress.text;
    temp.deviceName =_txtDeviceName.text;
    
    SkywareDeviceUpdateInfoModel *device_info = [[SkywareDeviceUpdateInfoModel alloc] init];
    device_info.device_lock = temp.deviceLock;
    device_info.device_sn = temp.deviceSn;
    device_info.device_mac = temp.deviceMac;
    device_info.device_name = temp.deviceName;
    device_info.area_id = [CityDataHelper cityIDOfSelectedCity];
    device_info.province = temp.deviceProvince;
    device_info.city = temp.deviceCity;
    device_info.district = isEmptyString(temp.deviceDistrict)?@"":temp.deviceDistrict;
    [SVProgressHUD show];
    [SkywareDeviceManagement DeviceUpdateDeviceInfo:device_info Success:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
        if ([result.message intValue] == 200) {
            curDevice.deviceLock = [NSString stringWithFormat:@"%d",iLock];
            curDevice.deviceName =_txtDeviceName.text;
            [NotificationCenter postNotificationName:AirDeviceChangedNotification object:nil];
            [SVProgressHUD showSuccessWithStatus:@"修改设备信息成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"修改设备信息失败"];
    }];
}


- (IBAction)onBack:(id)sender {
      [self.navigationController popViewControllerAnimated:YES];
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
        if (toBeString.length >kMaxLength) {
            textField.text = [toBeString substringToIndex:kMaxLength];
        }
    }
}
@end
