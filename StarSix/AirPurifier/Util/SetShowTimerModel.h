//
//  SetShowTimerUtil.h
//  StarSix
//
//  Created by ybyao07 on 15/11/19.
//  Copyright © 2015年 skyware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceVo.h"

@interface SetShowTimerModel : NSObject

/**
 *  获取当前时间的小时和分钟
 *
 *  @return 当前小时，分钟 @"HH:mm"
 */
-(NSString *)getCurrentHourAndMinu;

/**
 *  单台设备显示
 *
 *  @param deviceData <#deviceData description#>
 *
 *  @return <#return value description#>
 */
-(NSString *)getOneDeviceShowTimeText:(DeviceVo *)deviceVo;

/**
 *  多台设备列表
 *
 *  @param deviceVo <#deviceVo description#>
 *
 *  @return <#return value description#>
 */
-(NSString *)getDevicelistShowTimeText:(DeviceVo *)deviceVo;


@end
