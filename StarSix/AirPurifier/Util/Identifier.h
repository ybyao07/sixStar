//
//  Identifier.h
//  AirPurifier
//
//  Created by bluE on 14-8-20.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Identifier : NSObject
+(void)getIndentifier:(NSURL *)URLString phoneNumber:(NSString *)PhoneNumber;

+(void)getCodeAgain:(NSString *)phoneNumber onView:(UIView *)view;
@end
