//
//  DeviceEditViewController.h
//  AirPurifier
//
//  Created by bluE on 14-8-27.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertBox.h"
#import "YBBaseViewController.h"

@class DeviceVo;

@interface DeviceEditViewController : YBBaseViewController <AlertBoxDelegate
>

@property (weak, nonatomic) IBOutlet UITextField *txtDeviceName;
@property (weak, nonatomic) IBOutlet UITextField *txtDeviceAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtDeviceStatus;

@property (weak, nonatomic) IBOutlet UIView *viewDeviceName;
@property (weak, nonatomic) IBOutlet UIView *viewDeviceAddress;
@property (weak, nonatomic) IBOutlet UIView *viewDeviceStatus;
@property (weak, nonatomic) IBOutlet UITextField *txtStatusIndicator;

@property (weak, nonatomic) IBOutlet UIView *outLineView;

@property (strong ,nonatomic) DeviceVo *curDevice;
- (IBAction)onChangeAddress:(id)sender;
- (IBAction)onLocking:(id)sender;

- (IBAction)onComplete:(id)sender;
- (IBAction)onBack:(id)sender;

@end
