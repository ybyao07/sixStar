//
//  BaseModel.h
//  AirPurifier
//
//  Created by ybyao07 on 15/4/2.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

-(instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)baseModelWithDic:(NSDictionary *)dic;

@end
