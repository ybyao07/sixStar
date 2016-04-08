//
//  CurrentWeather.h
//  AirPurifier
//
//  Created by bluE on 15-1-19.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentWeather : NSObject

@property (nonatomic,strong) NSString *temp;
@property (nonatomic,strong) NSString *hum;

-(CurrentWeather *)initWithTempreture:(NSString *)t humidity:(NSString *)h;
@end
