//
//  UDPCommunication.h
//  skySDKTest
//
//  Created by bluE on 14-11-3.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncUdpSocket.h"
@interface UDPManger : NSObject


@property NSString *maskHost;
@property UInt16 remotePort;
@property UInt16 localPort;

@property NSTimeInterval timeout;
@property(strong) GCDAsyncUdpSocket *udpSocket;

-(id)initWithDelegate:(id)aDelegate delegateQueue:(dispatch_queue_t)dq;
-(id)initWithDelegate:(id)aDelegate delegateQueue:(dispatch_queue_t)dq maskHost:(NSString *)remoteHost;
-(id)initWithDelegate:(id)aDelegate delegateQueue:(dispatch_queue_t)dq maskHost:(NSString *)remoteHost remotePort:(UInt16) remotePort localPort:(UInt16 )localPort;

-(void)startBroadcastWithString;
-(void)startBroadcastTime;
-(void)stopBroadcast;

@end
