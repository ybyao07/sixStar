//
//  CityDataHelper.h
//  AirPurifier
//
//  Created by bluE on 14-8-18.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kCityID         @"CityID"
#define kCityName       @"CityName"
#define kCityNameEN     @"CityNameEN"
#define kProvinceName     @"ProvinceName"
#define kDistrict @"DistrictName"

@interface CityDataHelper : NSObject
+ (NSArray *)cityArray;
+ (void)updateSelectedCity:(NSDictionary *)city;
+ (NSDictionary *)selectedCity;
+ (void)removeSelectedCity;
+ (NSString *)cityIDOfSelectedCity;
//+ (NSString *)cityIDOfLocationName:(NSString *)cityName;
+ (NSString *)cityNameOfSelectedCity;
+ (NSDictionary *)cityOfLocationName:(NSString *)cityName;
//+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end
