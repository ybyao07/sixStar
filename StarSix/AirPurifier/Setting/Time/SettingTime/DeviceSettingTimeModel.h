//
//  DeviceSettingTimeModel.h
//  StarSix
//
//  Created by ybyao07 on 15/9/17.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "CustomModel.h"

typedef enum SettingTimeMode : NSUInteger {
    None=0,
    Everyday=1,
    OnlyOnce=2,
    Weekday=4
} SettingTimeMode;

@interface DeviceSettingTimeModel : BaseModel

@property (nonatomic,assign) SettingTimeMode mode;//设定的时间模式
@property (nonatomic,copy) NSString *deviceName;//设备名称

@property (nonatomic,copy) NSString *modeStr;
@property (nonatomic,assign) BOOL status;//开启，关闭状态
//总共有三个定时时间段
//@property (nonatomic,strong) NSMutableArray *timePeriod;//定时时间段
@property (nonatomic,strong) CustomModel *oneSettingTimeModel;
@property (nonatomic,strong) CustomModel *twoSettingTimeModel;
@property (nonatomic,strong) CustomModel *threeSettingTimeModel;

+(instancetype)createDeviceTimeModeWithMode:(SettingTimeMode)mode deviceName:(NSString *)name timePeriod:(NSMutableArray *)period;


@end
