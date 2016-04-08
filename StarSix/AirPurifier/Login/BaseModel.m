//
//  BaseModel.m
//  AirPurifier
//
//  Created by ybyao07 on 15/4/2.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "BaseModel.h" 

@implementation BaseModel
-(instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype)baseModelWithDic:(NSDictionary *)dic
{
    return [[self alloc] initWithDic:dic];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
