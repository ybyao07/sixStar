//
//  UserInfo.m
//  AirPurifier
//
//  Created by ybyao07 on 15/4/2.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

-(instancetype) initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.loginID = [dic[@"login_id"] isEqual:[NSNull null]] ? @"":dic[@"login_id"];
        self.loginPwd = [dic[@"login_pwd"] isEqual:[NSNull null]] ? @"":dic[@"login_pwd"];
    }
    return self;
}

@end
