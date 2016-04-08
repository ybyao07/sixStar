//
//  UtilConversion.h
//  HangingFurnace
//
//  Created by ybyao07 on 15/9/24.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UtilConversion : NSObject
/**
 *  将16进制的字符串转成十进制的数字 带0x开头
 *  eg. 0100--->256
 *  @param hexStr 16进制字符串  eg.0x0210
 *
 *  @return 十进制数
 */
+(long)toDecimalFromHex:(NSString *)hexStr;
/**
 *  将十六进制的字符 转成二进制字符
 *  eg.'F' 转成“1111”
 *  @param strChar 十六进制的字符
 *
 *  @return 二进制的字符串
 */
+(NSString *)stringFromHexCharacter:(NSString *)strChar;

/**
 *  将16进制字符串，转成二进制字符串
 *
 *  @param strHex @"7fefff78"
 *
 *  @return @"1111111111011111111111101111000"
 */
+(NSString *)toBinaryFromHex:(NSString *)strHex;

/**
 *  将16进制的字符串转成十进制的数字
 *  eg. 0100--->256
 *  @param hexStr 16进制字符串  eg.0210  不包含0x
 *
 *  @return 十进制数
 */
+(long)numFromString:(NSString *)str;


/**
 *  返回无符号整形转16进制
 *
 *  @param num 无符号整形
 *
 *  @return 十六进制的String
 */
+(NSString *)decimalToHex:(NSInteger)num;

/**
 *  返回16进制（2个字节，如果不够，补充完整
 *
 *  @param num 无符号整形
 *
 *  @return 十六进制的String
 */

+(NSString *)decimalToTwoByteHex:(NSInteger)num;

/**
 *  将二进制字符串转为 16进制字符串
 *
 *  @param bin @“0000001011001101”
 *
 *  @return @“02CD”
 */
+(NSString*)convertBin:(NSString *)bin;



@end
