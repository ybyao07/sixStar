//
//  UDPCommunication.m
//  skySDKTest
//
//  Created by bluE on 14-11-3.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import "UDPManger.h"
#import "Constants.h"

static NSTimer *myTimer;

@implementation UDPManger
@synthesize udpSocket;
@synthesize maskHost;
@synthesize remotePort;

-(id)initWithDelegate:(id)aDelegate delegateQueue:(dispatch_queue_t)dq
{
//    myTimer = [NSTimer scheduledTimerWithTimeInterval:1000 target:self selector:@selector(startBroadcastWithString) userInfo:nil repeats:YES];
//    [myTimer fire];
    return [self initWithDelegate:aDelegate delegateQueue:dq maskHost:UDP_MASK remotePort:PORT_UDP_REMOTE localPort:PORT_UDP_LOCAL];
}
-(id)initWithDelegate:(id)aDelegate delegateQueue:(dispatch_queue_t)dq maskHost:(NSString *)remoteHost
{
    return [self initWithDelegate:aDelegate delegateQueue:dq maskHost:remoteHost remotePort:PORT_UDP_REMOTE  localPort:PORT_UDP_LOCAL ];
}
-(id)initWithDelegate:(id)aDelegate delegateQueue:(dispatch_queue_t)dq maskHost:(NSString *)remoteHost remotePort:(UInt16) rmPort localPort:(UInt16 )localPort
{
    self.udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:aDelegate delegateQueue:dq];
    NSError *error;
    if (![udpSocket enableBroadcast:YES error:&error]) {
        NSLog(@"Error enableBroadcast:%@",error);
    }
    if (![udpSocket bindToPort:PORT_UDP_LOCAL error:&error])
    {
        NSLog(@"Error binding: %@", error);
    }
    if (![udpSocket beginReceiving:&error])
    {
        NSLog(@"Error receiving: %@", error);
    }
    self.maskHost=remoteHost;
    self.localPort=localPort;
    self.remotePort = rmPort;
    return  self;
}

-(void)startBroadcastWithString
{
     NSString *request= @"HF-A11ASSISTHREAD";
    NSTimeInterval timeout = 5000;
    NSData *data = [NSData dataWithData:[request dataUsingEncoding:NSASCIIStringEncoding]];
    [udpSocket sendData:data toHost:maskHost port:remotePort withTimeout:timeout tag:1];
}
-(void)startBroadcastTime
{
     myTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(startBroadcastWithString) userInfo:nil repeats:YES];
    [myTimer fire];
}
-(void)stopBroadcast
{
    [udpSocket close];
}
@end
