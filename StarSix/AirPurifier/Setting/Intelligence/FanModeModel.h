//
//  FanModeModel.h
//  StarSix
//
//  Created by ybyao07 on 15/9/17.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
typedef enum IntelligenceMode : NSUInteger {
    Silience =1,
    CO2Adjust=2,
    PMAdjust=4
}IntelligenceMode;

@interface FanModeModel : BaseModel


@property (nonatomic,assign) IntelligenceMode inteMode;
@property (nonatomic,strong) NSString *strFanMode;//风机模式------静音，CO2调节，PM2.5调节
@property (nonatomic,assign) long pm25;
@property (nonatomic,assign) long  CO2; //CO2调节浓度
@property (nonatomic,assign) BOOL status;//是否开启智能模式


@end
