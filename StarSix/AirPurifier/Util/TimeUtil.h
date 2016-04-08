//
//  TimeUtil.h
//  StarSix
//
//  Created by ybyao07 on 15/11/18.
//  Copyright © 2015年 skyware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeUtil : NSObject

/**
 *  //计算时间差 dateString2 - dateString1 格式“HH:mm"
 *
 *  @param dateString1 被减数
 *  @param dateString2 减数
 *
 *  @return 返回小时，和分钟，以数组的形式存储
 */
+ (NSArray *)intervalFromLastDate:(NSString *)dateString1 toTheDate:(NSString *) dateString2;
/**
 *  //比较两个时间的大小，> 0 说明 dataSring2 > dateString1
 *
 *  @param dateString1 被减数
 *  @param dateString2 减数
 *
 *  @return 返回时间差值
 */
+(double)getIntervalTimeFromLastDate:(NSString *)dateString1 toTheDate:(NSString *) dateString2;

/**
 *  获取当前时间
 *
 *  @return 当前时间 @"yyyy/MM/dd HH:mm:ss:SSS"]
 */
+ (NSString*)getCurrentTime;




@end
