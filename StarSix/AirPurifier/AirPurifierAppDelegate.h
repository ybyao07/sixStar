//
//  AirPurifierAppDelegate.h
//  AirPurifier
//
//  Created by bluE on 14-8-13.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "GCDAsyncUdpSocket.h"
#import "GCDAsyncSocket.h"
@class UserLoginedInfo;

@interface AirPurifierAppDelegate : UIResponder <UIApplicationDelegate,GCDAsyncUdpSocketDelegate,UIAlertViewDelegate>
{
       UserLoginedInfo     *loginedInfo;
}
// Judgment phone format
- (BOOL)isMobileNumber:(NSString *)mobileNum;
/**
 *  check the net work connect status
 **/
- (BOOL)isNetworkAvailable;

/**
 * Wait view show
 **/
- (void)showProgressHubInView:(UIView *)view;
/**
 * Wait view hidden
 **/
- (void)hiddenProgressHubInView:(UIView *)view;
/**
 *  parse json data
 **/
/**
 *  Form表单请求
 **/
- (NSMutableURLRequest *)requestUrl:(NSURL *)URLString  method:(NSString *)method postFormData:(NSString *)post;
/**
 *  Return a network request
 **/
- (NSMutableURLRequest *)requestUrl:(NSURL *)url method:(NSString *)method body:(NSString *)body;

- (id)parseJsonData:(NSData *)data;
/**
 *  create json data
 **/
- (NSString *)createJsonString:(NSDictionary *)dictionary;

/**
 *
 **/
- (void)storeLoginInfoUseName:(NSString *)userName withPassword:(NSString *)password loginType:(int)type isAutoLogin:(BOOL)login userId:(NSString *)UserId;
@property (strong, nonatomic) UserLoginedInfo *loginedInfo;
@property (strong,nonatomic) UIWindow *window;
@property (strong,nonatomic) LoginViewController *loginViewController;
@property (nonatomic)         BOOL isShowingAlertBox;
@property (nonatomic) BOOL isFromRegister;
@property (nonatomic) BOOL isFromMain;
@property (nonatomic) BOOL isFromWifi;

@property (copy, nonatomic) NSMutableArray *allDeviceList;
@property (strong,nonatomic) NSString *autoLocation;

@property (nonatomic,assign)  BOOL isNoFirstTime;


@property  dispatch_queue_t queue;
@end
