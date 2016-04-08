//
//  NSString+IsValidCharNumber.m
//  AirPurifier
//
//  Created by ybyao07 on 15/11/20.
//  Copyright © 2015年 skyware. All rights reserved.
//

#import "NSString+IsValidCharNumber.h"

#define kAlphaNum @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"


@implementation NSString (IsValidCharNumber)


- (BOOL)validateCharNumber{
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:kAlphaNum];
    int i = 0;
    while (i < self.length) {
        NSString * string = [self substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

-(BOOL)isCharNumberString
{
    NSString *mobile = @"^[A-Za-z0-9]+$";
    NSPredicate *regexMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobile];
    if ([regexMobile evaluateWithObject:self])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


@end
