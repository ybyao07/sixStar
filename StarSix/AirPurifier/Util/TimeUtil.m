//
//  TimeUtil.m
//  StarSix
//
//  Created by ybyao07 on 15/11/18.
//  Copyright © 2015年 skyware. All rights reserved.
//

#import "TimeUtil.h"

@implementation TimeUtil

//- (NSString *)intervalFromLastDate: (NSString *) dateString1  toTheDate:(NSString *) dateString2
//{
//    NSArray *timeArray1=[dateString1 componentsSeparatedByString:@"."];
//    dateString1=[timeArray1 objectAtIndex:0];
//    NSArray *timeArray2=[dateString2 componentsSeparatedByString:@"."];
//    dateString2=[timeArray2 objectAtIndex:0];
//    NSLog(@"%@.....%@",dateString1,dateString2);
//    NSDateFormatter *date=[[NSDateFormatter alloc] init];
////    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    [date setDateFormat:@"HH:mm"];
//
//    NSDate *d1=[date dateFromString:dateString1];
//    NSTimeInterval late1=[d1 timeIntervalSince1970]*1;
//    NSDate *d2=[date dateFromString:dateString2];
//    NSTimeInterval late2=[d2 timeIntervalSince1970]*1;
//
//    NSTimeInterval cha=late2-late1;
//    NSString *timeString=@"";
//    NSString *house=@"";
//    NSString *min=@"";
//    NSString *sen=@"";
//
//    sen = [NSString stringWithFormat:@"%d", (int)cha%60];
//    //        min = [min substringToIndex:min.length-7];
//    //    秒
//    sen=[NSString stringWithFormat:@"%@", sen];
//
//    min = [NSString stringWithFormat:@"%d", (int)cha/60%60];
//    //        min = [min substringToIndex:min.length-7];
//    //    分
//    min=[NSString stringWithFormat:@"%@", min];
//
//    //    小时
//    house = [NSString stringWithFormat:@"%d", (int)cha/3600];
//    //        house = [house substringToIndex:house.length-7];
//    house=[NSString stringWithFormat:@"%@", house];
//    timeString=[NSString stringWithFormat:@"%@:%@:%@",house,min,sen];
//
//
//    return timeString;
//}

//计算时间差 dateString2 - dateString1
+ (NSArray *)intervalFromLastDate:(NSString *)dateString1 toTheDate:(NSString *) dateString2
{
    //    NSArray *timeArray1=[dateString1 componentsSeparatedByString:@"."];
    //    dateString1=[timeArray1 objectAtIndex:0];
    //    NSArray *timeArray2=[dateString2 componentsSeparatedByString:@"."];
    //    dateString2=[timeArray2 objectAtIndex:0];
    NSLog(@"%@.....%@",dateString1,dateString2);
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"HH:mm"];
    NSDate *d1=[date dateFromString:dateString1];
    NSTimeInterval late1=[d1 timeIntervalSince1970]*1;
    NSDate *d2=[date dateFromString:dateString2];
    NSTimeInterval late2=[d2 timeIntervalSince1970]*1;
    
    NSTimeInterval cha=late2-late1;
    int sen= 0 ;
    int hour = 0;
    int min = 0;
    sen = (int)cha%60;
    min = (int)cha/60%60;
    hour = (int)cha/3600;
    return [NSArray arrayWithObjects:@(hour),@(min),nil];
}
//比较两个时间的大小，> 0 说明 dataSring2 > dateString1
+(double)getIntervalTimeFromLastDate:(NSString *)dateString1 toTheDate:(NSString *) dateString2
{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"HH:mm"];
    NSDate *d1=[date dateFromString:dateString1];
    NSTimeInterval late1=[d1 timeIntervalSince1970]*1;
    NSDate *d2=[date dateFromString:dateString2];
    NSTimeInterval late2=[d2 timeIntervalSince1970]*1;
    
    NSTimeInterval cha=late2-late1;
    return cha;
}


//计算时间差防止按钮连续点击
+ (NSString*)getCurrentTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss:SSS"];
    NSString*timeString=[formatter stringFromDate: [NSDate date]];
    return timeString;
}



@end
