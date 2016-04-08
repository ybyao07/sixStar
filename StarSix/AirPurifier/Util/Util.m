//
//  Util.m
//  AirPurifier
//
//  Created by bluE on 15-1-19.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "Util.h"
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#include "base64.h"
#import <Social/Social.h>


#define PRIVATE_KEY     @"4f1175_SmartWeatherAPI_c0658a1"
#define APPID   @"0bd4a721194e81d3"
#define TYPE    @"observe"


@implementation Util
+(NSString *)getSetWeatherRequesByAreaid:(NSString *)areaid
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];//注意日期的格式
    NSString *date = [[dateFormatter stringFromDate:[NSDate date]] substringToIndex:12];//用到的精确到分，24小时制60分钟制
    NSString *publicKey=[Util getPublicKey:areaid type:@"observe" date:date appid:APPID];
    NSString *_key = [Util hmacsha1:publicKey key:PRIVATE_KEY];
    NSString *key = [Util stringByEncodingURLFormat:_key];
    NSString *request =[Util getAPI:areaid type:TYPE date:date appid:APPID key:key];
    return request;
}

+(NSString *)getSetPmRequesByLocation:(NSString *)location
{
    NSString *AppKey = @"ywZSKVxkFceeZXUZ4JBy";
    NSString *stations = @"no";
    NSString *avg = @"true";
    return  [NSString stringWithFormat:@"http://www.pm25.in/api/querys/pm2_5.json?city=%@&token=%@&stations=%@&avg=%@",location,AppKey,stations,avg];
}
#pragma  mark  CallBackGetWeather API
+ (NSString*) getPublicKey:(NSString*)areaid type:(NSString*)type date:(NSString*)date appid :(NSString*)appid
{
    NSString *Key = [[NSString alloc] initWithFormat:@"http://open.weather.com.cn/data/?areaid=%@&type=%@&date=%@&appid=%@", areaid, type, [date substringToIndex:12], appid];
    return Key;
}
#pragma mark 对publickey和privatekey进行加密
//对publickey和privatekey进行加密
+ (NSString *)hmacsha1:(NSString *)public_Key key:(NSString *)private_key {
    NSData *secretData = [private_key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *clearTextData = [public_Key dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[20];
    CCHmac(kCCHmacAlgSHA1, [secretData bytes], [secretData length], [clearTextData bytes], [clearTextData length], result);
    char base64Result[32];
    size_t theResultLength = 32;
    Base64EncodeData(result, 20, base64Result, &theResultLength,YES);
    NSData *theData = [NSData dataWithBytes:base64Result length:theResultLength];
    NSString *base64EncodedResult = [[NSString alloc] initWithData:theData encoding:NSASCIIStringEncoding];
    return base64EncodedResult;
}

//将获得的key进性urlencode操作
+(NSString *)stringByEncodingURLFormat:(NSString*)_key{
    NSString *encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)_key, nil, (CFStringRef) @"!$&'()*+,-./:;=?@_~%#[]", kCFStringEncodingUTF8);
    //由于ARC的存在，这里的转换需要添加__bridge，原因我不明。求大神讲解
    return encodedString;
}

//获得完整的API
+ (NSString*) getAPI:(NSString*)areaid type:(NSString*)type date:(NSString*)date appid:(NSString*)appid key:(NSString*)key {
    NSString *API = [[NSString alloc] initWithFormat:@"http://open.weather.com.cn/data/?areaid=%@&type=%@&date=%@&appid=%@&key=%@", areaid, type, [date substringToIndex:12], [appid substringToIndex:6], key];
    //-------------这里需要主要的是只需要appid的前6位！！！
    return API;
}


+(NSString *)getNumber:(NSString *)str
{
    //    NSRange range = [str rangeOfString:@"^[0-9]\d*$" options:NSRegularExpressionSearch];
    //    if (range.location != NSNotFound) {
    //        NSLog(@"---风速为-%@-级别",[str substringWithRange:range]);
    //        return [str substringWithRange:range];
    //    }
    //    else{
    //        return @"0";
    //    }
    
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
    DDLogCVerbose(@"timeInterval=%lf",timeDiff);
    return timeDiff;
}
+(void)storeCurrentTime
{
    NSString *curTime = [self GetCurTime];
    [UserDefault setObject:curTime forKey:CurrentTime];
}





@end
