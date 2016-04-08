//
//  ImageAddressUtil.m
//  AirPurifier
//
//  Created by bluE on 15-1-21.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "UtilImage.h"
#import "UIColor+Utility.h"
@implementation UtilImage

+(UIImage *)popviewImagePmValueLevel:(int)pmInt
{
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"air_quality%d",pmInt]];
    return image;
}
+(UIImage *)imageTextPmValueLevel:(int)pmInt
{
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"show_%d",pmInt]];
    return image;
}
+(UIImage *)imageIconPmValueLevel:(int)pmInt
{
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"show_%d_1",pmInt]];
    return image;
}
+(NSString *)imageStringTextPmValueLevel:(int)pmInt
{
    NSString *textStr=[NSString stringWithFormat:@"show_%d.png",pmInt];
    return textStr;
}
+(NSString *)imageStringIconPmValueLevel:(int)pmInt
{
    NSString *iconStr=[NSString stringWithFormat:@"show_%d_1.png",pmInt];
    return iconStr;
}
+(UIImage *)setMainView:(UIImageView *)view pmValueLevel :(int)pmInt
{
    UIImage *image;
    if (pmInt == 1){
        [view setBackgroundColor:[UIColor colorWithWhite:1 alpha:50.0/255]];
    }else if (pmInt == 2) {
        [view setBackgroundColor:[UIColor colorWithHex:0x5b3939 alpha:75.0/255]];
    }else if (pmInt == 3) {
        [view setBackgroundColor:[UIColor colorWithHex:0x5b3939 alpha:100.0/255]];
    } else if (pmInt == 4) {
        [view setBackgroundColor:[UIColor colorWithHex:0x5b3939 alpha:125.0/255]];
    }else if (pmInt == 5) {
         [view setBackgroundColor:[UIColor colorWithHex:0x5b3939 alpha:150.0/255]];
    }else{
         [view setBackgroundColor:[UIColor colorWithHex:0x5b3939 alpha:175.0/255]];
    }
    return image;
}





+(UIImage *)popviewImagePmValue:(int)pmInt
{
    UIImage *image;
    if (pmInt > -1 && pmInt < 50) {
        image = [UIImage imageNamed:@"air_quality1.png"];
    } else if (pmInt >= 50 && pmInt < 100) {
        image = [UIImage imageNamed:@"air_quality2.png"];
    } else if (pmInt >= 100 && pmInt < 150) {
        image = [UIImage imageNamed:@"air_quality3.png"];
    }else if (pmInt >= 150 && pmInt < 200) {
        image = [UIImage imageNamed:@"air_quality4.png"];
    }else if (pmInt >= 200 && pmInt < 300) {
        image = [UIImage imageNamed:@"air_quality5.png"];
    }else {
        image = [UIImage imageNamed:@"air_quality6.png"];
    }
    return image;
}
+(UIImage *)imageTextPmValue:(int)pmInt
{
    UIImage *image;
    if (pmInt > -1 && pmInt < 50){
        image = [UIImage imageNamed:@"show_1.png"];
    }else if (pmInt >= 50 && pmInt < 100) {
        image = [UIImage imageNamed:@"show_2.png"];
    }else if (pmInt >= 100 && pmInt < 150) {
        image = [UIImage imageNamed:@"show_3.png"];
    } else if (pmInt >= 150 && pmInt < 200) {
        image = [UIImage imageNamed:@"show_4.png"];
    }else if (pmInt >= 200 && pmInt < 300) {
        image = [UIImage imageNamed:@"show_5.png"];
    }else{
        image = [UIImage imageNamed:@"show_6.png"];
    }
    return image;
}
+(UIImage *)imageIconPmValue:(int)pmInt
{
    UIImage *image;
    if (pmInt > -1 && pmInt < 50){
        image = [UIImage imageNamed:@"show_1_1.png"];
    }else if (pmInt >= 50 && pmInt < 100) {
        image = [UIImage imageNamed:@"show_2_1.png"];
    }else if (pmInt >= 100 && pmInt < 150) {
        image = [UIImage imageNamed:@"show_3_1.png"];
    } else if (pmInt >= 150 && pmInt < 200) {
        image = [UIImage imageNamed:@"show_4_1.png"];
    }else if (pmInt >= 200 && pmInt < 300) {
        image = [UIImage imageNamed:@"show_5_1.png"];
    }else{
        image = [UIImage imageNamed:@"show_6_1.png"];
    }
    return image;
}
+(NSString *)imageStringTextPmValue:(int)pmInt
{
    NSString *textStr;
    if (pmInt > -1 && pmInt < 50){
        textStr =@"show_1.png";
    }else if (pmInt >= 50 && pmInt < 100) {
        textStr =@"show_2.png";
    }else if (pmInt >= 100 && pmInt < 150) {
        textStr =@"show_3.png";
    } else if (pmInt >= 150 && pmInt < 200) {
        textStr =@"show_4.png";
    }else if (pmInt >= 200 && pmInt < 300) {
        textStr =@"show_5.png";
    }else{
        textStr =@"show_6.png";
    }
    return textStr;
}
+(NSString *)imageStringIconPmValue:(int)pmInt
{
    NSString *iconStr;
    if (pmInt > -1 && pmInt < 50){
        iconStr =@"show_1_1.png";
    }else if (pmInt >= 50 && pmInt < 100) {
        iconStr =@"show_2_1.png";
    }else if (pmInt >= 100 && pmInt < 150) {
        iconStr =@"show_3_1.png";
    } else if (pmInt >= 150 && pmInt < 200) {
        iconStr =@"show_4_1.png";
    }else if (pmInt >= 200 && pmInt < 300) {
        iconStr =@"show_5_1.png";
    }else{
        iconStr =@"show_6_1.png";
    }
    return iconStr;
}
+(UIImage *)setMainView:(UIImageView *)view pmValue :(int)pmInt
{
    UIImage *image;
    if (pmInt > -1 && pmInt < 50){
        [view setBackgroundColor:[UIColor colorWithWhite:1 alpha:50.0/255]];
    }else if (pmInt >= 50 && pmInt < 100) {
        [view setBackgroundColor:[UIColor colorWithHex:0x5b3939 alpha:75.0/255]];
    }else if (pmInt >= 100 && pmInt < 150) {
        [view setBackgroundColor:[UIColor colorWithHex:0x5b3939 alpha:100.0/255]];
    } else if (pmInt >= 150 && pmInt < 200) {
        [view setBackgroundColor:[UIColor colorWithHex:0x5b3939 alpha:125.0/255]];
    }else if (pmInt >= 200 && pmInt < 300) {
        [view setBackgroundColor:[UIColor colorWithHex:0x5b3939 alpha:150.0/255]];
    }else{
        [view setBackgroundColor:[UIColor colorWithHex:0x5b3939 alpha:175.0/255]];
    }
    return image;
}




@end
