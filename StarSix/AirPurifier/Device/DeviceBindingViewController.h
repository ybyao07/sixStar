//
//  DeviceBindingViewController.h
//  AirPurifier
//
//  Created by bluE on 14-9-2.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBBaseViewController.h"

@class DeviceVo;
@interface DeviceBindingViewController : YBBaseViewController


//绑定设备界面
#pragma 绑定设备
@property (weak, nonatomic) IBOutlet UITextField *titleBind;

@property (weak, nonatomic) IBOutlet UITextField *txtDeviceName;
@property (weak, nonatomic) IBOutlet UITextField *txtDeviceStatus;
@property (weak, nonatomic) IBOutlet UITextField *txtDeviceAddress;

//@property (weak, nonatomic) IBOutlet UITextField *txtStatusIndicator;
@property (weak, nonatomic) IBOutlet UIButton *btnStatus;

- (IBAction)onChangeAddress:(id)sender;

- (IBAction)onLocking:(id)sender;
- (IBAction)onBinding:(id)sender;
- (IBAction)onBack:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewInfo;

@property (strong, nonatomic) IBOutlet UIView *viewBind;
@property (strong, nonatomic) IBOutlet UIView *viewBindSucceed;

@property (weak, nonatomic) IBOutlet UITextField *lblWhichDevice;


@property (weak, nonatomic) IBOutlet UITextField *deviceName;
@property (weak, nonatomic) IBOutlet UITextField *deviceLocation;
@property (weak, nonatomic) IBOutlet UITextField *deviceStatus;

- (IBAction)onBinddingSucceed:(id)sender;
- (IBAction)onAddAnotherDevice:(id)sender;
- (IBAction)onClose:(id)sender;




@property (strong ,nonatomic) DeviceVo *curDevice;


@end
