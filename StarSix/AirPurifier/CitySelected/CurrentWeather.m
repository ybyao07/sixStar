//
//  CurrentWeather.m
//  AirPurifier
//
//  Created by bluE on 15-1-19.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "CurrentWeather.h"

@implementation CurrentWeather

@synthesize temp;
@synthesize hum;

-(CurrentWeather *)initWithTempreture:(NSString *)t humidity:(NSString *)h
{
      if (self = [super init]) {
          temp = t;
          hum = h;
      }
    return self;
}
@end
