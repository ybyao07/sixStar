//
//  UtilConversion.m
//  HangingFurnace
//
//  Created by ybyao07 on 15/9/24.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "UtilConversion.h"

@implementation UtilConversion
//多个16进制字节转成十进制数
+(long)toDecimalFromHex:(NSString *)hexStr
{
//    NSArray *strArr = [hexStr componentsSeparatedByString:@"0x"];
//    NSMutableString *hexJoinString= [NSMutableString new];
//    [strArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        [hexJoinString appendString:obj];
//    }];
//    long num = 0;
//    num = [self numFromString:hexJoinString];
//    return num;
    long num = 0;
    num = [self numFromString:hexStr];
    return num;
}
//十六进制数转十进制数
+(long)numFromString:(NSString *)str
{
    long num = strtoul([str UTF8String], 0, 16);
    return num;
}


+(NSString *)stringFromHexCharacter:(NSString *)strChar{
    NSString *charStr;
    if ([strChar isEqualToString:@"f"] || [strChar isEqualToString:@"F"]) {
        charStr = @"1111";
    }else if ([strChar isEqualToString:@"e"] || [strChar isEqualToString:@"E"]){
        charStr = @"1110";
    }else if ([strChar isEqualToString:@"d"] || [strChar isEqualToString:@"D"]){
        charStr = @"1101";
    }else if ([strChar isEqualToString:@"c"] || [strChar isEqualToString:@"C"]){
        charStr = @"1100";
    }else if ([strChar isEqualToString:@"b"] || [strChar isEqualToString:@"B"]){
        charStr = @"1011";
    }else if ([strChar isEqualToString:@"a"] || [strChar isEqualToString:@"A"]){
        charStr = @"1010";
    }else if ([strChar isEqualToString:@"9"]){
        charStr = @"1001";
    }else if ([strChar isEqualToString:@"8"]){
        charStr = @"1000";
    }else if ([strChar isEqualToString:@"7"]){
        charStr = @"0111";
    }else if ([strChar isEqualToString:@"6"]){
        charStr = @"0110";
    }else if ([strChar isEqualToString:@"5"]){
        charStr = @"0101";
    }else if ([strChar isEqualToString:@"4"]){
        charStr = @"0100";
    }else if ([strChar isEqualToString:@"3"]){
        charStr = @"0011";
    }else if ([strChar isEqualToString:@"2"]){
        charStr = @"0010";
    }else if ([strChar isEqualToString:@"1"]){
        charStr = @"0001";
    }else if ([strChar isEqualToString:@"0"]){
        charStr = @"0000";
    }
    return charStr;
}


+(NSString *)toBinaryFromHex:(NSString *)strHex
{
    NSString *strResult = @"";
    NSDictionary *dictBinToHax = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"0000",@"0",
                                  @"0001",@"1",
                                  @"0010",@"2",
                                  @"0011",@"3",
                                  
                                  @"0100",@"4",
                                  @"0101",@"5",
                                  @"0110",@"6",
                                  @"0111",@"7",
                                  
                                  @"1000",@"8",
                                  @"1001",@"9",
                                  @"1010",@"A",
                                  @"1011",@"B",
                                  
                                  @"1100",@"C",
                                  @"1101",@"D",
                                  @"1110",@"E",
                                  @"1111",@"F", nil];
    
    for (int i = 0;i < [strHex length]; i+=1)
    {
        NSString *strBinaryKey = [strHex substringWithRange: NSMakeRange(i, 1)];
        strResult = [NSString stringWithFormat:@"%@%@",strResult,[dictBinToHax valueForKey:strBinaryKey]];
    }
    return  strResult;
}

+(NSString *)decimalToHex:(NSInteger)num
{
    NSString *nLetterValue;
    NSString *str =@"";
    uint16_t ttmpig;
    if (num < 16) {
        switch (num)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:
                nLetterValue = [NSString stringWithFormat:@"%ld",(long)num];
        }
        str = [str stringByAppendingString:@"0"];
        str = [str stringByAppendingString:nLetterValue];
    }else{
        for (int i = 0; i<9; i++) {
            ttmpig=num%16;
            num=num/16;
            switch (ttmpig)
            {
                case 10:
                    nLetterValue =@"A";break;
                case 11:
                    nLetterValue =@"B";break;
                case 12:
                    nLetterValue =@"C";break;
                case 13:
                    nLetterValue =@"D";break;
                case 14:
                    nLetterValue =@"E";break;
                case 15:
                    nLetterValue =@"F";break;
                default:
                    nLetterValue = [NSString stringWithFormat:@"%u",ttmpig];
            }
            str = [nLetterValue stringByAppendingString:str];
            if (num == 0) {
                break;
            }
        }
    }
    return str;
}

+(NSString *)decimalToTwoByteHex:(NSInteger)num
{
    NSString *nLetterValue;
    NSString *str =@"";
    NSString *hexStr=@"";
    uint16_t ttmpig;
    if (num < 16) {
        switch (num)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:
                nLetterValue = [NSString stringWithFormat:@"%ld",(long)num];
        }
        str = [str stringByAppendingString:@"000"];
        str = [str stringByAppendingString:nLetterValue];
        hexStr = str;
    }else{
        for (int i = 0; i<9; i++) {
            ttmpig=num%16;
            num=num/16;
            switch (ttmpig)
            {
                case 10:
                    nLetterValue =@"A";break;
                case 11:
                    nLetterValue =@"B";break;
                case 12:
                    nLetterValue =@"C";break;
                case 13:
                    nLetterValue =@"D";break;
                case 14:
                    nLetterValue =@"E";break;
                case 15:
                    nLetterValue =@"F";break;
                default:
                    nLetterValue = [NSString stringWithFormat:@"%u",ttmpig];
            }
            str = [nLetterValue stringByAppendingString:str];
            if (num == 0) {
                break;
            }
        }
    }
    if (str.length<4) {
        for (int i = 0; i< 4-str.length; i++) {
           hexStr = [hexStr stringByAppendingString:@"0"];
        }
        hexStr = [hexStr stringByAppendingString:str];
    }
    return hexStr;
}


+(NSString*)convertBin:(NSString *)bin
{
//    if ([bin length] > 16) {
//        
//        NSMutableArray *bins = [NSMutableArray array];
//        for (int i = 0;i < [bin length]; i += 16) {
//            [bins addObject:[bin substringWithRange:NSMakeRange(i, 16)]];
//        }
//        
//        NSMutableString *ret = [NSMutableString string];
//        for (NSString *abin in bins) {
//            [ret appendString:[UtilConversion convertBin:abin]];
//        }
//        return ret;
//    } else {
//        int value = 0;
//        for (int i = 0; i < [bin length]; i++) {
//            value += pow(2,i)*[[bin substringWithRange:NSMakeRange([bin length]-1-i, 1)] intValue];
//        }
//        return [NSString stringWithFormat:@"%X", value];
//    }
    
//     const char* cstr = [bin cStringUsingEncoding: NSASCIIStringEncoding];
//    
//    NSUInteger len = strlen(cstr);
//    const char* lastChar = cstr + len - 1;
//    NSUInteger curVal = 1;
//    NSUInteger result = 0;
//    
//    while (lastChar >= cstr) {
//        if (*lastChar == '1')
//        {
//            result += curVal;
//        }
//        /*
//         else
//         {
//         // Optionally add checks for correct characters here
//         }
//         */
//        lastChar--;
//        curVal <<= 1;
//    }
//    NSString *resultStr = [NSString stringWithFormat: @"%lx", result];
//    return resultStr;
    
    NSMutableString *convertingString = [[NSMutableString alloc] init];
    for (int x = 0; x < ([bin length]/4); x++) {
        int a = 0;
        int b = 0;
        int c = 0;
        int d = 0;
        
        NSString *A = [NSString stringWithFormat:@"%c", [bin characterAtIndex:(x*4+0)]];
        NSString *B = [NSString stringWithFormat:@"%c", [bin characterAtIndex:(x*4+1)]];
        NSString *C = [NSString stringWithFormat:@"%c", [bin characterAtIndex:(x*4+2)]];
        NSString *D = [NSString stringWithFormat:@"%c", [bin characterAtIndex:(x*4+3)]];
        
        
        if ([A isEqualToString:@"1"]) { a = 8;}
        
        if ([B isEqualToString:@"1"]) { b = 4;}
        
        if ([C isEqualToString:@"1"]) { c = 2;}
        
        if ([D isEqualToString:@"1"]) { d = 1;}
        
        int total = a + b + c + d;
        
        if (total < 10) { [convertingString appendFormat:@"%i",total]; }
        else if (total == 10) { [convertingString appendString:@"A"]; }
        else if (total == 11) { [convertingString appendString:@"B"]; }
        else if (total == 12) { [convertingString appendString:@"C"]; }
        else if (total == 13) { [convertingString appendString:@"D"]; }
        else if (total == 14) { [convertingString appendString:@"E"]; }
        else if (total == 15) { [convertingString appendString:@"F"]; } 
        
    }
    NSString *convertedHexString = convertingString;
    return convertedHexString;
}


@end
