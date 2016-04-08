//
//  DeviceStatusConst.h
//  AirPurifier
//
//  Created by bluE on 15-1-16.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceStatusConst : NSObject

enum DeviceStatus
{
    DeviceLock = 0,//设备已经锁定
    DeviceUnLock = 1,//设备未锁定
    
    DevicePowerOff  = 0,
    DevicePowerOn  = 1,
    DeviceOnlineOff  = 0,
    DeviceOnlineOn = 1,
    
    //童锁
    BtnLockOff = 0,
    BtnLockOn = 1,
    //UV
    BtnUVOff = 0,
    BtnUVOn = 1,
    //负离子
    BtnAnionOff = 0,
    BtnAnionOn = 1,
    //模式
    BtnModeManual = 0,
    BtnModeAuto = 1,
    BtnModeSleep = 2,
    
    BtnWindOff = 0,
    BtnModeOff = 0,
    BtnTimerOff = 0
};

typedef enum DeviceStatus DeviceStatus;




@end
