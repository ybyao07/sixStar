//
//  Constants.h
//  skySDKTest
//
//  Created by bluE on 14-11-3.
//  Copyright (c) 2014年 skyware. All rights reserved.
//
#import <Foundation/Foundation.h>

#ifndef skySDKTest_Constants_h
#define skySDKTest_Constants_h
//声明常量
//export global constants
/** 设备TCP远程端口规定值（不可变）（利尔达） */
FOUNDATION_EXPORT const int PORT_TCP_REMOTE ;
/** 设备UDP远程端口规定值（不可变）（利尔达、博联） */
FOUNDATION_EXPORT const int  PORT_UDP_REMOTE ;
/** 设备UDP广播本地监听端口（利尔达、博联插座） */
FOUNDATION_EXPORT const int PORT_UDP_LOCAL;
/** 设备UDP广播子网掩码（利尔达、博联插座） */
FOUNDATION_EXPORT NSString *const UDP_MASK;


#endif
