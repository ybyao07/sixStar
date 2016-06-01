//
//  AppDelegate.m
//  AirPurifier
//
//  Created by bluE on 14-8-13.
//  Copyright (c) 2014年 skyware. All rights reserved.
//
#import "AppDelegate.h"
#import "Reachability.h"
#import "AlertBox.h"
#import "UIColor+Utility.h"
#import <UIKit/UIKit.h>
#import <SMS_SDK/SMSSDK.h>
#import <SkywareUIManager.h>
#import "UserLoginViewController.h"

#import <BaseNavigationController.h>

//#import <PgySDK/PgyManager.h>
#define SUPPORT_IOS8 1

#define SMS_SDKAppKey    @"1213a0c1f87dc"
#define SMS_SDKAppSecret  @"dd209220df318ef4ab71ec35c4192659"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//	[DDLog addLogger:[DDTTYLogger sharedInstance]];
//    [[PgyManager sharedPgyManager] startManagerWithAppId:@"b62101c71098f4d2f5d757f1cc347d80"];
//    [[PgyManager sharedPgyManager] checkUpdate];
//    [[PgyManager sharedPgyManager] setEnableFeedback:NO];
    
    [SMSSDK registerApp:SMS_SDKAppKey withSecret:SMS_SDKAppSecret];
    //    [SMSSDK enableAppContactFriends:NO];
    
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    manager.app_id = 9;
    manager.service_type = production_new;
    
    SkywareUIManager *UIM = [SkywareUIManager sharedSkywareUIManager];
    UIM.All_button_bgColor = kNavigationBarColor;
    UIM.User_button_bgColor = kNavigationBarColor;
//    UIM.All_view_bgColor = kNavigationBarColor;
    UIM.User_loginView_logo = [UIImage imageNamed:@"login"];
    UIM.Device_setWifi_bgimg = [UIImage imageNamed:@"wifi"];
    UIM.Device_bickerArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"wifi_normal"], [UIImage imageNamed:@"wifi_flick"],nil];
    UIM.WRotioH = 596/332.0;
    UIM.HelpURLMenu = @"http://t1.skyware.com.cn/help/8";
    UIM.Menu_about_img = [UIImage imageNamed:@"about"];
    UIM.AboutWRotioH = 400.0/498.0;
    UIM.Device_resetTitle = @"正在搜索六星新风机";
    UIM.Device_resetContent = @"点击Wifi，选择进入配网模式";
    UIM.DeviceListIconImg = @"show_1_1";
    UIM.Device_setting_error = @"很抱歉，无法顺利配置设备上网，可能由于： \n1.请检查WiFi密码是否输入正确；\n2.当前环境内WiFi路由器过多；\n3.当前路由器禁用某些端口。\n\n我们建议：\n1.点击WiFi键，重新进入配网模式，再试一次；\n2.重启路由器或换一台手机试一下。";
    UIM.defaultDeviceName = @"六星新风机";
    
    LXFrameWorkManager *LXM = [LXFrameWorkManager sharedLXFrameWorkManager];
    LXM.navigationBar_bgColor = kNavigationBarColor;
    LXM.navigationBar_textColor = [UIColor whiteColor];
//    LXM.stepViewTitle_bgColor = kNavigationBarColor;
    LXM.backState = writeBase;
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UserLoginViewController *loginController = [[UIStoryboard storyboardWithName:@"User" bundle:nil] instantiateViewControllerWithIdentifier:@"UserLoginViewController"];
    BaseNavigationController *baseNav = [[BaseNavigationController alloc] initWithRootViewController:loginController];
    self.window.rootViewController = baseNav;
    self.navigationController = (UINavigationController *)baseNav;
    [self.window makeKeyAndVisible];
    
    UIApplication *app = [UIApplication sharedApplication];
    [app setStatusBarHidden:NO];
    [app setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // 设置弹出框后不可操作
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:0.2]];
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
}

#pragma mark 本地推送
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"除尘周期提示" message:notification.alertBody delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

- (BOOL)isNetworkAvailable
{
    if([Reachability reachabilityForInternetConnection].currentReachabilityStatus == NotReachable)
    {
        UIAlertView *noNetWorkAlertView = [[UIAlertView alloc] initWithTitle:@"手机网络异常" message:@"您的网络出现一点问题，请检查网络，并重新刷新。" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"刷新", nil];
        noNetWorkAlertView.delegate = self;
        [noNetWorkAlertView show];
        return NO;
    }
    return YES;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {//刷新
        [self isNetworkAvailable];
    }
}


-(BOOL)beforeSendBaseonWifiLock:(DeviceVo *)skywareInfo
{
    if (![skywareInfo.deviceOnline boolValue]) {  //设备掉线
        [[[UIAlertView alloc] initWithTitle:nil message:@"设备已离线" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
        return NO;
    }
    if ([skywareInfo.user_state boolValue]) { //被分享的用户
        if (![skywareInfo.deviceLock boolValue]) { //锁定
            [[[UIAlertView alloc] initWithTitle:@"" message:@"设备已被主人锁定，您无法控制该设备" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
            return NO;
        }
    }
    if (![self isNetworkAvailable]) {
        return NO;
    }
    return YES;
}

@end
