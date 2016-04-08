//
//  FanModeModel.m
//  StarSix
//
//  Created by ybyao07 on 15/9/17.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "FanModeModel.h"

@implementation FanModeModel


-(NSString *)strFanMode
{
    if (_inteMode == Silience) {
        return @"静音模式";
    }else if (_inteMode == CO2Adjust){
        return @"CO2调节";
    }else if(_inteMode == PMAdjust){
        return @"PM2.5调节";
    }else{
        return @"未开启";
    }
}
@end
