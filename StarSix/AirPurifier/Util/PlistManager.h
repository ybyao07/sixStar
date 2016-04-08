//
//  PlistManager.h
//  AirPurifier
//
//  Created by bluE on 14-9-22.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlistManager : NSObject
+(id)shareInstance;

-(NSArray *)getModeTypes;
-(NSArray *)getA300ModeTypes;
-(NSArray *)getTimeTypes;
-(NSArray *)getWindTypes;
@end
