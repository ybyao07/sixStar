//
//  CityDataHelper.m
//  AirPurifier
//
//  Created by bluE on 14-8-18.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import "CityDataHelper.h"
#define kCitiesPlistFileName    @"Cities.plist"

#define kCityIDBeijing          @"101010100"
#define kCityNameBeijing        @"北京"

@implementation CityDataHelper

+ (NSArray *)cityArray
{
    NSString *filePath = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), kCitiesPlistFileName];
    NSArray *cities = nil;
    BOOL fileExisted = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (!fileExisted)
    {
        cities = [CityDataHelper readCitysTextFile];
        BOOL succeeded = [cities writeToFile:filePath atomically:YES];
        if (!succeeded)
        {
            DDLogError(@"Failed to write to file: %@", filePath);
        }
    }
    else
    {
//        DDLogInfo(@"%@ exists", filePath);
        cities = [[NSArray alloc] initWithContentsOfFile:filePath];
    }
    return cities;
}

+ (NSArray *)readCitysTextFile
{
    NSError *error = nil;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"citys" ofType:@"txt"];
    NSString *fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if (error)
    {
        DDLogError(@"%@", error);
        return nil;
    }
    NSArray *lines = [fileContent componentsSeparatedByString:@"\n"];
    NSMutableArray *cities = [[NSMutableArray alloc] initWithCapacity:10];
    for (NSString *line in lines)
    {
        NSArray *items = [line componentsSeparatedByString:@","];
        if (items.count < 10) {
            continue;
        }
        NSMutableDictionary *city = [NSMutableDictionary dictionaryWithCapacity:4];
        city[kCityID] = items[0];
        city[kCityName] = items[4];
        city[kProvinceName] = items[6];
        city[kCityNameEN] = items[3];
        
        //这里只加入到市一级
        NSString *enCityName = items[1];
        if ([city[kCityNameEN]  isEqualToString:enCityName]) {
            [cities addObject:city];
        }
    }
    DDLogInfo(@"Cities (%d):\n%@", cities.count, cities);
    return cities;
}

+ (void)updateSelectedCity:(NSDictionary *)city
{
//    DDLogFunction();
    if (!city) return;
    [[NSUserDefaults standardUserDefaults] setObject:city forKey:kSelectedCity];
}


+ (NSDictionary *)selectedCity
{
    //    DDLogFunction();
    NSDictionary *city = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kSelectedCity];
    //    DDLogInfo(@"Selected city: %@", city);
    NSLog(@"ybyao-----Selected city:%@",city);
    return city;
}
+ (void)removeSelectedCity
{
//    DDLogFunction();
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSelectedCity];
}


+ (NSString *)cityIDOfSelectedCity
{
    NSDictionary *city = [CityDataHelper selectedCity];
    if (!city) return kCityIDBeijing;
    return city[kCityID];
}

//通过cityName找到ID
//+ (NSString *)cityIDOfLocationName:(NSString *)cityName
//{
//    if (!cityName) return kCityIDBeijing;
//    NSString *cityId;
//    NSArray * cities = [CityDataHelper readCitysTextFile];
//    for (int i=0; i<[cities count]; i++) {
//    NSMutableDictionary *city = [cities objectAtIndex:i];
////        NSArray *currentCity = [city allKeysForObject:cityName];
//        for (int j = 0; j<=[[city allKeys]count]-1; j++) {
//            if ([[city objectForKey:[[city allKeys]objectAtIndex:j]] isEqual:cityName]) {
//                cityId = city[kCityID];
//            }
//        }
//       }
//    if (!cityId) {
//        return kCityIDBeijing;
//    }
//    return cityId;
//}

//通过cityName找到对应的城市信息
+ (NSDictionary *)cityOfLocationName:(NSString *)cityName
{
    if (!cityName) return nil;
    NSString *cityId;
    NSArray * cities = [CityDataHelper readCitysTextFile];
    for (int i=0; i<[cities count]; i++) {
        NSDictionary *city = [cities objectAtIndex:i];
        //        NSArray *currentCity = [city allKeysForObject:cityName];
        for (int j = 0; j<=[[city allKeys]count]-1; j++) {
            if ([[city objectForKey:[[city allKeys]objectAtIndex:j]] isEqual:cityName]) {
                return city;
            }
        }
    }
    if (!cityId) {
        return nil;
    }
    return nil;
}

+ (NSString *)cityNameOfSelectedCity
{
    NSDictionary *city = [CityDataHelper selectedCity];
    if (!city) return kCityNameBeijing;
    return [NSString stringWithFormat:@"%@",city[kCityName]];
}

@end
