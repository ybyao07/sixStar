//
//  SendCommandManager.m
//  HangingFurnace
//
//  Created by ybyao07 on 15/9/25.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "SendCommandManager.h"
#import "UtilConversion.h"
#import "TimeUtilDiff.h"
#import <math.h>
#import "CommandSave.h"
#import "SkywareDeviceManager.h"

@implementation SendCommandManager

+(void)sendDeviceOpenCloseCmd:(DeviceVo *)skywareInfo
{
    [self setDeviceId:skywareInfo];
    DeviceData *data = skywareInfo.deviceData;
    NSString *commandCode;
    if(data.btnPower.boolValue){ //设备开机，发送关机指令
        commandCode = @"1000";
    }else{//设备关机，发送开机指令
        commandCode = @"1001";
    }
    [SkywareDeviceManager DeviceAutoPushCMDWithData:commandCode];
    CommandSave *cmd = [[CommandSave alloc] init];
    cmd.mac = skywareInfo.deviceMac;
    cmd.cmdCode = commandCode;
    cmd.time =@"";//暂留
    [CommandSave writeCommandSave:cmd];
}

+(void)sendFanFrequency:(DeviceVo *)skywareInfo
{
    [self setDeviceId:skywareInfo];
    DeviceData *data = skywareInfo.deviceData;
    [SkywareDeviceManager DeviceAutoPushCMDWithData:[SendCommandManager getFrequencyCmdOnCurrentFre:data.fanFrequency]];
}


+(void)sendSettingTimeCmd:(DeviceVo *)skywareInfo withCmd:(NSString *)strCmd
{
    [self setDeviceId:skywareInfo];
    [SkywareDeviceManager DeviceAutoPushCMDWithData:strCmd];
}

+(void)sendIntelligenceCmd:(DeviceVo *)skywareInfo withCmd:(NSString *)strCmd
{
    [self setDeviceId:skywareInfo];
    [SkywareDeviceManager DeviceAutoPushCMDWithData:strCmd];
}

+(void)sendCalibrateTimeCmd:(DeviceVo *)skywareInfo
{
    [self setDeviceId:skywareInfo];
    NSDate *curDate = [NSDate new];//第一个时间
    NSTimeInterval firstDate = [curDate timeIntervalSince1970]*1;
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *calibarateDate=[date dateFromString:skywareInfo.deviceData.calibarateTime];
    NSTimeInterval secondDate = [calibarateDate timeIntervalSince1970]*1;
    if (fabs(firstDate - secondDate) > 1000) {
        NSLog(@"the different is %lf",fabs(firstDate - secondDate));
//        Byte6  Minute [0,59]
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:curDate];
        NSInteger year = [dateComponent year];
        NSInteger month = [dateComponent month];
        NSInteger day = [dateComponent day];
        NSInteger hour = [dateComponent hour];
        NSInteger minute = [dateComponent minute];
        NSString *cmd = [NSString stringWithFormat:@"01%@%@%@%@%@",
                         [UtilConversion decimalToTwoByteHex:year],
                         [UtilConversion decimalToHex:month],
                         [UtilConversion decimalToHex:day],
                         [UtilConversion decimalToHex:hour],
                         [UtilConversion decimalToHex:minute]
                         ];
        [SkywareDeviceManager DeviceAutoPushCMDWithData:cmd];
    }
}


+(void)setDeviceId:(DeviceVo *)skywareInfo
{
//    if (skywareInfo==nil) { //如果没有设备信息
//        [SkywareDeviceInfoModel sharedSkywareInstanceModel].device_id = @"";
//        return;
//    }
//    [SkywareInstanceModel sharedSkywareInstanceModel].device_id = skywareInfo.deviceId;
}

+(NSString *)getFrequencyCmdOnCurrentFre:(long)currentFre
{
    //@"3100"
    NSString *cur ;
    if (currentFre < 16) {
        cur  = [NSString stringWithFormat:@"310%lx",currentFre];
    }else{
        cur = [NSString stringWithFormat:@"31%lx",currentFre];
    }
    return  cur;
}




@end
