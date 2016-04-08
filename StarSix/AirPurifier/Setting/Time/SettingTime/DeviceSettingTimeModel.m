//
//  DeviceSettingTimeModel.m
//  StarSix
//
//  Created by ybyao07 on 15/9/17.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "DeviceSettingTimeModel.h"

@implementation DeviceSettingTimeModel

+(instancetype)createDeviceTimeModeWithMode:(SettingTimeMode)mode deviceName:(NSString *)name timePeriod:(NSMutableArray *)period
{
    DeviceSettingTimeModel *settingModel = [[DeviceSettingTimeModel alloc] init];
    settingModel.mode = mode;
    settingModel.deviceName = name;
//    settingModel.timePeriod = period;
    return settingModel;
}


-(NSString *)modeStr{
    if (_mode == Everyday) {
        return @"每天";
    }else if (_mode == OnlyOnce){
        return @"仅一次";
    }else if (_mode == Weekday){
        return @"工作日";
    }else{
        return @"未开启";
    }
}



@end
