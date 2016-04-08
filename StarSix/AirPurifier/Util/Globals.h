//
//  Globals.h
//  AirPurifier
//
//  Created by bluE on 14-8-13.
//  Copyright (c) 2014年 skyware. All rights reserved.
//
#ifndef AirPurifier_Globals_h
#define AirPurifier_Globals_h

#define kSelectedCity           @"SelectedCity"
//自定义颜色
#define myColor(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
/**
 *  Automatic login information to access key
 **/
#define LoginInfo           @"LoginInfo"
//#define IsRememberPassword             @"IsRememberPassword"
#define LoginUserName           @"LoginUserName"
#define LoginPassWord           @"LoginPassWord"
#define LoginType           @"LoginType"
#define UserID     @"UserId" //用于第三方登陆的userId信息
#define IsAutoLogin @"isAutoLogin"

#define AgreeUserAgreementNotification              @"AgreeUserAgreementNotification"

#define isEmptyString( str )  (( str == nil || str == NULL || [str isEqualToString:@""] || [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] ) ? YES : NO)

#define isObject(obj) [obj isEqual:[NSNull null]] ? NO : YES

#define isNull(obj) ([obj isEqual:[NSNull null]] || obj == NULL || obj == nil )? NO : YES

typedef NS_ENUM(NSInteger, TypeCode){
    CodeSucceed = 1,
    CodeErrorNameOrPwd = 2, //用户名或密码错误，请重试.
    CodeOtherError = 3,
}ResponseCode;

typedef NS_ENUM(NSInteger,  TypeLogin) {
    //以下是枚举成员
    QQType = 1,
    WeiboType = 2,
    NormalType = 3,
};

#define kNoNetWork @"您的网络连接不可用，请设置网路"


/**
 *修改设备信息
 *
 **/
#define UNLOCKINGSTRING @"您确定要解锁这台设备吗？\n （设备解锁后可以被他人建立新绑定关系）"
#define LOCKINGSTRING @"您确定要锁定这台设备吗？\n (设备锁定后不能再被其他人建立新绑定关系) "
#define UNBINDINGSTRING @"您确定要解绑这台设备吗？\n （设备解绑后将无法再查看该设备）"
/**
 *设备信息
 **/
#define DEVICESN @"deviceSn"
#define DEVICENAME @"deviceName"
#define DEVICELOCATION @"deviceLocation"
#define DEVICEMAC @"deviceMac"
#define DEVICELOCK @"deviceLock"

#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

#define AgreeUserAgreementNotification              @"AgreeUserAgreementNotification"
#define AirControlPageOpenCompleteNotification      @"AirControlPageOpenCompleteNotification"
//#define AllAirDeviceRemovedNotification             @"AllAirDeviceRemovedNotification"
#define AirDeviceAddedNotification                @"AirDeviceAddedNotification"
#define AirDeviceRemovedNotification                @"AirDeviceChangedNotification"
#define AirDeviceChangedNotification                @"AirDeviceRemovedNotification"
#define AirDeviceAllDelete  @"AirDeviceAllDelete"
#define AirDeviceGetPushNotification                @"AirDeviceGetPushNotification"
#define LogOutNotification                @"LogOutNotification"


#define LocationAutoNotification @"LocationAutoNotification"
#define UserNameModifiedNotification            @"UserNameModifiedNotification"
#define UserImgModifiedNotification              @"UserImgModifiedNotification"
#define UserPhoneModifiedNotification               @"UserPhoneModifiedNotification"
#define ChangeAirBoxSucceedNotification             @"ChangeAirBoxSucceedNotification"
#define UseMailNotification                @"UseMailNotification"
#define CityChangedNotification                     @"CityChangedNotification"
#define CityFirstdNotification @"CityFirstdNotification"
#define DeviceModeChangeNotification @"DeviceModeChangeNotification"

#define NeedSubscribeNotifacation @"NeedSubscribeNotifacation"
#define EnterForegroundNotifacation @"EnterForegroundNotifacation"

//#define CloseDeviceNotification @"CloseDeviceNotification"


#define CurrentTime @"currentTime"

#define Localized(str)              NSLocalizedString(str,str)
#define MainDelegate                ((AirPurifierAppDelegate *)[UIApplication sharedApplication].delegate)
#define UserDefault                 [NSUserDefaults standardUserDefaults]
#define NotificationCenter          [NSNotificationCenter defaultCenter]

#define kTopic(deviceMac)     [NSString stringWithFormat:@"sjw/%@",deviceMac]//订阅设备的mac定制
//开发服务器
#define DeviceOffLine @"请检查：\n1.设备是否连接电源；\n2.WiFi是否正常；\n3.请尝试重新配置WiFi；\n当检查完毕，请重新刷新；              "

#define SHARE_CONTENT @"airpal 爱宝乐，一个您很好的选择。"
#define MAINTITLE @"六星风机"
#define HelpURLString @"http://t1.skyware.com.cn/help/8"
#define FeedHint @"请输入意见和建议"
#define NetIsUnreached @"网络连接失败，请检查您的网络"
#define NoDeviceHint @"您还木有绑定新风机\n点击“+”来绑定"
#define alterPm @"空气质量差，请注意空气循环"
#define alterFilter @"滤网到期"

#define IOS7  [[[UIDevice currentDevice] systemVersion] floatValue]>=7.0
#define VIEWHEIGHT ([UIScreen mainScreen].bounds.size.height-ADDHEIGH)
#define ADDHEIGH (([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)?20.0:0)

#define kScreenH               [UIScreen mainScreen].bounds.size.height
#define kScreenW               [UIScreen mainScreen].bounds.size.width

#define dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}



#endif
