
//
//  AirPurifierViewController.m
//  AirPurifier
//
//  Created by bluE on 14-8-13.
//  Copyright (c) 2014年 skyware. All rights reserved.
//
#import "AirPurifierViewController.h"
#import "DetailViewController.h"
#import "DeviceView.h"
#import "UIFlipperView.h"
#import "AppDelegate.h"
#import "UIView+Toast.h"
#import "UIColor+Utility.h"
#import "PlistManager.h"
#import "TCPManager.h"
#import "Reachability.h"
#import "PureLayout.h"
#import "SendCommandManager.h"
#import "PopHintView.h"
#import "ModelNotice.h"
#import "CommandRepeatedTimer.h"
#import "CommandSave.h"
#import "UIWindow+Extension.h"
#import <AddDeviceViewController.h>

@interface AirPurifierViewController ()<UIAlertViewDelegate,UIActionSheetDelegate,QRCodeViewControllerDelegate>
{
    DeviceView *deviceView;
    DeviceView *firstView;
    UILocalNotification *localNotifFilter;//本地通知
    DeviceVo * pushCurrentDeviceVo;
}
@property (nonatomic,copy) NSMutableArray *statusList;
@property (nonatomic,copy) NSMutableArray *dataList;//设备列表
@property (nonatomic,copy) NSMutableArray *onlineDevices;//pm通知

@end

static NSInteger mCurrentLayoutState;

@implementation AirPurifierViewController
@synthesize deviceVFView;
@synthesize leftSwipeGestureRecognizer,rightSwipeGestureRecognizer;
@synthesize pageControl;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavBar];
    [self addGesture];
    [kNotificationCenter addObserver:self selector:@selector(MQTTMessage:) name:kSkywareNotificationCenterCurrentDeviceMQTT object:nil];
    [self downSettingInfo];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self downLoadDevice];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeNoDeviceCoverView];
    if (self.dataList.count) {
        DeviceVo *de = [self.dataList objectAtIndex:mCurrentLayoutState];
        NSString *key = [NSString stringWithFormat:@"%@-currrentDeviceIndex", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]];
        [[NSUserDefaults standardUserDefaults] setObject:de.deviceMac  forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
-(void)viewWillLayoutSubviews
{
    if (IS_IPHONE_6P) {
        _leadingConstraint.constant = -24;
    }
}

-(void)downLoadDevice
{
    self.downloadDeviceSuccess = ^(SkywareResult *result){ //获取设备列表成功
        NSArray *jsonArray =result.result;
        //首先清空列表
        [self.dataList removeAllObjects];
        [self removeNoDeviceCoverView];
        for (int i=0; i< jsonArray.count; i++) {
            NSDictionary *dictionary = [jsonArray objectAtIndex:i];
            DeviceVo *vo= [[DeviceVo alloc] initWithDic:dictionary];
            if ([vo.deviceOnline isEqualToString:@"1"] ) {
                [self.onlineDevices addObject:vo];
            }
            [self.dataList insertObject:vo atIndex:i];
        }
        [[SkywareNotificationCenter sharedSkywareNotificationCenter] subscribeUserBindAllDevices]; //订阅设备
        dispatch_async(dispatch_get_main_queue(), ^{
            [self initDeviceView];
            self.pageControl.numberOfPages = self.dataList.count;
            if (self.dataList.count>1) {
                self.pageControl.hidden = NO;
            }else{
                self.pageControl.hidden = YES;
            }
        });
    };
    self.downloadDeviceFailure = ^{  //没有设备
        [self.dataList removeAllObjects];
        dispatch_async(dispatch_get_main_queue(), ^{
            for (UIView *view in deviceVFView.subviews) {
                [view removeFromSuperview];
            }
            [self initNoView];
            [self addNoDeviceCoverView];
        });
    };
    [self downloadDevicesForView];
}

-(void)setNavBar
{
    [self setNavTitle:@"六星新风机"]; //应该为设备名称
//    self.navView.centerView
    [self setRightBtnWithImage:[UIImage imageNamed:@"btn_menu.png"] orTitle:nil ClickOption:^{
        DetailViewController *menu = [[DetailViewController alloc] init];
        [MainDelegate.navigationController pushViewController:menu animated:YES];
    }];
    [self setLeftBtnWithImage:[UIImage imageNamed:@"addDevice"] orTitle:nil ClickOption:^{
        UIActionSheet *sheetView = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"添加新设备",@"添加分享设备", nil];
        [sheetView showInView:self.view];
    }];
    firstView = [DeviceView instanceDeviceView];
    mCurrentLayoutState = 0;
    pageControl.numberOfPages = 1;
}
#pragma mark 增加手势
-(void)addGesture
{
    //添加手势
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(Fling:)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(Fling:)];
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:self.leftSwipeGestureRecognizer];
    [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];
}
#pragma mark 左右滑动切换
- (void)Fling:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        deviceVFView.mWhichChild = mCurrentLayoutState;
        if ([self.dataList count] >1) {
            if (mCurrentLayoutState != pageControl.numberOfPages - 1) {
                mCurrentLayoutState += 1;
            } else {
                mCurrentLayoutState = 0;
            }
            pageControl.currentPage = mCurrentLayoutState;
            DeviceVo * deviceVo = [self.dataList objectAtIndex:mCurrentLayoutState];
            [self showStatusAndHomeImgOnDeviceVo:deviceVo onBtnControl:_btnControl];
            [deviceVFView showNext];
            //            _mainTitle.text = ((DeviceVo *)[self.dataList objectAtIndex:mCurrentLayoutState]).deviceName;
            SkywareUIManager *UIM = [SkywareUIManager sharedSkywareUIManager];
            ((UILabel *)self.navView.centerView).text = UIM.defaultDeviceName;

            if([self.navView.centerView isKindOfClass:[UILabel class]]){
                ((UILabel *)self.navView.centerView).text = ((DeviceVo *)[self.dataList objectAtIndex:mCurrentLayoutState]).deviceName;
            }
        }
    }
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        deviceVFView.mWhichChild = mCurrentLayoutState;
        if ([self.dataList count] >1) {
            if (mCurrentLayoutState != 0) {
                mCurrentLayoutState -= 1;
            } else {
                mCurrentLayoutState = pageControl.numberOfPages-1;
            }
            pageControl.currentPage = mCurrentLayoutState;
            DeviceVo * deviceVo = [self.dataList objectAtIndex:mCurrentLayoutState];
            [self showStatusAndHomeImgOnDeviceVo:deviceVo onBtnControl:_btnControl];
            [deviceVFView showPrevious];
         
            if([self.navView.centerView isKindOfClass:[UILabel class]]){
                ((UILabel *)self.navView.centerView).text = ((DeviceVo *)[self.dataList objectAtIndex:mCurrentLayoutState]).deviceName;
            }
        }
    }
}


#pragma mark - MQTT 消息推送
- (void)MQTTMessage:(NSNotification *)not
{
    SkywareMQTTModel *model = [not.userInfo objectForKey:kSkywareMQTTuserInfoKey];
    [self updateViewFromPush:model];
}

#pragma mark initNoView (没有设备情况下)
- (void)initNoView
{
    self.pageControl.hidden = YES;
    //    _mainTitle.text = @"六星新风机";
    SkywareUIManager *UIM = [SkywareUIManager sharedSkywareUIManager];
    ((UILabel *)self.navView.centerView).text = UIM.defaultDeviceName;
    _bottom_View.backgroundColor = kNavigationBarColor;
    _lblClosing.text = @"";

    _btnControl.tag = ControlAdd;
    [self setImageOnControllButton:_btnControl WithDefaultImage:@"btn_add_default" seletecdImage:@"btn_add_pressed"];
    [deviceVFView addSubview:firstView];
}

//没有设备的情况下，提示无设备
-(void)addNoDeviceCoverView
{
    //显示 您还木有绑定新风机,点击“+”来绑定
    UIView *coverTransparentView = [UIView newAutoLayoutView];
    coverTransparentView.tag = 10001;
    coverTransparentView.backgroundColor = [UIColor blackColor];
    coverTransparentView.alpha = 0.8;
    
    UIView *hintView = [UIView newAutoLayoutView];
    [coverTransparentView addSubview:hintView];
    [hintView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:20];
    [hintView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [hintView autoSetDimensionsToSize:CGSizeMake(kWindowWidth - 80, 100)];
    
    UIImageView *bgImgView = [UIImageView newAutoLayoutView];
    [hintView addSubview:bgImgView];
    bgImgView.image = [UIImage imageNamed:@"text_border_noDevice"];
    [bgImgView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    UILabel *lblText = [UILabel newAutoLayoutView];
    [hintView addSubview:lblText];
    [lblText autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [lblText autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [lblText autoSetDimension:ALDimensionHeight toSize:80.0];
    [lblText autoSetDimensionsToSize:CGSizeMake(kWindowWidth -140 , 80)];
    lblText.textAlignment = NSTextAlignmentCenter;
    lblText.numberOfLines = 0;
    lblText.font = [UIFont systemFontOfSize:20];
    lblText.textColor = [UIColor whiteColor];
    lblText.text = NoDeviceHint;
    [[UIWindow getCurrentWindow] addSubview:coverTransparentView];
    [coverTransparentView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(64, 0, 50, 0)];
}
-(void)removeNoDeviceCoverView
{
    UIView *bgView = [UIWindow getCurrentWindow];
    for (UIView *view in [bgView subviews]) {
        if (view.tag == 10001) {
            [view removeFromSuperview];
        }
    }
}

#pragma mark initView
-(void)initDeviceView
{
    //设置UIPageControl
    pageControl.numberOfPages = self.dataList.count;
    pageControl.currentPage = 0;
    mCurrentLayoutState = 0;
    pageControl.backgroundColor = [UIColor clearColor];
    [[deviceVFView subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    [self.dataList enumerateObjectsUsingBlock:^(DeviceVo * deviceVo, NSUInteger idx, BOOL *stop) {
        DeviceView *view = [DeviceView instanceDeviceView];
        view.deviceModel = deviceVo;
        if ([deviceVo.deviceOnline intValue] == DeviceOnlineOn) {
            if ([deviceVo.deviceData.btnPower intValue] == DevicePowerOn) {// 显示关机
                _btnControl.tag = ControlClose;
                _bottom_View.backgroundColor = kNavigationBarColor;
                _lblClosing.text = @"";
                [self setImageOnControllButton:_btnControl WithDefaultImage:@"btn_close_default" seletecdImage:@"btn_close_pressed"];
            }else{//显示开机
                _btnControl.tag = ControlOpen;
                _bottom_View.backgroundColor = [UIColor colorWithHex:0xd00212 alpha:1.0];
                _lblClosing.text = @"";
                [self setImageOnControllButton:_btnControl WithDefaultImage:@"btn_close_default" seletecdImage:@"btn_close_pressed"];
            }
        }else{//设备离线
            _btnControl.tag = ControlWifi;
            _bottom_View.backgroundColor = kNavigationBarColor;
            _lblClosing.text = @"";
            [self setImageOnControllButton:_btnControl WithDefaultImage:@"btn_wifi_default" seletecdImage:@"btn_wifi_pressed"];
        }
        view.tag = 100+idx;
        [deviceVFView insertSubview:view atIndex:idx];
    }];
    [self showCurrentView];
    self.pageControl.currentPage = mCurrentLayoutState;
    //    _mainTitle.text = ((DeviceVo *)[self.dataList objectAtIndex:mCurrentLayoutState]).deviceName;
    SkywareUIManager *UIM = [SkywareUIManager sharedSkywareUIManager];
    ((UILabel *)self.navView.centerView).text = UIM.defaultDeviceName;
    if([self.navView.centerView isKindOfClass:[UILabel class]]){
        ((UILabel *)self.navView.centerView).text = ((DeviceVo *)[self.dataList objectAtIndex:mCurrentLayoutState]).deviceName;
    }
}

-(void)showCurrentView
{
    NSString *key = [NSString stringWithFormat:@"%@-currrentDeviceIndex", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]];
    NSString *deviceMac = [UserDefault objectForKey:key];
    for (int i = 0 ; i < self.dataList.count; i++) {
        DeviceVo *deviceVo = [self.dataList objectAtIndex:i];
        if ([deviceVo.deviceMac isEqualToString:deviceMac]) {
            mCurrentLayoutState = i;
            break;
        }
    }
    [deviceVFView showChildFirstView:[deviceVFView viewWithTag:100+mCurrentLayoutState]];
    [self showStatusAndHomeImgOnDeviceVo:[self.dataList objectAtIndex:mCurrentLayoutState] onBtnControl:_btnControl];
}

#pragma mark 添加设备，切换控制/主视图
- (IBAction)changeView:(UIButton *)sender {
    if ([sender tag] == ControlAdd) {
        UIActionSheet *sheetView = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"添加新设备",@"添加分享设备", nil];
        [sheetView showInView:self.view];
    }
    else if([sender tag] == ControlOpen){
        _lblClosing.text = @"开机中";
        _lblClosing.hidden = NO;
        _btnControl.hidden = YES;
        [self sendOpenOrCloseToView:((DeviceVo *)[self.dataList objectAtIndex:mCurrentLayoutState]) commandString:@"1001"];
    }else if ([sender tag] == ControlClose){
        _lblClosing.text = @"关机中";
        _lblClosing.hidden = NO;
        _btnControl.hidden = YES;
        [self sendOpenOrCloseToView:((DeviceVo *)[self.dataList objectAtIndex:mCurrentLayoutState]) commandString:@"1000"];
    }
    else if([sender tag] == ControlWifi){
        [self showAlterView];
    }
}
#pragma mark 控制设备指令
-(void)sendOpenOrCloseToView:(DeviceVo *)deviceVo commandString:(NSString *)cmdString
{
    if (!MainDelegate.isNetworkAvailable) return;
    //开启定时，存储命令缓存(先清空缓存）
    [[CommandRepeatedTimer sharedCommandRepeatedTimer] startTimer];
    [CommandRepeatedTimer sharedCommandRepeatedTimer].afterTimer = ^{
        _lblClosing.hidden = YES;
        _btnControl.hidden = NO;
    };
    [CommandRepeatedTimer sharedCommandRepeatedTimer].succeedTimer = nil;
    [SendCommandManager sendDeviceOpenCloseCmd:deviceVo];
}

-(void)showStatusAndHomeImgOnDeviceVo:(DeviceVo *)deviceVo onBtnControl:(UIButton*)btnControl
{
    if (mCurrentLayoutState < self.dataList.count) {
        DeviceVo *deviceOn = (DeviceVo *)[self.dataList objectAtIndex:mCurrentLayoutState];
        if ([deviceOn.deviceMac isEqualToString:deviceVo.deviceMac]) {
            _lblClosing.hidden = YES;
            _btnControl.hidden = NO;
            if ([deviceVo.deviceOnline intValue] != DeviceOnlineOn) { //设备离线
                dispatch_async(dispatch_get_main_queue(), ^{
                    btnControl.tag = ControlWifi;
                    [self setImageOnControllButton:btnControl WithDefaultImage:@"btn_wifi_default" seletecdImage:@"btn_wifi_pressed"];
                });
            }
            else  if ([deviceVo.deviceOnline intValue] == DeviceOnlineOn) {
                if ( [deviceVo.deviceData.btnPower intValue] == DevicePowerOn) {
                    btnControl.tag = ControlClose;
                    _bottom_View.backgroundColor = kNavigationBarColor;
                    [self setImageOnControllButton:btnControl WithDefaultImage:@"btn_close_default" seletecdImage:@"btn_close_pressed"];
                }else {
                    btnControl.tag = ControlOpen;
                    _bottom_View.backgroundColor = [UIColor colorWithHex:0xd00212 alpha:1.0];
                    [self setImageOnControllButton:btnControl WithDefaultImage:@"btn_close_default" seletecdImage:@"btn_close_pressed"];
                }
            }
        }
    }
}

#pragma mark-- 大/小循环更新界面(推送)
-(void)updateViewFromPush:(SkywareMQTTModel *)MqttM
{
    //{"sn":6958,"cmd":"upload","mac":"ACCF232C6F26","data":["00 aa 0xag 0xbb 0xag"]}
    //{"sn":6958,"cmd":"upload","mac":"ACCF232C6F26","device_online":0}
    //    NSLog(@"pushMessage=%@",deviceInfo);
    DeviceVo * deviceVo=nil;
    if (MqttM.mac&& [self.dataList count]>0)//大循环
    {
        [self.onlineDevices removeAllObjects];
        for (int i=0;  i <self.dataList.count; i++) {
            deviceVo= (DeviceVo *)[self.dataList objectAtIndex:i];
            if ([deviceVo.deviceMac isEqualToString:MqttM.mac]) { //只更新当前设备的界面
                NSString *backString = [[MqttM.data firstObject] toHexStringFromBase64String];
                CommandSave *cmd = [CommandSave readCommandSave];
                if ([backString rangeOfString:[NSString stringWithString:[cmd.cmdCode lowercaseString]]].location != NSNotFound) {
                    if ([self isVisible]) {
                        [[CommandRepeatedTimer sharedCommandRepeatedTimer] stopTimer];
                    }
                }
                if (MqttM.device_online == 0) { //设备掉线的时候才返回
                    deviceVo.deviceOnline =[NSString stringWithFormat:@"%d",(int)MqttM.device_online] ;
                }else{
                    deviceVo.deviceOnline = @"1";////掉线之后再上线
                }
                deviceVo.deviceData =  [[DeviceData alloc] initWithBase64String:[[MqttM.data firstObject] toHexStringFromBase64String]];
            }
            if (deviceVo) {
                pushCurrentDeviceVo = deviceVo;
                ((DeviceView *)[deviceVFView viewWithTag:100+i]).deviceModel = deviceVo;//更新视图
                if ([deviceVo.deviceOnline isEqualToString:@"1"] ) {
                    [self.onlineDevices addObject:deviceVo];
                }
                //更新按钮状态
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showStatusAndHomeImgOnDeviceVo:deviceVo onBtnControl:_btnControl];
                });
            }
        }
    }
}

-(void)startCheck
{
    [self performSelector:@selector(checkFilterAlert) withObject:nil afterDelay:10];
}
//检测是否应该开启滤网提醒
-(void)checkFilterAlert
{
    BOOL remind = YES;//默认开启滤网提醒
    remind = [[ModelNotice sharedModelNotice].notice_filter boolValue];
    if (remind) {//滤网提醒
        [self.onlineDevices enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            DeviceVo *device = (DeviceVo *)obj;
            if (device.deviceData.btnFilterRemainTime <= 720) {
                [self notificationNetAboutDevice:device.deviceName remainTime:device.deviceData.btnFilterRemainTime];
            }
            //              [self notificationNetAboutDevice:device.deviceName remainTime:device.deviceData.btnFilterRemainTime];
        }];
    }
    else{
        if (localNotifFilter) {
            [[UIApplication sharedApplication] cancelLocalNotification:localNotifFilter];//停止本地推送
        }
    }
    [self.onlineDevices removeAllObjects];//移除所用保存的设备
}

#pragma mark 获取设置信息
-(void)downSettingInfo
{
    if (!MainDelegate.isNetworkAvailable) {
        return;
    }
    [SkywareUserManager UserGetUserWithParamesers:[NSArray new] Success:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
        if ([result.message intValue] == 200) {
            NSArray *arr = result.result;
            if (arr.count > 0) {
                if ([arr objectAtIndex:0][@"user_prefer"]!= nil) {
                    NSDictionary *dicNotice = [NSJSONSerialization JSONObjectWithData:[[arr objectAtIndex:0][@"user_prefer"] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                    [ModelNotice sharedModelNotice].notice_pm = dicNotice[@"notice_pm"];
                    [ModelNotice sharedModelNotice].notice_pm_value = dicNotice[@"notice_pm_value"];
                    [ModelNotice sharedModelNotice].notice_filter = dicNotice[@"notice_filter"];
                }
            }
        }
        [self performSelectorOnMainThread:@selector(startCheck) withObject:nil waitUntilDone:NO];
    } failure:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
    }];
}


-(void)notificationNetAboutDevice:(NSString *)deviceName remainTime:(long)time
{
    if (localNotifFilter == nil) {
        localNotifFilter = [[UILocalNotification alloc] init];
    }
    NSDate * date = [NSDate new];
    localNotifFilter.fireDate = date;
    localNotifFilter.timeZone = [NSTimeZone defaultTimeZone];
    // Notification details
    localNotifFilter.alertBody = [NSString stringWithFormat:@"\"%@\"除尘周期剩余%ld小时",deviceName,time];
    localNotifFilter.soundName = UILocalNotificationDefaultSoundName;
    // ios8后，需要添加这个注册，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    // Schedule the notification
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotifFilter];
}


#pragma mark show btnButton image
-(void)setImageOnControllButton:(UIButton *)button WithDefaultImage:(NSString *)defaultImgStr seletecdImage:(NSString *)pressedImgStr
{
    [button setBackgroundImage:[UIImage imageNamed:defaultImgStr] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:pressedImgStr] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:pressedImgStr] forState:UIControlStateSelected];
}

- (void)dealloc
{
    [NotificationCenter removeObserver:self];
}
#pragma  mark 懒加载
-(NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

-(NSMutableArray *)onlineDevices
{
    if (!_onlineDevices) {
        _onlineDevices = [NSMutableArray new];
    }
    return _onlineDevices;
}
-(BOOL)isVisible{
    return (self.isViewLoaded && self.view.window);
}


@end
