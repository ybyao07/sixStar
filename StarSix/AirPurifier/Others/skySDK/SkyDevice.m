//
//  SkyDevice.m
//  skySDKTest
//
//  Created by bluE on 14-11-3.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import "SkyDevice.h"
#import "Constants.h"
@implementation SkyDevice
@synthesize IP;
@synthesize MAC;
@synthesize port;
//@synthesize socket;


-(SkyDevice *)initWithArray:(NSArray *)array
{
    if (self = [super init]) {
        if ([array count] >=2) {
            self.IP = [array objectAtIndex:0];
            self.MAC = [array objectAtIndex:1];
            self.port = PORT_TCP_REMOTE ;//@"8899"
        }
    }
    return self;
}
@end
