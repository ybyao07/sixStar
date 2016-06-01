//
//  DeviceUserTest.h
//  AirPurifier
//
//  Created by ybyao07 on 16/1/25.
//  Copyright © 2016年 skyware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceUserTest : NSObject

@property (nonatomic,strong) NSString *device_id;
@property (nonatomic,strong) NSString *device_mac;
@property (nonatomic,strong) NSString *device_name;
@property (nonatomic,strong) NSString *device_lock;// 设备是否锁定

@property (nonatomic,strong) NSString *user_name;
@property (nonatomic,strong) NSString *login_id;

@property (nonatomic,strong) NSString *device_state;//设备状态 0：正常；1：未确认绑定；2：主用户锁定设备；3：主用户重新配网

@end
