//
//  PlistManager.m
//  AirPurifier
//
//  Created by bluE on 14-9-22.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import "PlistManager.h"

static NSArray *modeType;
static NSArray *timeType;
static NSArray *windType;
static NSArray *modeA300Type;
@implementation PlistManager

+(id)shareInstance {
    static dispatch_once_t onceToken;
    static id sharedInstance;
    dispatch_once(&onceToken, ^{
    NSString *pathMode = [[NSBundle mainBundle] pathForResource:@"mode" ofType:@"plist"];
    modeType = [NSArray arrayWithContentsOfFile:pathMode];
    NSString *path300Mode = [[NSBundle mainBundle] pathForResource:@"mode300" ofType:@"plist"];
    modeA300Type = [NSArray arrayWithContentsOfFile:path300Mode];
    NSString *pathTime = [[NSBundle mainBundle] pathForResource:@"time" ofType:@"plist"];
    timeType = [NSArray arrayWithContentsOfFile:pathTime];
    NSString *pathWind = [[NSBundle mainBundle]pathForResource:@"wind" ofType:@"plist"];
    windType = [NSArray arrayWithContentsOfFile:pathWind];
    sharedInstance = [[self alloc] init];
});
    return sharedInstance;
}
-(NSArray *)getModeTypes
{
    return modeType;
}
-(NSArray *)getA300ModeTypes
{
    return modeA300Type;
}
-(NSArray *)getTimeTypes
{
    return timeType;
}
-(NSArray *)getWindTypes
{
    return windType;
}

@end
