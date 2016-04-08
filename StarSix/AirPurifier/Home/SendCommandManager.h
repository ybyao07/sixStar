//
//  SendCommandManager.h
//  HangingFurnace
//
//  Created by ybyao07 on 15/9/25.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceVo.h"
#import "DeviceData.h"
@interface SendCommandManager : NSObject

/**
 *  发送开关机指令
 *
 *  @param skywareInfo
 */
+(void)sendDeviceOpenCloseCmd:(DeviceVo *)skywareInfo;

/**
 *  发送调节风量指令
 *
 *  @param skywareInfo
 */
+(void)sendFanFrequency:(DeviceVo *)skywareInfo;

/**
 *  发送自定义时间模式 --需要服务器端处理
 *
 *  @param skywareInfo <#skywareInfo description#>
 */
+(void)sendSettingTimeCmd:(DeviceVo *)skywareInfo withCmd:(NSString *)strCmd
;

/**
 *  校准时间
 *
 *
 */
+(void)sendCalibrateTimeCmd:(DeviceVo *)skywareInfo;


/**
 *  发送智能模式 --需要服务器端处理
 *
 *  @param skywareInfo <#skywareInfo description#>
 */
+(void)sendIntelligenceCmd:(DeviceVo *)skywareInfo withCmd:(NSString *)strCmd
;

@end
