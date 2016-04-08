//
//  AirPurifierViewController.h
//  AirPurifier
//
//  Created by bluE on 14-8-13.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFlipperView.h"
#import "GCDAsyncSocket.h"
#import "YBBaseViewController.h"
#import "DeviceVo.h"
#import <MQTTKit.h>

@interface AirPurifierViewController : YBBaseViewController <GCDAsyncSocketDelegate>
/**
 * btn_control状态码
 */
typedef NS_ENUM(NSInteger,  BTN_CONTROL)
{
    ControlAdd = 1,//添加净化器
    ControlOpen = 2,    //净化器没有开启
    ControlWifi = 3,    //净化器不在线
    ControlClose = 4,    //
};
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIView *mainLoad;
@property (strong, nonatomic) IBOutlet UIView *mainLoadFail;

@property (weak, nonatomic) IBOutlet UIFlipperView *deviceVFView;
@property (weak, nonatomic) IBOutlet UILabel *mainTitle;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *btnControl;


@property (weak, nonatomic) IBOutlet UIView *bottom_View;

@property (weak, nonatomic) IBOutlet UILabel *lblClosing;

@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;


@property (nonatomic, strong) MQTTClient *client;//MQTT大循环


//-(void)sendCmdWifiToMCU:(DeviceVo *)deviceVo withCommnd:(NSString *)cmdString;



@end
