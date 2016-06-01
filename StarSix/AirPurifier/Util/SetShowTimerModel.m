//
//  SetShowTimerUtil.m
//  StarSix
//
//  Created by ybyao07 on 15/11/19.
//  Copyright © 2015年 skyware. All rights reserved.
//

#import "SetShowTimerModel.h"
#import "TimeUtilDiff.h"
#import "DeviceData.h"


/** 多台设备列表Cell显示
 *  1开机情况
 *   1）设置过当前模式的话，显示当前模式（仅一次，工作日，每一天)
 *   2) 没有设置模式的话，显示未
 *  2关机情况
 *   1) 三个定时器都未开启  显示@“--”    如果有模式显示当前模式，否则显示@“未开启”
 *   2) 开启定时器未开启模式 显示@“--” 显示@“未开启” ？？？？？？？？？？？这种情况下定时是否可用，理论上应该不可用
 *   3) 开启模式并且开启定时器(需要根据模式判断距离定时器开始的时间)
 *       a.当前三个定时器都已经过了时间，则根据模式（工作日，每天）判断距离第二天的最近的定时器的时间是多少
 */
//------------------------------当前只考虑当天的-----------------------------------------
@interface SetShowTimerModel()
{
    NSString *currentTime;
}
@end

@implementation SetShowTimerModel
-(instancetype)init
{
    if (self = [super init]) {
        currentTime = [self getCurrentHourAndMinu];
    }
    return self;
}
//获取当前时间的小时和分钟值
-(NSString *)getCurrentHourAndMinu
{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        NSString *timeString=[formatter stringFromDate: [NSDate date]];
        return timeString;
}
-(NSString *)getOneDeviceShowTimeText:(DeviceVo *)deviceVo
{
    NSMutableArray *timerModeArray = [NSMutableArray new];
    DeviceData *deviceData = deviceVo.deviceData;
    if (deviceData) {
        CustomModel *timermode = deviceData.timeOne;
        if (timermode.isOpen) {
            [timerModeArray addObject:timermode];
        }
        timermode = deviceData.timeTwo;
        if (timermode.isOpen) {
            [timerModeArray addObject:timermode];
        }
        timermode = deviceData.timeThree;
        if (timermode.isOpen) {
            [timerModeArray addObject:timermode];
        }
        //timerModeArray中保存已经开启的定时器的信息
        if (timerModeArray.count) { //开启定时器
            if ([self currentTimeIsBetweenTimers:timerModeArray]) {
                //当前时间在定时器设置的时间中间
                return deviceData.timeModel.modeStr;
                
            }else{
                if ([deviceData.btnPower boolValue]) {
                //当前设备已开启 1模式已开启2模式未开启
                    if (deviceData.timeModel.status) {
                        return deviceData.timeModel.modeStr;
                    }else{
                        return @"未开启";
                    }
                }else{ //获取距离开启的时间
                    return [self getIntervalStartTime:timerModeArray];
                }
            }
        }else{ //未开启定时器
                if (deviceData.timeModel.status) {
                    return deviceData.timeModel.modeStr;
                }else{
                    return @"未开启";
                }
        }
    }
    return @"";
}

-(NSString *)getDevicelistShowTimeText:(DeviceVo *)deviceVo
{
    NSMutableArray *timerModeArray = [NSMutableArray new];
    DeviceData *deviceData = deviceVo.deviceData;
    if (deviceData) {
        CustomModel *timermode = deviceData.timeOne;
        if (timermode.isOpen) {
            [timerModeArray addObject:timermode];
        }
        timermode = deviceData.timeTwo;
        if (timermode.isOpen) {
            [timerModeArray addObject:timermode];
        }
        timermode = deviceData.timeThree;
        if (timermode.isOpen) {
            [timerModeArray addObject:timermode];
        }
        //timerModeArray中保存已经开启的定时器的信息
        if (timerModeArray.count) { //开启定时器
            if ([self currentTimeIsBetweenTimers:timerModeArray]) {
                //当前时间在定时器设置的时间中间
                return @"--";
            }else{
                if ([deviceData.btnPower boolValue]) {
                    //当前设备已开启 1模式已开启2模式未开启
                    if (deviceData.timeModel.status) {
                        return @"--";
                    }else{
                        return @"--";
                    }
                }else{ //获取距离开启的时间
                    return [self getIntervalStartTime:timerModeArray];
                }
            }
        }else{ //未开启定时器
            if (deviceData.timeModel.status) {
                return @"--";
            }else{
                return @"--";
            }
        }
    }
    return @"";
}


/**
 *
 *
 *  @param arrayOpen 已开启定时器的数组
 *
 *  @return 距离定时器开始的时间
 */
-(NSString *)getIntervalStartTime:(NSArray *)arrayOpen
{
    //比较哪个定时器的开始时间距离当前时间较近
    //先设定为第一个值，如果后面的比前面的小，则重新赋值
    //如果当天没有，则再根据定时模式（仅一次，工作日，每一天）
    int theNearbyTimerIndex = 0;
    double difference = 0.0;
    CustomModel *model = [arrayOpen objectAtIndex:0];
    difference = [TimeUtilDiff getIntervalTimeFromLastDate:currentTime toTheDate:model.openTime];
    for(int i = 1; i < arrayOpen.count; i++){
        CustomModel *model = [arrayOpen objectAtIndex:i];
        if (difference > 0) {
            if (difference > [TimeUtilDiff getIntervalTimeFromLastDate:currentTime toTheDate:model.openTime] ) {
                difference = [TimeUtilDiff getIntervalTimeFromLastDate:currentTime toTheDate:model.openTime];
                theNearbyTimerIndex = i;
            }
        }else{
            difference = [TimeUtilDiff getIntervalTimeFromLastDate:currentTime toTheDate:model.openTime];
            theNearbyTimerIndex = i;
        }
    }
    //计算还有多久开机
    CustomModel *startTimemodel = [arrayOpen objectAtIndex:theNearbyTimerIndex];
    NSArray *theNearbyTimeArray = [TimeUtilDiff intervalFromLastDate:currentTime toTheDate:startTimemodel.openTime];
    if ([[theNearbyTimeArray objectAtIndex:0] intValue] > 0 || [[theNearbyTimeArray objectAtIndex:1] intValue] > 0) {
         return [NSString stringWithFormat:@"%d小时%d分钟后开启", [[theNearbyTimeArray objectAtIndex:0] intValue],[[theNearbyTimeArray objectAtIndex:1] intValue]];
    }else{
        //如果是“每一天” ，需要计算三个定时器那个开启的时间最早
        return @""; //定时器设置的时间都已经过期---只针对 仅一次的模式
    }
}

//-(int)getMinValue
//{
//    NSArray *sortArray = [[NSArray alloc] initWithObjects:@"1",@"3",@"4",@"7",@"8",@"2",@"6",@"5",@"13",@"15",@"12",@"200",@"28",nil];
//    NSNumber * min = [sortArray valueForKeyPath:@"@min.floatValue"];
//    return [min intValue];
//}

-(BOOL)currentTimeIsBetweenTimers:(NSArray *)array
{
    BOOL isBetween = false;
    for (int i = 0; i < array.count; i++) {
        isBetween =  [self isBetweenTime:[array objectAtIndex:i]];
        if (isBetween) break;
    }
    return isBetween;
}

-(BOOL)isBetweenTime:(CustomModel *)model
{
    if (model.isOpen) {
        if(model.openTime.length == 5){
            int startHour,startMin,endHour,endMin;
            NSArray *timeStartArray = [TimeUtilDiff intervalFromLastDate:currentTime toTheDate:model.openTime];
            NSArray *timeCloseArray = [TimeUtilDiff intervalFromLastDate:currentTime toTheDate:model.closeTime];
            startHour = [[timeStartArray objectAtIndex:0] intValue];
            startMin = [[timeStartArray objectAtIndex:1] intValue];
            endHour = [[timeCloseArray objectAtIndex:0] intValue];
            endMin = [[timeCloseArray objectAtIndex:1] intValue];
            if ((startHour < 0|| startMin < 0) && (endHour > 0 || endMin > 0)) {
                return YES;
            }
        }
    }
    return NO;
}

//获取日期
-(NSString *)getCurrentDateWeekday
{
    NSArray * arrWeek=[NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |NSWeekdayCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger week = [comps weekday];
    //1－－星期天
    //2－－星期一
    //3－－星期二
    //4－－星期三
    //5－－星期四
    //6－－星期五
    //7－－星期六
    return [NSString stringWithFormat:@"%@",[arrWeek objectAtIndex:week-1]];
}




@end
