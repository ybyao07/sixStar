//
//  TimeSetTableViewCell.m
//  StarSix
//
//  Created by ybyao07 on 15/9/17.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "TimeSetTableViewCell.h"
#import "TimeUtil.h"
#import "SetShowTimerModel.h"
@interface TimeSetTableViewCell()
{
    NSString *currentTime;
}
@property (weak, nonatomic) IBOutlet UILabel *deviceName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *timeMode;

@end

@implementation TimeSetTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)setModel:(DeviceVo *)model
{
    _model = model;
    self.deviceName.text = model.deviceName;
    [self getCurHourAndMinute];
    if (model.deviceData.timeModel!=nil) {
        //显示倒计时
        SetShowTimerModel *showTime = [[SetShowTimerModel alloc] init];
//        [self showTimeText:model.deviceData];
        self.time.text = [showTime getDevicelistShowTimeText:model];
        self.timeMode.text = model.deviceData.timeModel.modeStr;
        
    }
}

/**
 *  是否在开启的定时器设置的时间之间
 *  前提是定时开启的才计算在内
 *  1、首先判断 当前时间是否在这三个定时器中间，如果在的话，则不显示
 *  2、如果不在，则需要对比距离哪个开启时间最近
 *  3、计算与最近的开启时间的时间差
 *
 */
-(BOOL)isBetweenTime:(CustomModel *)model
{
    if (model.isOpen) {
        if(model.openTime.length == 5){
            int startHour,startMin,endHour,endMin;
            NSArray *timeStartArray = [TimeUtil intervalFromLastDate:currentTime toTheDate:model.openTime];
            NSArray *timeCloseArray = [TimeUtil intervalFromLastDate:currentTime toTheDate:model.closeTime];
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

-(void)showTimeText:(DeviceData *)deviceData
{
    NSMutableArray *timerModeArray = [NSMutableArray new];
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
        if (timerModeArray.count) {
            if ([self currentTimeIsBetweenTimers:timerModeArray]) {
                //当前时间在定时器设置的时间中间
                self.time.text = @"";
            }else{
                //计算距离开启还有多长时间
                self.time.text = [self getIntervalStartTime:timerModeArray];
            }
        }
    }
}


-(NSString *)getIntervalStartTime:(NSArray *)arrayOpen
{
    //比较哪个定时器的开始时间距离当前时间较近
    //先设定为第一个值，如果后面的比前面的小，则重新赋值
    int theNearbyTimerIndex = 0;
    double difference = 0.0;
    CustomModel *model = [arrayOpen objectAtIndex:0];
    difference = [TimeUtil getIntervalTimeFromLastDate:currentTime toTheDate:model.openTime];
     for(int i = 1; i < arrayOpen.count; i++){
        CustomModel *model = [arrayOpen objectAtIndex:i];
         if (difference > 0) {
             if (difference > [TimeUtil getIntervalTimeFromLastDate:currentTime toTheDate:model.openTime] ) {
                 difference = [TimeUtil getIntervalTimeFromLastDate:currentTime toTheDate:model.openTime];
                 theNearbyTimerIndex = i;
             }
         }else{ 
             difference = [TimeUtil getIntervalTimeFromLastDate:currentTime toTheDate:model.openTime];
             theNearbyTimerIndex = i;
         }
    }
    //计算还有多久开机
    CustomModel *startTimemodel = [arrayOpen objectAtIndex:theNearbyTimerIndex];
    NSArray *theNearbyTimeArray = [TimeUtil intervalFromLastDate:currentTime toTheDate:startTimemodel.openTime];
    if ([[theNearbyTimeArray objectAtIndex:0] intValue] > 0 || [[theNearbyTimeArray objectAtIndex:1] intValue] > 0) {
        if ([_model.deviceData.btnPower boolValue]) {
            return @"已开启";
        }else{
            return [NSString stringWithFormat:@"%d小时%d分钟后开启", [[theNearbyTimeArray objectAtIndex:0] intValue],[[theNearbyTimeArray objectAtIndex:1] intValue]];
        }
    }else{
        return @"";
    }
}


-(BOOL)currentTimeIsBetweenTimers:(NSArray *)array
{
    BOOL isBetween = false;
    for (int i = 0; i < array.count; i++) {
       isBetween =  [self isBetweenTime:[array objectAtIndex:i]];
        if (isBetween) break;
    }
    return isBetween;
}

//获取当前时间的小时和分钟值
- (void)getCurHourAndMinute
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *timeString=[formatter stringFromDate: [NSDate date]];
    currentTime  = timeString;
}





@end
