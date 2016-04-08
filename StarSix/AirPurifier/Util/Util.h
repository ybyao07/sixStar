//
//  Util.h
//  AirPurifier
//
//  Created by bluE on 15-1-19.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

+(NSString *)getSetWeatherRequesByAreaid:(NSString *)areaId;
+(NSString *)getSetPmRequesByLocation:(NSString *)location;

+ (NSString*) getPublicKey:(NSString*)areaid type:(NSString*)type date:(NSString*)date appid :(NSString*)appid;
+ (NSString *)hmacsha1:(NSString *)public_Key key:(NSString *)private_key;
+(NSString *)stringByEncodingURLFormat:(NSString*)_key;
+ (NSString*) getAPI:(NSString*)areaid type:(NSString*)type date:(NSString*)date appid:(NSString*)appid key:(NSString*)key ;

//提取字符串中的数字
+(NSString *)getNumber:(NSString *)str;

//禁止输入表情符号
//+ (NSString *)disable_emoji:(NSString *)text;

/**
 *  防止按钮多次点击
 *
 *  @return 
 */
+ (NSString*)GetCurTime;
+ (double)GetStringTimeDiff:(NSString*)timeS timeE:(NSString*)timeE;
+(void)storeCurrentTime;



@end
