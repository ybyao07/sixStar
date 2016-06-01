//
//  MainBaseControllerViewController.h
//  HangingFurnace
//
//  Created by ybyao07 on 16/4/1.
//  Copyright © 2016年 skyware. All rights reserved.
//

#import <BaseViewController.h>

typedef void(^downloadDeviceSuccess)();
typedef void(^downloadDeviceFailure)();
typedef NS_ENUM(NSInteger,  AlertViewTag)
{
    AlertViewUndefinedDevice = 1,//添加净化器
    AlertViewResetDevice = 2,//分享的设备被重置
    ALertViewNoNet = 3,    //净化器没有开启
    AlertViewWifi = 4,    //净化器不在线
    AlertViewCode = 5,   //扫描二维码添加设备
    AlertViewMasterHasBeenReset  = 6,
};

@interface MainBaseControllerViewController : BaseViewController

/**
 *  获取是否有重置的设备
 *  @param susscess
 *  @param failure
 */
-(void)downloadDevicesForView;

/**
 *  正常获取设备列表
 *
 */
-(void)downloadDeviceList;


@property (nonatomic,strong) downloadDeviceSuccess downloadDeviceSuccess;
@property (nonatomic,strong) downloadDeviceFailure downloadDeviceFailure;

//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
-(void)showAlterView;

-(void)showCoverView:(BOOL)need;

@end
