//
//  skySDK.h
//  skySDKTest
//
//  Created by bluE on 14-11-3.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UDPManger.h"

@interface skySDK : NSObject

/**
 *开启UDP广播，发现设备
 **/
+(void) startDiscoverDeviceWithDelegate:(id)aDelegate delegateQueue:(dispatch_queue_t)dq;
/**
 *关闭UDP广播
 **/
+(void) stopDiscoverDevice;



/**
 *开启TCP连接
 **/
//+(void) startConnectDeviceBasedonMAC:(NSString *)mac useDelegate:(id)aDelegate delegateQueue:(dispatch_queue_t)dq;
/**
 * 关闭TCP连接
 **/
+(void) stopConnectDeviceBasedonMAC:(NSString *)mac;

/**
 * 关闭所有TCP连接
 **/
+(void)stopTCPConnect;

/**
 *通过TCP socket发送指令
 **/
+(void) sendToDeviceBasedonMAC:(NSString *)mac Command:(NSString *)command sign:(NSInteger) sn useDelegate:(id)aDelegate delegateQueue:(dispatch_queue_t)dq;

@end
