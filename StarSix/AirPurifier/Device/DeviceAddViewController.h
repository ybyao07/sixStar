//
//  DeviceSettingViewController.h
//  AirPurifier
//
//  Created by bluE on 14-9-28.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "LocationController.h"
#import "YBBaseViewController.h"

@interface DeviceAddViewController : YBBaseViewController <UIImagePickerControllerDelegate,ZBarReaderDelegate,UITextFieldDelegate>
//激活设备界面
@property (strong, nonatomic) IBOutlet UIView *viewActive;
@property (weak, nonatomic) IBOutlet UITextField *txtDeviceSN;
- (IBAction)onActiveDevice:(id)sender;

//@property (strong, nonatomic) IBOutlet UIView *searchWifiView;

- (IBAction)tryAgainBackToMainView:(id)sender;
- (IBAction)tryGoIntoWifiEnvironment:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *txtActiveDevice;
@property (weak, nonatomic) IBOutlet UITextField *txtSettingWiFi;
@property (weak, nonatomic) IBOutlet UITextField *txtBindingDevice;

- (IBAction)onErWeiMa:(id)sender;


@end
