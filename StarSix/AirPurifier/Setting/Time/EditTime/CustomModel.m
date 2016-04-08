//
//  CustomModel.m
//  HangingFurnace
//
//  Created by 李晓 on 15/9/9.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "CustomModel.h"

@implementation CustomModel

+ (instancetype) createCustomModelWithOpenTime:(NSString *) openTime CloseTime:(NSString *)closeTime isOpen:(BOOL)isOpen
{
    CustomModel *custom = [[CustomModel alloc] init];
    custom.openTime = openTime;
    custom.closeTime = closeTime;
//    custom.temperature = temperature;
    custom.isOpen = isOpen;
    return custom;
}


//- (NSString *)temperature
//{
//    if (_temperature.length) {
//        return [NSString stringWithFormat:@"%@°C",_temperature];
//    }
//    return _temperature;
//}

@end
