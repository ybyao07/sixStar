//
//  DeviceVo.m
//  AirPurifier
//
//  Created by bluE on 14-8-29.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import "DeviceVo.h"
#import "JSON.h"

@implementation DeviceVo

//@synthesize currentWeather;
//@synthesize currentOutPm;

-(DeviceVo *)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        self.deviceId = [dic[@"device_id"] isEqual:[NSNull null]] ? @"":dic[@"device_id"];
        self.deviceMac = [dic[@"device_mac"] isEqual:[NSNull null]] ? @"":dic[@"device_mac"];
        self.deviceMcuVersion = [dic[@"device_mcu_version"] isEqual:[NSNull null]]?@"":dic[@"device_mcu_version"];
        self.deviceSn =[dic[@"device_sn"] isEqual:[NSNull null]] ? @"":dic[@"device_sn"];
        self.deviceName=[dic[@"device_name"] isEqual:[NSNull null]] ? @"":dic[@"device_name"];
        self.deviceAddTime =[dic[@"add_time"] isEqual:[NSNull null]] ? @"":dic[@"add_time"];
        if ([dic objectForKey:@"device_data"]) {
            NSString *strData = dic[@"device_data"][@"bin"];
            NSData* dataFromString;
            if (!isEmptyString(strData)) {
                 dataFromString = [[NSData alloc] initWithBase64EncodedString:strData options:0];//base64解码
            }
            Byte *bytes = (Byte *)[dataFromString bytes];
            NSString *hexStr=@"";
            for(int i=0;i<[dataFromString length];i++)
            {
                NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
                if([newHexStr length]==1)
                    hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
                else
                    hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
            }
            self.deviceData = [[DeviceData alloc] initWithBase64String:hexStr];
#warning test--start
//                NSString *testData = @"EAEgBiEDMQoyAmwzAa40AD5BAEIAQwNEHkUH0FAUUQAAAABSAAAAAFMAAAAAYQPoYgNxAHNyABtzAA10AAF1Ahx2AAV3ADUBB9gBAwUBDwAAYwAK";
//                NSData* dataFromString = [[NSData alloc] initWithBase64EncodedString:testData options:0];//base64解码
//                Byte *bytes = (Byte *)[dataFromString bytes];
//                NSString *hexStr=@"";
//                for(int i=0;i<[dataFromString length];i++)
//                {
//                    NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
//                    if([newHexStr length]==1)
//                        hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
//                    else
//                        hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
//                }
//                self.deviceData = [[DeviceData alloc] initWithBase64String:hexStr];
#warning test--end
            
        }
        else{
            self.deviceData = [[DeviceData alloc] init];
        }
        self.deviceDesc3=[dic[@"deviceDesc3"] isEqual:[NSNull null]] ? @"":dic[@"deviceDesc3"];
        self.deviceOnline =[dic[@"device_online"] isEqual:[NSNull null]] ? @"":dic[@"device_online"];
        self.deviceAddress=[dic[@"device_address"] isEqual:[NSNull null]] ? @"":dic[@"device_address"];
        self.deviceLock=[dic[@"device_lock"] isEqual:[NSNull null]] ? @"":dic[@"device_lock"];
        
        self.deviceCity =[dic[@"city"] isEqual:[NSNull null]] ? @"":dic[@"city"];
        self.deviceProvince =[dic[@"province"] isEqual:[NSNull null]] ? @"":dic[@"province"];
        self.deviceAreaId = [dic[@"area_id"] isEqual:[NSNull null]] ? @"":dic[@"area_id"];
        self.deviceDistrict=[dic[@"district"] isEqual:[NSNull null]] ? @"":dic[@"district"];
        
        self.productId = [dic[@"product_id"] isEqual:[NSNull null]] ?@"":dic[@"product_id"];
        self.devicePmv =[dic[@"pmv"] isEqual:[NSNull null]] ? @"":dic[@"pmv"];
        
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    DeviceVo *copy = [[[self class] allocWithZone:zone] init];
    copy.deviceId = [self.deviceId copyWithZone:zone];
    copy.deviceMac = [self.deviceMac copyWithZone:zone];
    copy.deviceSn = [self.deviceSn copyWithZone:zone];
    copy.deviceName = [self.deviceName copyWithZone:zone];
    
    copy.deviceDesc3 = [self.deviceDesc3 copyWithZone:zone];
    copy.deviceOnline = [self.deviceOnline copyWithZone:zone];
    copy.deviceLock = [self.deviceLock copyWithZone:zone];
    copy.deviceAddress = [self.deviceAddress copyWithZone:zone];
    copy.deviceCity = [self.deviceCity copyWithZone:zone];
   
    copy.deviceProvince = [self.deviceProvince copyWithZone:zone];
    copy.deviceAreaId = [self.deviceAreaId copyWithZone:zone];
    copy.deviceDistrict = [self.deviceDistrict copyWithZone:zone];
    copy.devicePmv = [self.devicePmv copyWithZone:zone];
    return copy;
}





@end
