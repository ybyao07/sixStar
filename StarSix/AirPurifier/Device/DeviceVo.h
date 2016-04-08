//
//  DeviceVo.h
//  AirPurifier
//
//  Created by bluE on 14-8-29.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceData.h"
#import "CurrentWeather.h"
/**
 * 设备信息的vo
 */
@interface DeviceVo : NSObject

@property (nonatomic) NSInteger id;
//设备基本信息
@property (nonatomic,strong) NSString *deviceId;
@property (nonatomic,strong) NSString *deviceMac;
@property (nonatomic,strong) NSString *deviceMcuVersion;
@property (nonatomic,strong) NSString *deviceSn;

//设备其它信息
@property (nonatomic,strong) NSString *deviceName;
@property (nonatomic,strong) NSString *deviceAddTime;//设备添加时间
@property (nonatomic,strong) NSString *deviceDesc3;//设备的滤网使用时间
@property (nonatomic,strong) NSString *deviceOnline;// 设备是否在线
@property (nonatomic,strong) NSString *deviceLock;// 设备是否锁定
@property (nonatomic,strong) NSString *deviceAddress;// 设备地址


@property (nonatomic,strong) DeviceData *deviceData;
//地区信息
@property (nonatomic,strong) NSString *deviceCity;
@property (nonatomic,strong) NSString *deviceProvince;
@property (nonatomic,strong) NSString *deviceAreaId;
@property (nonatomic,strong) NSString *deviceDistrict;

@property (nonatomic,strong) NSString *devicePmv;

//设备型号判断
@property (nonatomic,strong) NSString *productId;//根据此判断设备型号是A300还是A500（4为300，1为500）

//@property (nonatomic,strong) CurrentWeather *currentWeather;//室外天气
//@property (nonatomic,strong) NSString *currentOutPm;

-(DeviceVo *)initWithDic:(NSDictionary *)dic;

@end
