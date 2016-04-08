//
//  ImageAddressUtil.h
//  AirPurifier
//
//  Created by bluE on 15-1-21.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UtilImage : NSObject

/**
 *  室内根据PmLevel来计算
 *
 */
+(UIImage *)popviewImagePmValueLevel:(int)pmInt;
+(UIImage *)imageTextPmValueLevel:(int)pmInt;
+(UIImage *)imageIconPmValueLevel:(int)pmInt;
+(NSString *)imageStringTextPmValueLevel:(int)pmInt;
+(NSString *)imageStringIconPmValueLevel:(int)pmInt;

+(UIImage *)setMainView:(UIImageView *)view pmValueLevel :(int)pmInt;
/**
 *  室外按照PMValue来计算
 */
+(UIImage *)popviewImagePmValue:(int)pmInt;
+(UIImage *)imageTextPmValue:(int)pmInt;
+(UIImage *)imageIconPmValue:(int)pmInt;
+(NSString *)imageStringTextPmValue:(int)pmInt;
+(NSString *)imageStringIconPmValue:(int)pmInt;

+(UIImage *)setMainView:(UIImageView *)view pmValue:(int)pmInt;



@end
