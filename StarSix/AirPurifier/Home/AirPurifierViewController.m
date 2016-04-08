
//
//  AirPurifierViewController.m
//  AirPurifier
//
//  Created by bluE on 14-8-13.
//  Copyright (c) 2014年 skyware. All rights reserved.
//
#import "AirPurifierViewController.h"
#import "AccountManageViewController.h"
#import "DetailViewController.h"
#import "DeviceView.h"
#import "JSONKit.h"
#import "UIFlipperView.h"
#import "AirPurifierAppDelegate.h"
#import "UserLoginedInfo.h"
#import "JSON.h"
#import "UIView+Toast.h"
#import "UIColor+Utility.h"
#import "MyAnimation.h"
#import "DeviceAddViewController.h"
#import "PlistManager.h"
#import "SkywareDeviceManagement.h"
#import "TCPManager.h"
#import "Reachability.h"
#import "PureLayout.h"
#import "skySDK.h"
#import "DeviceEasyLinkViewController.h"
#import "SendCommandManager.h"
#import "PopHintView.h"
#import "UIWindow+Extension.h"
#import "NSString+NSStringHexToBytes.h"

typedef NS_ENUM(NSInteger, LoadView) {
    MainLoad = 0,
    MainLoadFail = 1,
    MainView = 2,
};
@interface AirPurifierViewController ()
{
    DeviceView *deviceView;
    DeviceView *firstView;
    UILocalNotification *localNotifFilter;//本地通知
    DeviceVo * pushCurrentDeviceVo;
}
@property (nonatomic,copy) NSMutableArray *statusList;
@property (nonatomic,copy) NSMutableArray *deviceList;//设备列表
@property (nonatomic,copy) NSMutableArray *arrSn;//心跳包
@property (nonatomic,copy) NSMutableArray *onlineDevices;//pm通知

@end

//static NSInteger tag=0;
static NSInteger deviceTotal=0; //设备个数
static NSInteger mCurrentLayoutState;
static NSInteger  snTag = 0;//发送心跳包累计次数


@implementation AirPurifierViewController
@synthesize deviceVFView;
@synthesize leftSwipeGestureRecognizer,rightSwipeGestureRecognizer;
@synthesize pageControl;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        MainDelegate.isFromRegister= NO;
        MainDelegate.isFromMain = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [PopHintView showAlertViewWithTitle:@"PM value" iconImage:@"alterPm"];
    [self registerObserver];
    [self createView];
    [self initMQTT];
    if ([MainDelegate isNetworkAvailable]) {
        [self downloadDevicesForView];
    }else{//没有网络
        [self hideOtherTwoViews:MainLoadFail];
    }
    [self addGesture];
    [self downSettingInfo];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self checkIsThereDevice];
    [NotificationCenter addObserver:self
                           selector:@selector(updateMainView)
                               name:EnterForegroundNotifacation
                             object:nil];   //后台进入前台
    [NotificationCenter addObserver:self
                           selector:@selector(reSubscribe)
                               name:NeedSubscribeNotifacation
                             object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (self.deviceList.count) {
        DeviceVo *de = [self.deviceList objectAtIndex:mCurrentLayoutState];
        [UserDefault setObject:de.deviceMac  forKey:@"currentDeviceIndex"];
        [UserDefault synchronize];
    }
    [NotificationCenter removeObserver:self name:EnterForegroundNotifacation object:nil];
    [NotificationCenter removeObserver:self name:NeedSubscribeNotifacation object:nil];
    [super viewWillDisappear:animated];
}


//检查是否有设备--如果没有，需要单独处理
-(void)checkIsThereDevice
{
    [SkywareDeviceManagement DeviceGetAllDevicesSuccess:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
        if ([result.message intValue] == 200) {
        }
        [self hideOtherTwoViews:MainView];
    } failure:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
        if([result.message  intValue] == 404) {//没有设备
            [self addNoDeviceCoverView];
        }else{
            [self.view makeToast:@"获取设备列表失败"];
        }
    }];
}

-(void)createView
{
    self.navBar.hidden = YES;
    _mainView.tag = MainView;
    _mainLoad.tag = MainLoad;
    _mainLoadFail.tag = MainLoadFail;
    [self.view addSubview:_mainLoadFail];
    [self.view addSubview:_mainLoad];
    firstView = [DeviceView instanceDeviceView];
    
    mCurrentLayoutState = 0;
    pageControl.numberOfPages = 1;
}

#pragma mark 初始化MQTT
-(void)initMQTT
{
    NSString *clientID = [NSString stringWithFormat:@"%@sixstar",[UIDevice currentDevice].identifierForVendor.UUIDString];
    self.client = [[MQTTClient alloc] initWithClientId:clientID];
    __weak typeof(self) weakSelf = self;
    [self.client setMessageHandler:^(MQTTMessage *message) {
        // the MQTTClientDelegate methods are called from a GCD queue.Any update to the UI must be done on the main queue
        NSDictionary *dic = [MainDelegate parseJsonData:message.payload];
        if ( [[weakSelf.arrSn lastObject] intValue] != [[dic objectForKey:@"sn"] intValue]) {
            if ([weakSelf.arrSn count] > 100) {
                [weakSelf.arrSn removeObjectsInRange:NSMakeRange(0, 50)];
            }
            [weakSelf.arrSn addObject:[NSString stringWithFormat:@"%d",[[dic objectForKey:@"sn"] intValue]]];
            dispatch_async(dispatch_get_main_queue(), ^{
//                 NSLog(@"大循环返回%@",dic);
                [weakSelf updateViewFromPush:dic];
            });
        }
    }];
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

-(void)hideOtherTwoViews:(NSInteger )tag
{
    if (tag == MainLoad) {
        if (!_mainLoadFail.hidden) {
            _mainLoadFail.hidden = YES;
        }
        if (!_mainView.hidden) {
            _mainView.hidden = YES;
        }
        if (_mainLoad.hidden) {
              _mainLoad.hidden = NO;
        }
    }else if( tag == MainLoadFail ){
        if (!_mainLoad.hidden) {
            _mainLoad.hidden = YES;
        }
        if (!_mainView.hidden) {
            _mainView.hidden = YES;
        }
        if (_mainLoadFail.hidden) {
            _mainLoadFail.hidden = NO;
        }

    }else if(tag == MainView){
        if (!_mainLoadFail.hidden) {
            _mainLoadFail.hidden = YES;
        }
        if (!_mainLoad.hidden) {
            _mainLoad.hidden = YES;
        }
        if (_mainView.hidden) {
            _mainView.hidden = NO;
        }
    }
}
#pragma mark 左右滑动切换
- (void)Fling:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        deviceVFView.mWhichChild = mCurrentLayoutState;
        if ([self.deviceList count] >1) {
            if (mCurrentLayoutState != pageControl.numberOfPages - 1) {
                mCurrentLayoutState += 1;
            } else {
                mCurrentLayoutState = 0;
            }
            pageControl.currentPage = mCurrentLayoutState;
            DeviceVo * deviceVo = [self.deviceList objectAtIndex:mCurrentLayoutState];
            [self showStatusAndHomeImgOnDeviceVo:deviceVo onBtnControl:_btnControl];
            [deviceVFView showNext];
            _mainTitle.text = ((DeviceVo *)[self.deviceList objectAtIndex:mCurrentLayoutState]).deviceName;
        }
    }
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        deviceVFView.mWhichChild = mCurrentLayoutState;
        if ([self.deviceList count] >1) {
            if (mCurrentLayoutState != 0) {
                mCurrentLayoutState -= 1;
            } else {
                mCurrentLayoutState = pageControl.numberOfPages-1;
            }
            pageControl.currentPage = mCurrentLayoutState;
            DeviceVo * deviceVo = [self.deviceList objectAtIndex:mCurrentLayoutState];
            [self showStatusAndHomeImgOnDeviceVo:deviceVo onBtnControl:_btnControl];
            [deviceVFView showPrevious];
            _mainTitle.text = ((DeviceVo *)[self.deviceList objectAtIndex:mCurrentLayoutState]).deviceName;
            
        }
    }
}

#pragma mark----获取设备列表-------
-(void)downloadDevicesForView
{
//    [self hideOtherTwoViews:MainView];
//                    [self.deviceList removeAllObjects];
//                    for (UIView *view in deviceVFView.subviews) {
//                        [view removeFromSuperview];
//                    }
//    [self initNoView];
    
#warning ---- 假数据
//        NSDictionary *dictionaryOne = @{@"device_id":@"100471",@"device_mac":@"ACCF2365FBD8",@"device_sn":@"123456",@"device_name":@"我的房间",
//                                     @"device_online":@"1",
//                                    @"device_data":@"EAEgBiEDMQoyAmwzAa40AD5BAEIAQwNEHkUH0FAUUQAAAABSAAAAAFMAAAAAYQPoYgNxAHNyABtzAA10AAF1Ahx2AAV3ADUBB9gBAwUBDwAAYwAK",
//                                     @"city":@"北京",
//                                     @"province":@"北京"};
//        NSDictionary *dictionaryTwo = @{@"device_id":@"222",@"device_mac":@"2222",@"device_sn":@"123456",@"device_name":@"我的卧室",
//                                 @"device_online":@"1",
//                                 @"device_data":@{@"pw":@"1",@"tm":@"1222",@"lc":@"1",@"fa":@"2",@"md":@"1",@"th":@"2850",@"pm":@" 5001",@"pmI":@"30",@"pmO":@"50",@"tempI":@"26",@"tempO":@"34"},
//                                 };
//        DeviceVo *vo= [[DeviceVo alloc] initWithDic:dictionaryOne];
//        NSString *test= @"0x310x1f0x100x010x750x010x01";
    
//        vo.deviceData = [[DeviceData alloc] initWithBase64String:test];
//        DeviceVo *two = [[DeviceVo alloc] initWithDic:dictionaryTwo];
//        [self.deviceList insertObject:vo atIndex:0];
//        [self.deviceList insertObject:two atIndex:1];
//    
//        MainDelegate.allDeviceList = self.deviceList;//全局变量保存
//        [self initDeviceView];
//        [self hideOtherTwoViews:MainView];
#warning---- end
    [SkywareDeviceManagement DeviceGetAllDevicesSuccess:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
        if ([result.message intValue] == 200) {
            NSArray *jsonArray =result.result;
            //首先清空列表
            [self.deviceList removeAllObjects];
            [self.deviceList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [self.client unsubscribe:kTopic(((DeviceVo *)obj).deviceMac) withCompletionHandler:^{
                    NSLog(@"取消订阅设备------%@",((DeviceVo *)obj).deviceMac);
                }];
            }];
            for (int i=0; i< jsonArray.count; i++) {
                NSDictionary *dictionary = [jsonArray objectAtIndex:i];
                DeviceVo *vo= [[DeviceVo alloc] initWithDic:dictionary];
                if ([vo.deviceOnline isEqualToString:@"1"] ) {
                    [self.onlineDevices addObject:vo];
                }
                [self.deviceList insertObject:vo atIndex:i];
            }
            MainDelegate.allDeviceList = self.deviceList;//全局变量保存
            dispatch_async(dispatch_get_main_queue(), ^{
                [self initDeviceView];
            });
            [self connectToHostDevices:self.deviceList count:0];//添加订阅设备
        }
        [self hideOtherTwoViews:MainView];
    } failure:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
        if([result.message  intValue] == 404) {//没有设备
            [self hideOtherTwoViews:MainView];
            [self.deviceList removeAllObjects];
            for (UIView *view in deviceVFView.subviews) {
                [view removeFromSuperview];
            }
            [self initNoView];
        }else{
            [SVProgressHUD dismiss];
            if([result.message  intValue] == 404) {//没有设备
                [self addNoDeviceCoverView];
            }else{
                [self.view makeToast:@"获取设备列表失败"];
            }
        }
    }];
}


//修改设备城市信息，刷新界面
-(void)updateMainView
{
    [SVProgressHUD show];
    [SkywareDeviceManagement DeviceGetAllDevicesSuccess:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
        if ([result.message intValue] == 200) {
            NSArray *jsonArray = result.result;
            if([jsonArray count] > 0)
            {
                [self.deviceList removeAllObjects];
                [self.deviceList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [self.client unsubscribe:kTopic(((DeviceVo *)obj).deviceMac) withCompletionHandler:^{
                    }];
                }];
                for (int i=0; i<[jsonArray count]; i++) {
                    NSDictionary *dictionary = [jsonArray objectAtIndex:i];
                    DeviceVo *vo= [[DeviceVo alloc] initWithDic:dictionary];
                    [self.deviceList insertObject:vo atIndex:i];
                }
                [self initDeviceView];
                [self connectToHostDevices:self.deviceList count:0];//添加订阅设备
            }
        }
    } failure:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
        if([result.message  intValue] == 404) {//没有设备
            
        }else{
            [self.view makeToast:@"获取设备列表失败"];
        }
    }];
}

-(void)reSubscribe
{
    if (self.deviceList.count) {
        NSLog(@"the device connect again");
        if (self.client) {
            [self connectToHostDevices:self.deviceList count:0];
        }else{
            [self initMQTT];
        }
    }
}
#pragma mark MQTT连接 Host---
-(void)connectToHostDevices:(NSMutableArray *)deviceMacs count:(NSInteger)requestCount
{
    [self.client connectToHost:kMQTTServerHost completionHandler:^(MQTTConnectionReturnCode code) {
        if (code == ConnectionAccepted) {
           [deviceMacs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
              [self.client subscribe:kTopic(((DeviceVo*)(obj)).deviceMac) withCompletionHandler:^(NSArray *grantedQos) {
                  NSLog(@"---添加订阅设备---%@",((DeviceVo*)(obj)).deviceMac);
                  //如果返回的时间与我当前时间不同，则发送校准时间的指令
                  [SendCommandManager sendCalibrateTimeCmd:obj];
                  
              }];
           }];
        }
        else{
            [self.client reconnect];
            if(requestCount < 3)
            {
                [self connectToHostDevices:deviceMacs count:requestCount + 1];
            }
        }
    }];
}

#pragma mark initNoView (没有设备情况下)
- (void)initNoView
{
    self.pageControl.hidden = YES;
    _mainTitle.text = @"六星新风机";
    _bottom_View.hidden = YES;
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
    [hintView autoSetDimensionsToSize:CGSizeMake(kScreenW - 80, 100)];
    
    UIImageView *bgImgView = [UIImageView newAutoLayoutView];
    [hintView addSubview:bgImgView];
    bgImgView.image = [UIImage imageNamed:@"text_border_noDevice"];
    [bgImgView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    UILabel *lblText = [UILabel newAutoLayoutView];
    [hintView addSubview:lblText];
    [lblText autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [lblText autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [lblText autoSetDimension:ALDimensionHeight toSize:80.0];
    [lblText autoSetDimensionsToSize:CGSizeMake(kScreenW -140 , 80)];
    lblText.textAlignment = NSTextAlignmentCenter;
    lblText.numberOfLines = 0;
    lblText.font = [UIFont systemFontOfSize:20];
    lblText.textColor = [UIColor whiteColor];
    lblText.text = NoDeviceHint;
    [[UIWindow getCurrentWindow] addSubview:coverTransparentView];
    [coverTransparentView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 50, 0)];
}

#pragma mark initView
-(void)initDeviceView
{
    deviceTotal = self.deviceList.count;
    //设置UIPageControl
    pageControl.numberOfPages = deviceTotal;
    pageControl.currentPage = 0;
    mCurrentLayoutState = 0;
    pageControl.backgroundColor = [UIColor clearColor];
    [[deviceVFView subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    [self.deviceList enumerateObjectsUsingBlock:^(DeviceVo * deviceVo, NSUInteger idx, BOOL *stop) {
        DeviceView *view = [DeviceView instanceDeviceView];
        view.deviceModel = deviceVo;
        if ([deviceVo.deviceOnline intValue] == DeviceOnlineOn) {
            if ([deviceVo.deviceData.btnPower intValue] == DevicePowerOn) {// 显示关机
                _btnControl.tag = ControlClose;
                _bottom_View.hidden = YES;
                [self setImageOnControllButton:_btnControl WithDefaultImage:@"btn_close_default" seletecdImage:@"btn_close_pressed"];
            }else{//显示开机
                _btnControl.tag = ControlOpen;
                _bottom_View.hidden = NO;
                [self setImageOnControllButton:_btnControl WithDefaultImage:@"btn_close_default" seletecdImage:@"btn_close_pressed"];
            }
        }else{//设备离线
            _btnControl.tag = ControlWifi;
            _bottom_View.hidden = YES;
            [self setImageOnControllButton:_btnControl WithDefaultImage:@"btn_wifi_default" seletecdImage:@"btn_wifi_pressed"];
        //显示设备离线
//            [self showDeviceOffline];
        }
        view.tag = 100+idx;
        [deviceVFView insertSubview:view atIndex:idx];
    }];
//    [deviceVFView showChildFirstView:[deviceVFView viewWithTag:100+mCurrentLayoutState]];
    [self showCurrentView];
    self.pageControl.currentPage = mCurrentLayoutState;
    _mainTitle.text = ((DeviceVo *)[self.deviceList objectAtIndex:mCurrentLayoutState]).deviceName;
    if (pageControl.numberOfPages > 1) {
        self.pageControl.hidden = NO;
    }else{
        self.pageControl.hidden = YES;
    }
}

-(void)showCurrentView
{
    NSString *deviceMac = [UserDefault objectForKey:@"currentDeviceIndex"];
    for (int i = 0 ; i < self.deviceList.count; i++) {
        DeviceVo *deviceVo = [self.deviceList objectAtIndex:i];
        if ([deviceVo.deviceMac isEqualToString:deviceMac]) {
            mCurrentLayoutState = i;
            break;
        }
    }
    [deviceVFView showChildFirstView:[deviceVFView viewWithTag:100+mCurrentLayoutState]];
    [self showStatusAndHomeImgOnDeviceVo:[self.deviceList objectAtIndex:mCurrentLayoutState] onBtnControl:_btnControl];
}

- (IBAction)connectAgain:(id)sender {
}

- (IBAction)cancel:(id)sender {
}
#pragma mark 设置页面
- (IBAction)onShowDetailview:(id)sender {
    DetailViewController  *detailManageViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    detailManageViewController.mqClient = self.client;
    [self.navigationController pushViewController:detailManageViewController animated:YES];
}

#pragma mark 添加设备，切换控制/主视图
- (IBAction)changeView:(id)sender {
    if ([sender tag] == ControlAdd) {
        //移除蒙版
        UIView *bgView = [UIWindow getCurrentWindow];
        for (UIView *view in [bgView subviews]) {
            if (view.tag == 10001) {
                [view removeFromSuperview];
            }
        }
        DeviceAddViewController *deviceController = [[DeviceAddViewController alloc] initWithNibName:@"DeviceAddViewController" bundle:nil];
        MainDelegate.isFromWifi= NO;
        [self.navigationController pushViewController:deviceController animated:YES];
    }
    else if([sender tag] == ControlOpen){
        // 2有数据时没有开启设备是发送指令作用
        _bottom_View.hidden = NO;
        _lblClosing.text = @"开机中";
        _lblClosing.hidden = NO;
        _btnControl.hidden = YES;
        [self sendOpenOrCloseToView:((DeviceVo *)[self.deviceList objectAtIndex:mCurrentLayoutState]) commandString:@"1001"];
    }else if ([sender tag] == ControlClose){
        _bottom_View.hidden = NO;
        _lblClosing.hidden = NO;
        _lblClosing.text = @"关机中";
        _btnControl.hidden = YES;
        [self sendOpenOrCloseToView:((DeviceVo *)[self.deviceList objectAtIndex:mCurrentLayoutState]) commandString:@"1000"];
    }
    else if([sender tag] == ControlWifi){
        [self showAlterView];
    }
}

-(void)showAlterView
{
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"设备已离线" message:DeviceOffLine delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新配置WiFi",@"刷新", nil];
    [view show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) { //重新配网
        DeviceEasyLinkViewController *easyLink =[[DeviceEasyLinkViewController alloc] initWithNibName:@"DeviceEasyLinkViewController" bundle:nil];
        easyLink.deviceSn = ((DeviceVo *)[self.deviceList objectAtIndex:mCurrentLayoutState]).deviceSn;
        easyLink.isFromWifi = YES;
        [self.navigationController pushViewController:easyLink animated:YES];
    }
    if (buttonIndex == 2) { //刷新列表
        [self updateMainView];
    }
    
}

#pragma mark 控制设备指令
-(void)sendOpenOrCloseToView:(DeviceVo *)deviceVo commandString:(NSString *)cmdString
{
    //处理开关机指令过慢
//    if (btnTimer!=nil) {
//        [btnTimer invalidate];
//    }
//    [self startTimer];
    [self sendCmdWifiToMCU:deviceVo withCommnd:cmdString];
}


-(void)sendCmdWifiToMCU:(DeviceVo *)deviceVo withCommnd:(NSString *)cmdString
{
    if (!MainDelegate.isNetworkAvailable) return;
    snTag = snTag + 1;
    [SendCommandManager sendDeviceOpenCloseCmd:deviceVo];
}


-(void)showStatusAndHomeImgOnDeviceVo:(DeviceVo *)deviceVo onBtnControl:(UIButton*)btnControl
{
    if (mCurrentLayoutState < self.deviceList.count) {
        //小循环在线，大循环服务器不在线
        DeviceVo *deviceOn = (DeviceVo *)[self.deviceList objectAtIndex:mCurrentLayoutState];
        if ([deviceOn.deviceMac isEqualToString:deviceVo.deviceMac]) {
            _lblClosing.hidden = YES;
            _btnControl.hidden = NO;
            if ([deviceVo.deviceOnline intValue] != DeviceOnlineOn) { //设备离线
                dispatch_async(dispatch_get_main_queue(), ^{
                    btnControl.tag = ControlWifi;
                    _bottom_View.hidden = YES;
                    [self setImageOnControllButton:btnControl WithDefaultImage:@"btn_wifi_default" seletecdImage:@"btn_wifi_pressed"];
                });
            }
            else  if ([deviceVo.deviceOnline intValue] == DeviceOnlineOn) {
                if ( [deviceVo.deviceData.btnPower intValue] == DevicePowerOn) {
                    btnControl.tag = ControlClose;
                    _bottom_View.hidden = YES;
                    _bottom_View.backgroundColor = [UIColor clearColor];
                    [self setImageOnControllButton:btnControl WithDefaultImage:@"btn_close_default" seletecdImage:@"btn_close_pressed"];
                }else {
                    btnControl.tag = ControlOpen;
                    _bottom_View.hidden = NO;
                    _bottom_View.backgroundColor = [UIColor colorWithHex:0xd00212 alpha:1.0];
                    [self setImageOnControllButton:btnControl WithDefaultImage:@"btn_close_default" seletecdImage:@"btn_close_pressed"];
                }
            }
        }
    }
}

#pragma mark notification-----初次应用选取位置，保存位置信息
-(void) cityFirst:(NSNotification*) notification
{
    NSDictionary * city = (NSDictionary *)[notification object];//获取到传递的对象
    [UserDefault setObject:city forKey: [NSString stringWithFormat:@"%@-firstCity",[UserDefault objectForKey:LoginInfo][@"LoginUserName"]]];
    [UserDefault synchronize];
    [self downloadDevicesForView];
}

#pragma mark-- 大/小循环更新界面(推送)
-(void)updateViewFromPush:(NSDictionary*)deviceInfo
{
//{"sn":6958,"cmd":"upload","mac":"ACCF232C6F26","data":["00 aa 0xag 0xbb 0xag"]}
//{"sn":6958,"cmd":"upload","mac":"ACCF232C6F26","device_online":0}
//    NSLog(@"pushMessage=%@",deviceInfo);
    DeviceVo * deviceVo=nil;
    if ([deviceInfo objectForKey:@"mac"] && [self.deviceList count]>0)//大循环
    {
        [self.onlineDevices removeAllObjects];
        for (int i=0;  i <deviceTotal; i++) {
            deviceVo= (DeviceVo *)[self.deviceList objectAtIndex:i];
            if ([deviceVo.deviceMac isEqualToString:deviceInfo[@"mac"]]) { //只更新当前设备的界面
                if (deviceInfo[@"device_online"]) { //设备掉线的时候才返回
                    deviceVo.deviceOnline =[NSString stringWithFormat:@"%d",[deviceInfo[@"device_online"] intValue]] ;
                }else{
                    deviceVo.deviceOnline = @"1";////掉线之后再上线
                }
                    if (deviceInfo[@"data"]) {
                        NSArray *strArray = deviceInfo[@"data"];
                        NSData* dataFromString = [[NSData alloc] initWithBase64EncodedString:strArray.firstObject options:0];//base64解码
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
                        deviceVo.deviceData = [[DeviceData alloc] initWithBase64String:hexStr];
                    }
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
//                    }
                }
            }
        }
}

-(void)startCheck
{
    [self performSelector:@selector(checkFilterAlert) withObject:nil afterDelay:3];
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
    [SkywareUserManagement UserGetUserWithParamesers:[NSArray new] Success:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
        if ([result.message intValue] == 200) {
            NSArray *arr = result.result;
            NSDictionary *dicNotice = [[arr objectAtIndex:0][@"user_prefer"] JSONValue];
            [ModelNotice sharedModelNotice].notice_pm = dicNotice[@"notice_pm"];
            [ModelNotice sharedModelNotice].notice_pm_value = dicNotice[@"notice_pm_value"];
            [ModelNotice sharedModelNotice].notice_filter = dicNotice[@"notice_filter"];
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

#pragma mark tcp-socket
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"连接到:%@",host);
    [sock readDataWithTimeout:-1 tag:0];
}
-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"socketDidWriteDataWithTag");
}
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
}
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *newMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"小循环返回%@:%@",sock.connectedHost,newMessage);
    NSDictionary *dic = [MainDelegate parseJsonData:data];
    [sock readDataWithTimeout:-1 tag:0];
    if ([[dic allKeys] containsObject:@"mac"]) {
        if ( [[self.arrSn lastObject] intValue] != [[dic objectForKey:@"sn"] intValue]) {
            [self.arrSn addObject:[NSString stringWithFormat:@"%d",[[dic objectForKey:@"sn"] intValue]]];
             [self updateViewFromPush:dic];
        }
    }
}



#pragma mark - Observer Management
- (void)registerObserver
{
    [NotificationCenter addObserver:self
                           selector:@selector(cityFirst:)
                               name:CityFirstdNotification
                             object:nil];
    [NotificationCenter addObserver:self
                           selector:@selector(updateMainView)
                               name:AirDeviceRemovedNotification
                             object:nil];
    [NotificationCenter addObserver:self
                           selector:@selector(updateMainView)
                               name:AirDeviceAddedNotification
                             object:nil];
    [NotificationCenter addObserver:self
                           selector:@selector(updateMainView)
                               name:AirDeviceChangedNotification
                             object:nil];
    [NotificationCenter addObserver:self
                           selector:@selector(downloadDevicesForView)
                               name:AirDeviceAllDelete
                             object:nil];
    
}
-(void)removeObserver
{
    [NotificationCenter removeObserver:self name:CityFirstdNotification object:nil];
    [NotificationCenter removeObserver:self name:AirDeviceRemovedNotification object:nil];
    [NotificationCenter removeObserver:self name:AirDeviceAddedNotification object:nil];
    [NotificationCenter removeObserver:self name:AirDeviceChangedNotification object:nil];
    [NotificationCenter removeObserver:self name:AirDeviceAllDelete object:nil];
}

- (void)dealloc
{
    [self.client disconnectWithCompletionHandler:^(NSUInteger code) {
        NSLog(@"MQTT is disconnected");
    }];//大循环
    [self removeObserver];
    [skySDK stopTCPConnect];//小循环
}
#pragma  mark 懒加载
-(NSMutableArray *)deviceList{
    if (!_deviceList) {
        _deviceList = [NSMutableArray array];
    }
    return _deviceList;
}
-(NSMutableArray *)arrSn{
    if (!_arrSn) {
        _arrSn = [NSMutableArray array];
    }
    return _arrSn;
}

-(NSMutableArray *)onlineDevices
{
    if (!_onlineDevices) {
        _onlineDevices = [NSMutableArray new];
    }
    return _onlineDevices;
}

@end
