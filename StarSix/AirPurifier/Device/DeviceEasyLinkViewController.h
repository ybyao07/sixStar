//
//  DeviceAddViewController.h
//  AirPurifier
//
//  Created by bluE on 14-9-1.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFSmartLink.h"
#import "HFSmartLinkDeviceInfo.h"
#import "YBBaseViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@class localSave;
@class HFSmtlkV30;
@interface DeviceEasyLinkViewController : YBBaseViewController


@property (weak, nonatomic) IBOutlet UIView *viewTextTitle;


@property (weak, nonatomic) IBOutlet UITextField *titleWiFi;
//设置WIFI界面
@property (strong, nonatomic) IBOutlet UIView *viewWIFISetting;
#pragma 设置WiFi
@property (weak, nonatomic) IBOutlet UITextField *txtWiFi;
@property (weak, nonatomic) IBOutlet UITextField *txtWiFiPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnShowPassword;

@property (weak, nonatomic) IBOutlet UIView *settingBottomUP;
@property (weak, nonatomic) IBOutlet UIView *wifiContainView;
@property (weak, nonatomic) IBOutlet UIView *wifiFlickView;
@property (weak, nonatomic) IBOutlet UIView *settingBottomDown;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

//配置中
@property (strong, nonatomic) IBOutlet UIView *configureView;
@property (weak, nonatomic) IBOutlet UILabel *lblIsConfigure;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightWifiView;

//配置失败
@property (strong, nonatomic) IBOutlet UIView *configureFailureView;


//配置首页
- (IBAction)isShowingPassword:(id)sender;
//配置中
- (IBAction)onStartConfigure:(id)sender;
- (IBAction)onCancelConfigure:(id)sender;

//配置失败
- (IBAction)onTryAgain:(id)sender;
- (IBAction)onFailureCancel:(id)sender;



- (IBAction)onBack:(id)sender;

@property (nonatomic) BOOL isFromWifi;//设备从不在线到在线
@property (strong,nonatomic) NSString *deviceSn;

@end
