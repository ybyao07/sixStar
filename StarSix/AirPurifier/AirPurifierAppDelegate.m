//
//  AirPurifierAppDelegate.m
//  AirPurifier
//
//  Created by bluE on 14-8-13.
//  Copyright (c) 2014年 skyware. All rights reserved.
//
#import "AirPurifierAppDelegate.h"
#import "Reachability.h"
#import "AlertBox.h"
#import "UIColor+Utility.h"
#import <UIKit/UIKit.h>
#include "ZBarSDK.h"
#import "JSONKit.h"
#import "SkywareInstanceModel.h"
#import "OpenUDID.h"
#import "UserLoginedInfo.h"
#import "SkyDevice.h"
#import "SVProgressHUD.h"
#import "TCPManager.h"
#import "skySDK.h"
#import <SMS_SDK/SMS_SDK.h>
//#import <PgySDK/PgyManager.h>
#define SUPPORT_IOS8 1

#define SMS_SDKAppKey    @"baba71b393d8"
#define SMS_SDKAppSecret  @"154caea24e19d1b744092a9fe76bfb9c"

@implementation AirPurifierAppDelegate
@synthesize isShowingAlertBox;
@synthesize loginedInfo;
@synthesize queue;

#pragma mark 懒加载
-(NSMutableArray *)allDeviceList
{
    if (!_allDeviceList)
        _allDeviceList = [[NSMutableArray alloc] init];
    return _allDeviceList;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//	[DDLog addLogger:[DDTTYLogger sharedInstance]];
//    [[PgyManager sharedPgyManager] startManagerWithAppId:@"b62101c71098f4d2f5d757f1cc347d80"];
//    [[PgyManager sharedPgyManager] checkUpdate];
//    [[PgyManager sharedPgyManager] setEnableFeedback:NO];
    
     _isNoFirstTime = NO;
    [ZBarReaderView class];
    SkywareInstanceModel *instance = [SkywareInstanceModel sharedSkywareInstanceModel];
    instance.app_id = 9;
    [SMS_SDK	registerApp:SMS_SDKAppKey withSecret:SMS_SDKAppSecret];//短信

    if([UserDefault objectForKey:LoginInfo] == nil){
        NSDictionary *dicLoginInfo = @{    LoginUserName:@"",
                                           LoginPassWord:@"",
                                           LoginType:@"",
                                           IsAutoLogin:@"",
                                           UserID:@""};
        [UserDefault setObject:dicLoginInfo forKey:LoginInfo];
        [UserDefault synchronize];
    }
    //开启UDP广播
//    dispatch_queue_t dq = dispatch_queue_create("udpBroadcast", NULL);
//    [skySDK startDiscoverDeviceWithDelegate:self delegateQueue:dq];
    queue = dispatch_queue_create("com.skyware.ConcurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.loginViewController];
    self.window.rootViewController= navController;
    [self.window makeKeyAndVisible];
    [application setApplicationIconBadgeNumber:0];
    
#if SUPPORT_IOS8
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else
#endif
    {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    [SVProgressHUD setBackgroundColor:[UIColor colorWithHex:0xdcdcdc alpha:0.95]];
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
    
    if(_isNoFirstTime)
    {
        [NotificationCenter postNotificationName:NeedSubscribeNotifacation object:nil];
        [NotificationCenter postNotificationName:EnterForegroundNotifacation object:nil];
    }
    else
    {
        _isNoFirstTime = YES;
    } 
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//    [BPush  unbindChannel];
    [skySDK stopDiscoverDevice];
    [skySDK stopTCPConnect];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
}

#pragma mark 本地推送
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"除尘周期提示" message:notification.alertBody delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    // 图标上的数字减1
//    application.applicationIconBadgeNumber -= 1;
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



- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * Phone number
     * mobile：134,135,136,137,138,139,147,150,151,152,157,158,159,182,183,187,188,1705
     * unicom：130,131,132,155,156,185,186,1709
     * telecom：133,153,180,189,177,1700
     */
    
    /**
     NSString *mobile = @"^1(3[4-9]\\d|47\\d|5[0-27-9]\\d|8[2378]\\d|705)\\d{7}$";
     NSString *unicon = @"^1(3[0-2]\\d|[58][56]\\d||709)\\d{7}$";
     NSString *telecom = @"^1([35]3\\d|8[09]\\d|77\\d|700)\\d{7}$";
     
     NSPredicate *regexMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobile];
     NSPredicate *regexUnicon = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", unicon];
     NSPredicate *regexTelecom = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", telecom];
     
     if ([regexMobile evaluateWithObject:mobileNum]
     || [regexUnicon evaluateWithObject:mobileNum]
     || [regexTelecom evaluateWithObject:mobileNum])
     {
     return YES;
     }
     else
     {
     return NO;
     }
     */
    NSString *mobile = @"^1\\d{10}$";
    NSPredicate *regexMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobile];

    if ([regexMobile evaluateWithObject:mobileNum])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)showProgressHubInView:(UIView *)view
{
    [SVProgressHUD show];
}

- (void)hiddenProgressHubInView:(UIView *)view
{
    [SVProgressHUD dismiss];
}

- (NSString *)createJsonString:(NSDictionary *)dictionary
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
- (id)parseJsonData:(NSData *)data
{
    if(data == nil)
    {
        return nil;
    }
   return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];   
}

- (NSMutableURLRequest *)requestUrl:(NSURL *)URLString  method:(NSString *)method postFormData:(NSString *)post
{
    //post提交的参数，格式如下：
    //参数1名字=参数1数据&参数2名字＝参数2数据&参数3名字＝参数3数据&...
    //将NSSrring格式的参数转换格式为NSData，POST提交必须用NSData数据。
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //计算POST提交数据的长度
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    //定义NSMutableURLRequest
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //设置提交目的url
    [request setURL:URLString];
    //设置提交方式为 POST
    [request setHTTPMethod:method];
    //设置http-header:Content-Type
    //这里设置为 application/x-www-form-urlencoded ，如果设置为其它的，比如text/html;charset=utf-8，或者 text/html 等，都会出错。不知道什么原因。
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:@"text/html;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //设置http-header:Content-Length
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    //设置需要post提交的内容
    [request setHTTPBody:postData];
    return request;
}


- (NSMutableURLRequest *)requestUrl:(NSURL *)url method:(NSString *)method body:(NSString *)body
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:method];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"UTF-8" forHTTPHeaderField:@"Charset"];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:30.0f];
    return request;
}


#pragma  mark 持久化到本地
- (void)storeLoginInfoUseName:(NSString *)userName withPassword:(NSString *)password loginType:(int)type isAutoLogin:(BOOL)login userId:(NSString *)UserId
{
    if (!isEmptyString(userName) && !isEmptyString(password)) {
        NSDictionary *dicLoginInfo = @{LoginUserName:userName,
                                       LoginPassWord:password,
                                       LoginType:[NSNumber numberWithInt:type],
                                       IsAutoLogin:[NSNumber numberWithBool:login],
                                       UserID:UserId
                                       };
        [UserDefault setObject:dicLoginInfo forKey:LoginInfo];
        [UserDefault synchronize];
    }
}
#pragma mark -UDP
/**
 * Called when the datagram with the given tag has been sent.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
//    NSLog(@"udpSocketDidSendDataWithTag");
}

/**
 * Called if an error occurs while trying to send a datagram.
 * This could be due to a timeout, or something more serious such as the data being too large to fit in a sigle packet.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"udpSocketDidNotSendDataWithTag%@",error.description);
}
/**
 * Called when the socket has received the requested datagram.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext
{
    //返回
    //reslut = 192.168.1.140,ACCF23216434,HF-LPB100;address = (null)
//    NSLog(@"didReceiveData");
    NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
//    NSString *address1=[[NSString alloc] initWithData:address encoding:NSUTF8StringEncoding];
    NSArray *devices = [result componentsSeparatedByString:@";"];
    if ([devices count] > 0) {
        for (int i= 0 ; i< [devices count]; i++) {
            NSArray *array = [[devices objectAtIndex:i] componentsSeparatedByString:@","];
            SkyDevice *device = [[SkyDevice alloc] initWithArray:array];
            [[TCPManager sharedInstance] addSkyDevice:device delegate:nil delegateQueue:nil];
//            NSLog(@"reslut = %@;address = %@;IP = %@;MAC=%@",result,address1,device.IP,device.MAC );
        }
    }
   }
- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error
{
    NSLog(@"udpSocketDidClose");
}
@end
