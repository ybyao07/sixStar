//
//  ModelUser.m
//  AirPurifier
//
//  Created by ybyao07 on 15/4/2.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "ModelUser.h"
#import "JSON.h"
@implementation ModelUser

-(instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super initWithDic:dic];
    if (self) {
        NSLog(@"----%@----",dic[@"user_prefer"]);
//        self.noticeModel = [ModelNotice baseModelWithDic:[dic[@"user_prefer"] JSONValue]];
    }
    return self;
}



@end
