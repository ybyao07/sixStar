//
//  skySDK.m
//  skySDKTest
//
//  Created by bluE on 14-11-3.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import "skySDK.h"
#import "TCPManager.h"

@interface skySDK()

@end
static UDPManger* udpCom;
@implementation skySDK
+(void) startDiscoverDeviceWithDelegate:(id)aDelegate delegateQueue:(dispatch_queue_t)dq
{
    udpCom = [[UDPManger alloc] initWithDelegate:aDelegate delegateQueue:dq];
    [udpCom startBroadcastTime];
  }

+(void) stopDiscoverDevice
{
    [udpCom stopBroadcast];
}
//+(void) startConnectDeviceBasedonMAC:(NSString *)mac useDelegate:(id)aDelegate delegateQueue:(dispatch_queue_t)dq
//{
//    [[TCPManager sharedInstance] startConnectDeviceBasedonMAC:mac useDelegate:aDelegate delegateQueue:dq] ;
//}

+(void) stopConnectDeviceBasedonMAC:(NSString *)mac
{
    [[TCPManager sharedInstance] stopConnectDeviceBasedonMAC:mac];
}

+(void)stopTCPConnect
{
    [[TCPManager sharedInstance] stopTCPConnect];
}
+(void) sendToDeviceBasedonMAC:(NSString *)mac Command:(NSString *)command sign:(NSInteger) sn useDelegate:(id)aDelegate delegateQueue:(dispatch_queue_t)dq;
{
     [[TCPManager sharedInstance] sendToDeviceBasedonMAC:mac Command:command sign:sn useDelegate:aDelegate delegateQueue:dq] ;
}

@end
