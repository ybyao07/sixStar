//
//  NSString+IsValidCharNumber.h
//  AirPurifier
//
//  Created by ybyao07 on 15/11/20.
//  Copyright © 2015年 skyware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (IsValidCharNumber)

/**
 *  检验输入的字符串是否只有数字或者字母
 *
 *  @param charNumberStr 输入的字符串
 *
 *  @return 是否只有数字或字符
 */
- (BOOL)validateCharNumber;


/**
 *  输入字符串是否只有数字或字母
 *
 *  @param string
 *
 *  @return 
 */
-(BOOL)isCharNumberString;


@end
