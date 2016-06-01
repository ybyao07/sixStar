//
//  DeviceData.h
//  AirPurifier
//
//  Created by bluE on 15-1-16.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FanModeModel.h"
#import "CustomModel.h"
#import "DeviceSettingTimeModel.h"

@interface DeviceData : NSObject

@property (nonatomic,strong) NSString *btnPower;// 按钮状态开机
@property (nonatomic,strong) NSString *btnTimer;// 定时
//@property (nonatomic,strong) NSString *btnMode;// 模式
@property (nonatomic,assign) long btnFilterRemainTime;// 滤网剩余时间

@property (nonatomic,strong) NSString *calibarateTime;// 系统校准时间


@property (nonatomic,assign) long CO2Density;           //CO2浓度
@property (nonatomic,assign) long fanFrequency;       //风机的频率
@property (nonatomic,assign) long fanRotateSpeed;      //风量

@property (nonatomic,assign) float deviceInsidePm;      //室内pm
@property (nonatomic,assign) float deviceOutsidePm;     //室外pm

//从温湿度状态中获取温度湿度
@property (nonatomic,assign) float deviceInsideTem;     //室内温度
@property (nonatomic,assign) float deviceOutsideTem;    //室外温度

@property (nonatomic,strong) FanModeModel *fanModel;
@property (nonatomic,strong) DeviceSettingTimeModel *timeModel;

@property (nonatomic,strong) CustomModel *timeOne;
@property (nonatomic,strong) CustomModel *timeTwo;
@property (nonatomic,strong) CustomModel *timeThree;

@property (nonatomic,assign) NSTimeInterval serverUpdateTime;


-(instancetype)initWithBase64String:(NSString *)base64String;

@end
