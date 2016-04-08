//
//  DeviceData.m
//  AirPurifier
//
//  Created by bluE on 15-1-16.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "DeviceData.h"
#import "UtilConversion.h"
@implementation DeviceData

static const long  kLength = 2;
static const long  valueLengthStep = 2;
-(instancetype)initWithBase64String:(NSString *)base64String
{
    self = [super init];
    if (self ) {
        [self initObjectModel];
        NSString *cmdKey;
        NSString *cmdValue;
        long loctionStar=0; //命令值的起始位置
        long lengthValue=2; //命令值的长度
        for (loctionStar =0; loctionStar < base64String.length; ) {
            cmdKey = [base64String substringWithRange:NSMakeRange(loctionStar, kLength)]; //所有的key都是2个字符
            if ([cmdKey isEqualToString:@"10"]) {//开关机 - 1字节
                lengthValue = valueLengthStep;
                loctionStar+=kLength;
                cmdValue = [base64String substringWithRange:NSMakeRange(loctionStar, lengthValue)];
                [self setCmdPower:cmdValue];
            } else if ([cmdKey isEqualToString:@"75"]){//CO2当前值 - 2字节
                lengthValue = valueLengthStep*2;
                loctionStar+=kLength;
                cmdValue = [base64String substringWithRange:NSMakeRange(loctionStar, lengthValue)];
                [self setCmdCO2Density:cmdValue];
            }else if ([cmdKey isEqualToString:@"31"]){//风机频率 - 1字节
                lengthValue = valueLengthStep;
                loctionStar+=kLength;
                cmdValue = [base64String substringWithRange:NSMakeRange(loctionStar, lengthValue)];
                [self setCmdFanFrequency:cmdValue];
            }else if ([cmdKey isEqualToString:@"20"]){//智能模式设置 - 1字节
                lengthValue = valueLengthStep;
                loctionStar+=kLength;
                cmdValue = [base64String substringWithRange:NSMakeRange(loctionStar, lengthValue)];
                [self setCmdFanModel:cmdValue];
            }else if ([cmdKey isEqualToString:@"50"]){//定时模式 - 1字节
                lengthValue = valueLengthStep;
                loctionStar+=kLength;
                cmdValue = [base64String substringWithRange:NSMakeRange(loctionStar, lengthValue)];
                [self setCmdTimeModel:cmdValue];
            }else if ([cmdKey isEqualToString:@"51"]){//定时器1设置 - 4字节
                lengthValue = valueLengthStep*4;
                loctionStar+=kLength;
                cmdValue = [base64String substringWithRange:NSMakeRange(loctionStar, lengthValue)];
                [self setCmdOneTimer:cmdValue];
            }else if ([cmdKey isEqualToString:@"52"]){//定时器2设置 - 4 字节
                lengthValue = valueLengthStep*4;
                loctionStar+=kLength;
                cmdValue = [base64String substringWithRange:NSMakeRange(loctionStar, lengthValue)];
                [self setCmdTwoTimer:cmdValue];
            }else if ([cmdKey isEqualToString:@"53"]){//定时器3设置 - 4字节
                lengthValue = valueLengthStep*4;
                loctionStar+=kLength;
                cmdValue = [base64String substringWithRange:NSMakeRange(loctionStar, lengthValue)];
                [self setCmdThreeTimer:cmdValue];
            }else if ([cmdKey isEqualToString:@"61"]){//CO2调节值 - 2 字节
                lengthValue = valueLengthStep*2;
                loctionStar+=kLength;
                cmdValue = [base64String substringWithRange:NSMakeRange(loctionStar, lengthValue)];
                [self setCmdFunModelCO2:cmdValue];
            }else if ([cmdKey isEqualToString:@"63"]){//PM调节值 -2字节
                lengthValue = valueLengthStep*2;
                loctionStar+=kLength;
                cmdValue = [base64String substringWithRange:NSMakeRange(loctionStar, lengthValue)];
                [self setCmdFunModelPM:cmdValue];
            }else if ([cmdKey isEqualToString:@"71"]){//室内温度 -2 字节
                lengthValue = valueLengthStep*2;
                loctionStar+=kLength;
                cmdValue = [base64String substringWithRange:NSMakeRange(loctionStar, lengthValue)];
                [self setCmdInsideTem:cmdValue];
            }else if ([cmdKey isEqualToString:@"72"]){//室外温度 -2 字节
                lengthValue = valueLengthStep*2;
                loctionStar+=kLength;
                cmdValue = [base64String substringWithRange:NSMakeRange(loctionStar, lengthValue)];
                [self setCmdOutsideTem:cmdValue];
            }else if ([cmdKey isEqualToString:@"76"]){//室内颗粒物浓度 -2 字节
                lengthValue = valueLengthStep*2;
                loctionStar+=kLength;
                cmdValue = [base64String substringWithRange:NSMakeRange(loctionStar, lengthValue)];
                [self setCmdInsidePm:cmdValue];
            }else if ([cmdKey isEqualToString:@"77"]){//室外颗粒物浓度 -2 字节
                lengthValue = valueLengthStep*2;
                loctionStar+=kLength;
                cmdValue = [base64String substringWithRange:NSMakeRange(loctionStar, lengthValue)];
                [self setCmdOutsidePm:cmdValue];
            }else if ([cmdKey isEqualToString:@"34"]){//当前风量 -2 字节
                lengthValue = valueLengthStep*2;
                loctionStar+=kLength;
                cmdValue = [base64String substringWithRange:NSMakeRange(loctionStar, lengthValue)];
                [self setCmdFanRotateSpeed:cmdValue];
            }else if ([cmdKey isEqualToString:@"45"]){//除尘器清洗周期 - 2 字节
                lengthValue = valueLengthStep*2;
                loctionStar+=kLength;
                cmdValue = [base64String substringWithRange:NSMakeRange(loctionStar, lengthValue)];
                [self setCmdFilterRemain:cmdValue];
            }
            //暂时未用到的
            else if ([cmdKey isEqualToString:@"21"]){//背光时间 - 1字节
                lengthValue = valueLengthStep;
                loctionStar+=kLength;
                cmdValue = [base64String substringWithRange:NSMakeRange(loctionStar, lengthValue)];
            }else if ([cmdKey isEqualToString:@"32"]){//送风机转速 - 2字节
                lengthValue = valueLengthStep*2;
                loctionStar+=kLength;
                cmdValue = [base64String substringWithRange:NSMakeRange(loctionStar, lengthValue)];
            }else if ([cmdKey isEqualToString:@"33"]){//排风机转速 - 2字节
                lengthValue = valueLengthStep*2;
                loctionStar+=kLength;
                cmdValue = [base64String substringWithRange:NSMakeRange(loctionStar, lengthValue)];
            }else if ([cmdKey isEqualToString:@"41"]){//融冰启动温度 -1字节
                lengthValue = valueLengthStep;
                loctionStar+=kLength;
                cmdValue = [base64String substringWithRange:NSMakeRange(loctionStar, lengthValue)];
            }else if ([cmdKey isEqualToString:@"42"]){//融冰停止温度 - 1 字节
                lengthValue = valueLengthStep;
                loctionStar+=kLength;
                cmdValue = [base64String substringWithRange:NSMakeRange(loctionStar, lengthValue)];
            }else if ([cmdKey isEqualToString:@"43"]){//融冰时间  -1 字节
                lengthValue = valueLengthStep;
                loctionStar+=kLength;
                cmdValue = [base64String substringWithRange:NSMakeRange(loctionStar, lengthValue)];
            }else if ([cmdKey isEqualToString:@"44"]){//融冰间隔时间 - 1 字节
                lengthValue = valueLengthStep;
                loctionStar+=kLength;
                cmdValue = [base64String substringWithRange:NSMakeRange(loctionStar, lengthValue)];
            }else if ([cmdKey isEqualToString:@"73"]){//新风温度 -2 字节
                lengthValue = valueLengthStep*2;
                loctionStar+=kLength;
                cmdValue = [base64String substringWithRange:NSMakeRange(loctionStar, lengthValue)];
            }else if ([cmdKey isEqualToString:@"74"]){//排风温度 -2 字节
                lengthValue = valueLengthStep*2;
                loctionStar+=kLength;
                cmdValue = [base64String substringWithRange:NSMakeRange(loctionStar, lengthValue)];
            }else if ([cmdKey isEqualToString:@"01"]){//系统时间 - 6 字节
                lengthValue = valueLengthStep*6;
                loctionStar+=kLength;
                cmdValue = [base64String substringWithRange:NSMakeRange(loctionStar, lengthValue)];
                [self setCmdCalibarateTime:cmdValue];
            }else if ([cmdKey isEqualToString:@"0f"]){//故障状态 - 2 字节
                lengthValue = valueLengthStep*2;
                loctionStar+=kLength;
                cmdValue = [base64String substringWithRange:NSMakeRange(loctionStar, lengthValue)];
            }
            loctionStar+=lengthValue;
        }
    }
    return self;
}




-(void)initObjectModel
{
    _fanModel =[[FanModeModel alloc] init];
    _timeModel = [DeviceSettingTimeModel createDeviceTimeModeWithMode:None deviceName:@"" timePeriod:nil];
    _timeOne = [CustomModel createCustomModelWithOpenTime:@"00" CloseTime:@"00" isOpen:NO];
    _timeTwo = [CustomModel createCustomModelWithOpenTime:@"00" CloseTime:@"00" isOpen:NO];
    _timeThree = [CustomModel createCustomModelWithOpenTime:@"00" CloseTime:@"00" isOpen:NO];
}


-(void)setCmdPower:(NSString *)cmdString //开关机
{
    //    NSString *value = [cmdString substringFromIndex:4];
    if ([cmdString isEqualToString:@"01"]) { //开机
        _btnPower = @"1";
    }else{
        _btnPower = @"0";
    }
}
-(void)setCmdCO2Density:(NSString *)cmdString{ //CO2当前浓度
    //CO2 --- 两个字节 eg.1300
    if (cmdString.length) {
        long lCO2 = [UtilConversion toDecimalFromHex:cmdString];
        _CO2Density = lCO2;
    }
}
-(void)setCmdFanFrequency:(NSString *)cmdString //设定风机频率
{
    if (cmdString.length) {
        long fre = [UtilConversion toDecimalFromHex:cmdString];
        _fanFrequency = fre;
    }
}
-(void)setCmdFanRotateSpeed:(NSString *)cmdString//设定风机风量
{
    if (cmdString.length) {
        long rotateSpeed = [UtilConversion toDecimalFromHex:cmdString];
        _fanRotateSpeed = rotateSpeed;
    }
}

-(void)setCmdInsidePm:(NSString *)cmdString{ //室内pm
    if (cmdString.length) {
        long inPm = [UtilConversion toDecimalFromHex:cmdString];
        _deviceInsidePm = inPm;
    }
}
-(void)setCmdOutsidePm:(NSString *)cmdString{//室外pm
    if (cmdString.length) {
        long outPm = [UtilConversion toDecimalFromHex:cmdString];
        _deviceOutsidePm = outPm;
    }
}
-(void)setCmdInsideTem:(NSString *)cmdString{//室内温度
    if (cmdString.length) {
        long inTemp = [UtilConversion toDecimalFromHex:cmdString];
        _deviceInsideTem = inTemp/10.0;
    }
}
-(void)setCmdOutsideTem:(NSString *)cmdString{//室外温度
    if (cmdString.length) {
        long outTemp = [UtilConversion toDecimalFromHex:cmdString];
        _deviceOutsideTem = outTemp/10.0;
    }
}


-(void)setCmdFanModel:(NSString *)cmdString //设定 风机 模式
{
    //模式----有优先级(静默，CO2,灰尘) 注意，最大为 0x0f
    NSString *value = [cmdString substringFromIndex:1];
    NSString *modeStr = [UtilConversion stringFromHexCharacter:value];//1111
    if ([[modeStr substringFromIndex:3] isEqualToString:@"1"]) {
        _fanModel.inteMode = Silience;
        _fanModel.status = YES;
    }else if ([[modeStr substringWithRange:NSMakeRange(2, 1)] isEqualToString:@"1"]){
        _fanModel.inteMode = CO2Adjust;
        _fanModel.status = YES;
    }else if ([[modeStr substringWithRange:NSMakeRange(1, 1)]isEqualToString:@"1"]){
        _fanModel.inteMode = PMAdjust;
        _fanModel.status = YES;
    }else{
        _fanModel.status = NO;
    }
}


-(void)setCmdFunModelCO2:(NSString *)cmdString
{
    if (cmdString.length) {
        long lCO2 = [UtilConversion toDecimalFromHex:cmdString];
        _fanModel.CO2 = lCO2;
    }
}

-(void)setCmdFunModelPM:(NSString *)cmdString
{
    if (cmdString.length) {
        long lPM = [UtilConversion toDecimalFromHex:cmdString];
        _fanModel.pm25 = lPM;
    }
}


-(void)setCmdTimeModel:(NSString *)cmdString //设定风机 定时 模式 @"1f"
{
    NSString *value =@"";
    //  Bit0-2  定时器模式
    //  1-每天  2-仅一次  4-工作日
    //  Bit3   定时器1状态
    //  Bit4   定时器2状态
    //  Bit5   定时器3状态
    //  0：关闭  1：开启
    //定时模式 ---
    value = [cmdString substringFromIndex:0];//@"14"
    if (value.length) {
        NSMutableString *joinStr= [NSMutableString new];
        NSString *highS =[UtilConversion stringFromHexCharacter:[value substringWithRange:NSMakeRange(0, 1)]] ;
        NSString *lowS = [UtilConversion stringFromHexCharacter:[value substringWithRange:NSMakeRange(1, 1)]];
        [joinStr appendString:highS];
        [joinStr appendString:lowS];
        
        [DeviceSettingTimeModel createDeviceTimeModeWithMode:Everyday deviceName:@"" timePeriod:nil];
        //判断哪一位是开启的------1-每天  2-仅一次  4-工作日 eg @"0011 1100"
        if ([[joinStr substringFromIndex:7] isEqualToString:@"1"]) {
            _timeModel.mode = Everyday;
        }else if ([[joinStr substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"1"]){
            _timeModel.mode = OnlyOnce;
        }else if ([[joinStr substringWithRange:NSMakeRange(5, 1)]isEqualToString:@"1"]){
            _timeModel.mode = Weekday;
        }else{
            _timeModel.mode = None;
        }
        if ([[joinStr substringWithRange:NSMakeRange(4, 1)] isEqualToString:@"1"]) {
            _timeOne.isOpen = YES;
        }
        if ([[joinStr substringWithRange:NSMakeRange(3, 1)] isEqualToString:@"1"]) {
            _timeTwo.isOpen = YES;
        }
        if ([[joinStr substringWithRange:NSMakeRange(2, 1)] isEqualToString:@"1"]) {
            _timeThree.isOpen = YES;
        }
    }
    if (_timeModel.mode == None) {
        _timeModel.status = NO;
    }else{
        _timeModel.status = YES;
    }
}

// Byte1  开始时间小时值
// Byte2  开始时间分钟值
// Byte3  结束时间小时值
// Byte4  结束时间分钟值

-(void)setCmdOneTimer:(NSString *)cmdString //设置定时器1
{
    if (cmdString.length) {
        //        NSLog(@"the Timer1");
        [self setTimer:cmdString inWhichTime:_timeOne];
        _timeModel.oneSettingTimeModel = _timeOne;
    }
}
-(void)setCmdTwoTimer:(NSString *)cmdString //设置定时器2
{
    if (cmdString.length) {
        //        NSLog(@"the Timer2");
        [self setTimer:cmdString inWhichTime:_timeTwo];
        _timeModel.twoSettingTimeModel = _timeTwo;
    }
}
-(void)setCmdThreeTimer:(NSString *)cmdString //设置定时器3
{
    if (cmdString.length) {
        //        NSLog(@"the Timer3");
        [self setTimer:cmdString inWhichTime:_timeThree];
        _timeModel.threeSettingTimeModel = _timeThree;
    }
}

-(void)setTimer:(NSString *)valeStr inWhichTime:(CustomModel *)timeModel
{
    long startHour = [UtilConversion numFromString:[valeStr substringWithRange:NSMakeRange(0, 2)]];
    long startMinute = [UtilConversion numFromString:[valeStr substringWithRange:NSMakeRange(2, 2)]];
    long stopHour = [UtilConversion numFromString:[valeStr substringWithRange:NSMakeRange(4, 2)]];
    long stoptMinute = [UtilConversion numFromString:[valeStr substringWithRange:NSMakeRange(6, 2)]];
    //    NSLog(@"the start Time：%@",[NSString stringWithFormat:@"%.2ld:%.2ld",startHour,startMinute]);
    //    NSLog(@"the end Time:%@",[NSString stringWithFormat:@"%.2ld:%.2ld",stopHour,stoptMinute]);
    timeModel.openTime = [NSString stringWithFormat:@"%.2ld:%.2ld",startHour,startMinute];
    timeModel.closeTime = [NSString stringWithFormat:@"%.2ld:%.2ld",stopHour,stoptMinute];
    
}

//除尘清洗剩余时间
-(void)setCmdFilterRemain:(NSString *)cmdString
{
    if (cmdString.length) {
        long remainTime = [UtilConversion toDecimalFromHex:cmdString];
        _btnFilterRemainTime = remainTime;
    }
}

-(void)setCmdCalibarateTime:(NSString *)cmdString
{
    if (cmdString.length) {
        _calibarateTime = [NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld",
                           [UtilConversion toDecimalFromHex:[cmdString substringToIndex:4]],
                           [UtilConversion toDecimalFromHex:[cmdString substringWithRange:NSMakeRange(4, 2)]],
                           [UtilConversion toDecimalFromHex:[cmdString substringWithRange:NSMakeRange(6, 2)]],
                           [UtilConversion toDecimalFromHex:[cmdString substringWithRange:NSMakeRange(8, 2)]],[UtilConversion toDecimalFromHex:[cmdString substringWithRange:NSMakeRange(10, 2)]]
                           ];
    }
}

//启动app获取设备列表之后，对比当前时间是否与设备返回的当前时间相同，如果不相同则发送校准时间的指令
//如果时间不对，则发送校准时间的指令

@end
