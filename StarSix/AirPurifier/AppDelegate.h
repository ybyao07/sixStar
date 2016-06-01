//
//  AppDelegate.h
//  AirPurifier
//
//  Created by bluE on 14-8-13.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceVo.h"
@interface AppDelegate : BaseDelegate <UIApplicationDelegate,UIAlertViewDelegate>

@property (nonatomic)  BOOL isShowingAlertBox;

- (BOOL)isNetworkAvailable;

-(BOOL)beforeSendBaseonWifiLock:(DeviceVo *)skywareInfo;

@end
