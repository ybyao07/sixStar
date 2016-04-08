//
//  TCPCommunication.h
//  skySDKTest
//
//  Created by bluE on 14-11-4.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
#import "SkyDevice.h"
@interface TCPManager : NSObject

@property NSMutableArray *deviceSocketArray;
@property NSString *remoteHost;
@property UInt16 remotePort;
@property NSString *localHost;
@property UInt16 localPort;

@property NSTimeInterval timeout;
@property(strong) GCDAsyncSocket *asyncSocket;
@property(strong) SkyDevice *curDevice;

+(TCPManager *)sharedInstance;

//-(id)initWithDelegate:(id)aDelegate delegateQueue:(dispatch_queue_t)dq;

/**
 *开启TCP连接
 **/
//-(void) startConnectDeviceBasedonMAC:(NSString *)mac useDelegate:(id)aDelegate delegateQueue:(dispatch_queue_t)dq;
/**
 *关闭TCP连接
 **/
-(void) stopConnectDeviceBasedonMAC:(NSString *)mac;
/**
 *关闭所有TCP连接
 **/
-(void)stopTCPConnect;
/**
 * 向指定端口发送数据
 **/
-(void) sendToDeviceBasedonMAC:(NSString *)mac Command:(NSString *)command sign:(NSInteger) sn useDelegate:(id)aDelegate delegateQueue:(dispatch_queue_t)dq;

/**
 * 获取指定mac地址的TCP Socekt
 **/
-(GCDAsyncSocket *)getAsySockeBasedonMAC:(NSString *)mac;
/**
 * 在TCP连接池中添加新的连接
 **/
-(void)addSkyDevice:(SkyDevice *)device delegate:aDelegate delegateQueue:(dispatch_queue_t)dq;

@end
