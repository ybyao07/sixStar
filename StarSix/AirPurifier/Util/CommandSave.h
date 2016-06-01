//
//  CommandSave.h
//  WebAirpal
//
//  Created by ybyao07 on 16/3/23.
//  Copyright © 2016年 skyware. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  保存发送指令
 */
@interface CommandSave : NSObject <NSCoding>

@property (nonatomic,copy) NSString *mac;  //设备mac
@property (nonatomic,copy) NSString *cmdCode; //指令
@property (nonatomic,copy) NSString *time; //时间


+(CommandSave *)readCommandSave;

+(void)writeCommandSave:(CommandSave *)cmd;

@end
