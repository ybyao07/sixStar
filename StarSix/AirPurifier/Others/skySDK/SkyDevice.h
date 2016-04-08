//
//  SkyDevice.h
//  skySDKTest
//
//  Created by bluE on 14-11-3.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "GCDAsyncUdpSocket.h"
#import "GCDAsyncSocket.h"

@interface SkyDevice : NSObject
@property NSString *IP;
@property NSString *MAC;
@property int port;
@property GCDAsyncSocket *socket;//TCP socket

-(SkyDevice *)initWithArray:(NSArray *)array;
@end
