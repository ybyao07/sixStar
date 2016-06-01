//
//  Util.m
//  AirPurifier
//
//  Created by bluE on 15-1-19.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "Util.h"
#define CurrentTime @"currentTime"


@implementation Util
+(NSString *)getNumber:(NSString *)str
{
    NSScanner *scanner = [NSScanner scannerWithString:str];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
    int number;
    [scanner scanInt:&number];
    if (number > 0 ) {
        return [NSString stringWithFormat:@"%d",number];
    }
    else{
        return @"0";
    }
}


//禁止输入表情符号
+ (NSString *)disable_emoji:(NSString *)text
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}

//计算时间差防止按钮连续点击
+ (NSString*)GetCurTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss:SSS"];
    NSString*timeString=[formatter stringFromDate: [NSDate date]];
    return timeString;
}


+ (double)GetStringTimeDiff:(NSString*)timeS timeE:(NSString*)timeE
{
    double timeDiff = 0.0;
    NSDateFormatter *formatters = [[NSDateFormatter alloc] init];
    [formatters setDateFormat:@"yyyy/MM/dd HH:mm:ss:SSS"];
    NSDate *dateS = [formatters dateFromString:timeS];
    
    NSDateFormatter *formatterE = [[NSDateFormatter alloc] init];
    [formatterE setDateFormat:@"yyyy/MM/dd HH:mm:ss:SSS"];
    NSDate *dateE = [formatterE dateFromString:timeE];
    timeDiff = [dateE timeIntervalSinceDate:dateS ];
    return timeDiff;
}
+(void)storeCurrentTime
{
    NSString *curTime = [self GetCurTime];
    [[NSUserDefaults standardUserDefaults] setObject:curTime forKey:CurrentTime];
}





@end
