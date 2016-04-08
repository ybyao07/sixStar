//
//  TCPCommunication.m
//  skySDKTest
//
//  Created by bluE on 14-11-4.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import "TCPManager.h"

@implementation TCPManager
@synthesize deviceSocketArray;
static NSInteger snTag=0;

-(id)initWithDelegate:(id)aDelegate delegateQueue:(dispatch_queue_t)dq
{
    _asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:aDelegate delegateQueue:dq];
    return  self;
}
+(TCPManager *)sharedInstance
{
    static TCPManager * _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _sharedInstance = [[TCPManager alloc] init];
    });
    return _sharedInstance;
}

-(id)init
{
    self = [super init];
    deviceSocketArray = [NSMutableArray arrayWithCapacity:10];
    return self;
}

-(void) startConnectDeviceBasedonMAC:(NSString *)mac useDelegate:(id)aDelegate delegateQueue:(dispatch_queue_t)dq
{
    NSError *err=nil;
    _asyncSocket = [self getAsySockeBasedonMAC:mac];
    [_asyncSocket setDelegate:aDelegate delegateQueue:dq];
    if (_asyncSocket.isDisconnected) {
        if(![_asyncSocket connectToHost:_curDevice.IP onPort:_curDevice.port error:&err])
        {
            NSLog(@"%@",err.description);
        }else
        {
            NSLog(@"ok");
           NSLog(@"startConnectDevice!!!!!!!!!");
        }
    }
}

/**
 * 获取指定mac地址的TCP Socekt
 **/
-(GCDAsyncSocket *)getAsySockeBasedonMAC:(NSString *)mac
{
    if ([deviceSocketArray count] > 0 ) {
        for (int i=0; i<[deviceSocketArray count]; i++) {
            SkyDevice *device = [deviceSocketArray objectAtIndex:i];
            if ([device.MAC isEqualToString:mac]) {
                _asyncSocket= device.socket;
                _curDevice = device;
            }
        }
    }
    return _asyncSocket;
}
-(void) stopConnectDeviceBasedonMAC:(NSString *)mac
{
//    for (SkyDevice *device in deviceSocketArray) {
//        if ([device.MAC isEqualToString:mac]) {
//            [device.socket disconnect];
//            [deviceSocketArray removeObject:device];
//        }
//    }
    [deviceSocketArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([((SkyDevice *)obj).MAC isEqualToString:mac]) {
            *stop = YES;
        }
        if (*stop == YES) {
                        [((SkyDevice *)obj).socket disconnect];
                        [deviceSocketArray removeObject:obj];
        }
        if (*stop) {
            NSLog(@"array is %d",[deviceSocketArray count]);
        }
    }];
}

-(void)stopTCPConnect
{
    for (SkyDevice *device in deviceSocketArray) {
        [device.socket disconnect];
//        [deviceSocketArray removeObject:device];
    }
    [deviceSocketArray removeAllObjects];
}
-(void) sendToDeviceBasedonMAC:(NSString *)mac Command:(NSString *)command sign:(NSInteger) sn useDelegate:(id)aDelegate delegateQueue:(dispatch_queue_t)dq
{
    if (_asyncSocket.isDisconnected) {
        [self startConnectDeviceBasedonMAC:mac useDelegate:aDelegate delegateQueue:dq];
        
        [_asyncSocket writeData:[command dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:snTag];
        [_asyncSocket readDataWithTimeout:-1 tag:snTag];
        
    }
    else{
        snTag ++;
        //发送数据
        [_asyncSocket writeData:[command dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:snTag];
        [_asyncSocket readDataWithTimeout:-1 tag:snTag];
    }
}

-(void)addSkyDevice:(SkyDevice *)device  delegate:aDelegate delegateQueue:(dispatch_queue_t)dq
{
    if (![self isExistDevice:device.MAC]) {
        GCDAsyncSocket *socket= [[GCDAsyncSocket alloc]initWithDelegate:aDelegate delegateQueue:dq];
        device.socket =socket;
       [deviceSocketArray addObject:device];
    }
}

-(BOOL)isExistDevice:(NSString *)deviceMac
{
    for (SkyDevice *obj in  deviceSocketArray ) {
        if ([obj.MAC isEqualToString:deviceMac])  return  YES;
    }
    return NO;
}

@end
