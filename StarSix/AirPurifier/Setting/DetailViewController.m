//
//  DetailViewController.m
//  AirPurifier
//
//  Created by bluE on 14-8-18.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import "DetailViewController.h"
#import "AlertBox.h"
#import "AppDelegate.h"
#import "UIColor+Utility.h"
#import "UIView+Toast.h"
#import "Util.h"
#import "UserAccountViewController.h"
#import "PopHintView.h"
#import "TimeModeTableViewController.h"
#import "IntelligenceViewController.h"
#import "SettingTableViewController.h"
#import "PureLayout.h"
#import <DeviceManagerViewController.h>
#import <SystemFeedBackViewController.h>
#import <SystemHelpViewController.h>
#import "SkywareUserManager.h"
#import "UIImageView+WebCache.h"
#import "SetShowTimerModel.h"
#import "SIAlertView.h"
#import "CommandRepeatedTimer.h"
#import "CommandSave.h"
#import "SendCommandManager.h"
#import "AddDeviceViewController.h"
#import "DeviceSettingTableViewCell.h"
#import "SystemAboutViewController.h"

@interface DetailViewController () <SwitchValueChangedDelegate,QRCodeViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,AlertBoxDelegate,UIAlertViewDelegate>
{
    NSArray *_arrSectionOne;
    NSArray *_arrSectionTwo;
    
    BOOL pmAlertOnOff;
    BOOL filterAlertOnOff;
    NSString *deviceId;
}

@property (strong,nonatomic) NSMutableArray *deviceArraylist;

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavBar];
    [self addUserInfoManagerGroup];
    [self addDeviceManager];
    [self addDeviceSetting];
    [self addOtherToolGroup];
    [self registerObserver];
    [self downLoadUserInfo];
    [kNotificationCenter addObserver:self selector:@selector(MQTTMessage:) name:kSkywareNotificationCenterCurrentDeviceMQTT object:nil];
    [kNotificationCenter addObserver:self selector:@selector(refreshCalculateTime) name:NotifactionUpdateCaculateTime object:nil];
}
-(void)refreshCalculateTime
{
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [SVProgressHUD show];
    [self downloadDeviceList];
}

#pragma mark - MQTT 消息推送
- (void)MQTTMessage:(NSNotification *)not
{
    SkywareMQTTModel *model = [not.userInfo objectForKey:kSkywareMQTTuserInfoKey];
    DeviceVo *deviceInfo = nil;
    if (model.mac && [self.deviceArraylist count]>0)
    {
        for (int i=0; i<self.deviceArraylist.count; i++) {
            deviceInfo= (DeviceVo *)[self.deviceArraylist objectAtIndex:i];
            if ([deviceInfo.deviceMac isEqualToString:model.mac]) {
                if ([self isVisible]) {
                    //刷新Cell界面
                    NSString *backString = [[model.data firstObject] toHexStringFromBase64String];
                    NSLog(@"收到的设备上报指令为：%@",backString);
                    CommandSave *cmd = [CommandSave readCommandSave];
                    if ([[backString lowercaseString] rangeOfString:[NSString stringWithString:cmd.cmdCode]].location != NSNotFound) {
                            SVProgressHUD.minimumDismissTimeInterval = 1;
                            //已经开启定时
                        if ([CommandRepeatedTimer sharedCommandRepeatedTimer].isStarted) {
                            [SVProgressHUD showSuccessWithStatus:@"校准成功"];
                        }
                        //停止定时器
                        [[CommandRepeatedTimer sharedCommandRepeatedTimer] stopTimer];
                    }
                }
            }
        }
        dispatch_main_async_safe(^{
            [self.tableView reloadData];
        });
    }
}

- (void) addUserInfoManagerGroup
{
    BaseIconItem *iconItem = [BaseIconItem createBaseCellItemWithIconNameOrUrl:@"view_userface" AndTitle:@"匿名" SubTitle:nil ClickCellOption:^{
        UserAccountViewController *account = [[UserAccountViewController alloc] init];
        [self.navigationController pushViewController:account animated:YES];
    } ClickIconOption:nil];
    BaseCellItemGroup *group1 = [BaseCellItemGroup createGroupWithHeadView:iconItem.sectionView AndFootView:iconItem.sectionView OrItem:@[iconItem]];
    [self.dataList insertObject:group1 atIndex:0];
    // 加载网络用户信息
    [self getUserInfo];
}
- (void) getUserInfo
{
    [SkywareUserManager UserGetUserWithParamesers:nil Success:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
        SkywareUserInfoModel *user = [SkywareUserInfoModel mj_objectWithKeyValues:[result.result firstObject]];
        NSString *user_icon = (user.user_img.length == 0 || user == nil )? @"view_userface" :user.user_img;
        NSString *user_name = (user.user_name.length == 0 || user == nil )? @"匿名" : user.user_name;
        NSString *user_phone = (user.user_phone.length == 0 || user == nil )? @"" :user.user_phone;
        BaseIconItem *iconItem = [BaseIconItem createBaseCellItemWithIconNameOrUrl:user_icon AndTitle:user_name SubTitle:nil ClickCellOption:^{
            UserAccountViewController *account = [[UserAccountViewController alloc] init];
            account.user_name = user_name;
            account.user_img = user_icon;
            account.user_phone = user_phone;
            [self.navigationController pushViewController:account animated:YES];
        } ClickIconOption:nil];
        BaseCellItemGroup *group1 = [BaseCellItemGroup createGroupWithHeadView:iconItem.sectionView AndFootView:iconItem.sectionView OrItem:@[iconItem]];
        [self.dataList removeObjectAtIndex:0];
        [self.dataList insertObject:group1 atIndex:0];
        [self.tableView reloadData];
    } failure:^(SkywareResult *result) {
        NSLog(@"请求失败");
    }];
}

-(void)addDeviceManager{
    BaseArrowCellItem *deviceManagerItem = [BaseArrowCellItem  createBaseCellItemWithIcon:@"deviceManager" AndTitle:@"设备管理" SubTitle:nil ClickOption:^{
        DeviceManagerViewController *deviceManager = [[DeviceManagerViewController alloc] init];
        [self.navigationController pushViewController:deviceManager animated:YES];
    }];
    BaseArrowCellItem *addDeviceItem = [BaseArrowCellItem  createBaseCellItemWithIcon:@"deviceAdd" AndTitle:@"添加设备" SubTitle:nil ClickOption:^{
        // 添加设备操作
        AddDeviceViewController *deviceVC = [[AddDeviceViewController alloc] init];
        deviceVC.addDevice = YES;
        [self.navigationController pushViewController:deviceVC animated:YES];
    }];
    BaseArrowCellItem *scanDeviceItem = [BaseArrowCellItem  createBaseCellItemWithIcon:@"more_deviceScan" AndTitle:@"扫一扫" SubTitle:nil ClickOption:^{
        // 扫描二维码，调入二维码扫描
        QRCodeViewController *readCode = [[QRCodeViewController alloc] init];
        readCode.delegate = self;
        [MainDelegate.navigationController presentViewController:readCode animated:YES completion:nil];
    }];
    BaseCellItemGroup *group2 = [BaseCellItemGroup createGroupWithItem:@[deviceManagerItem,addDeviceItem,scanDeviceItem]];
    [self.dataList addObject:group2];
}



-(void)addDeviceSetting{
    BaseArrowCellItem *filter = [BaseArrowCellItem  createBaseCellItemWithIcon:@"deviceFilter" AndTitle:@"除尘周期提醒" SubTitle:nil ClickOption:nil];
    BaseArrowCellItem *airQulity = [BaseArrowCellItem  createBaseCellItemWithIcon:@"deviceAir" AndTitle:@"空气质量报警" SubTitle:nil ClickOption:nil];
    BaseArrowCellItem *calculateTime = [BaseArrowCellItem createBaseCellItemWithIcon:@"deviceTimer" AndTitle:@"校准时间" SubTitle:@"" ClickOption:^{
        if(self.deviceArraylist.count == 0){ //无设备
            [PopHintView showViewWithTitle:@"您还未添加设备"];
        }else if(self.deviceArraylist.count == 1){ //一台设备
            [self sendCalculateTimeDevice:self.deviceArraylist.firstObject];
        }else if (self.deviceArraylist.count > 1) { //多台设备
            //弹出选择框
            SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:nil andMessage:nil];
            [self.deviceArraylist enumerateObjectsUsingBlock:^(DeviceVo * deviceInfo, NSUInteger idx, BOOL * _Nonnull stop) {
                [alertView addButtonWithTitle:deviceInfo.deviceName
                                         type:SIAlertViewButtonTypeDefault
                                      handler:^(SIAlertView *alertView) {
                                          //发送指令
                                          [self sendCalculateTimeDevice:deviceInfo];
                                      }];
            }];
            [alertView addButtonWithTitle:@"取消" type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *alertView) {
                [alertView dismissAnimated:YES];
            }];
            [alertView show];
        }
    }];
    BaseArrowCellItem *time = [BaseArrowCellItem  createBaseCellItemWithIcon:@"deviceTime" AndTitle:@"定时" SubTitle:@"test" ClickOption:^{
        //如果只有一台设备，则直接进入定时设置界面，否则跳转到设备列表界面，选择指定设备进行设置
        if(self.deviceArraylist.count == 0){ //无设备
            [PopHintView showViewWithTitle:@"您还未添加设备"];
        }else if (self.deviceArraylist.count == 1){//只有一台设备
            TimeModeTableViewController *tmVC = [[TimeModeTableViewController alloc] init];
            tmVC.deviceVo = [self.deviceArraylist firstObject];
            [self.navigationController pushViewController:tmVC animated:YES];
        }else{//添加了多台设备
            SettingTableViewController *setVC = [[SettingTableViewController alloc] init];
            setVC.isTime = YES;
            [self.navigationController pushViewController:setVC animated:YES];
        }
    }];
    BaseArrowCellItem *intellMode = [BaseArrowCellItem  createBaseCellItemWithIcon:@"deviceAuto" AndTitle:@"智能模式" SubTitle:nil ClickOption:^{
        if(self.deviceArraylist.count == 0){ //无设备
            [PopHintView showViewWithTitle:@"您还未添加设备"];
        }else if (self.deviceArraylist.count == 1){//只有一台设备
            IntelligenceViewController *inteligenceVC = [[IntelligenceViewController alloc] init];
            inteligenceVC.deviceVo = [self.deviceArraylist firstObject];
            [self.navigationController pushViewController:inteligenceVC animated:YES];
        }else{//添加了多台设备
            [self.navigationController pushViewController:[[SettingTableViewController alloc] init] animated:YES];
        }
    }];
    BaseCellItemGroup *group3 = [BaseCellItemGroup createGroupWithItem:@[filter,airQulity,calculateTime,time,intellMode]];
    [self.dataList addObject:group3];
}

//发送时间校准
-(void)sendCalculateTimeDevice:(DeviceVo *)deviceInfo
{
    //开启定时，存储命令缓存(先清空缓存）
    [[CommandRepeatedTimer sharedCommandRepeatedTimer] startTimer];
    [CommandRepeatedTimer sharedCommandRepeatedTimer].afterTimer = nil;
    [CommandRepeatedTimer sharedCommandRepeatedTimer].succeedTimer = nil;
    CommandSave *cmd = [[CommandSave alloc] init];
    cmd.mac = deviceInfo.deviceMac;
    cmd.cmdCode = @"01";
    cmd.time =@"";//暂留
    [CommandSave writeCommandSave:cmd];
    if (![(AppDelegate *)[UIApplication sharedApplication].delegate beforeSendBaseonWifiLock:deviceInfo]) {
        [[CommandRepeatedTimer sharedCommandRepeatedTimer] stopTimer];
        return;
    }
    [SVProgressHUD showWithStatus:@"时间校准中..."];
    [SendCommandManager sendCalibrateTimeCmd:deviceInfo];
}

-(void)addOtherToolGroup
{
    BaseArrowCellItem *helpItem = [BaseArrowCellItem  createBaseCellItemWithIcon:@"deviceHelp" AndTitle:@"帮助" SubTitle:nil ClickOption:^{
        SystemHelpViewController *helpVC = [[SystemHelpViewController alloc]init];
        [self.navigationController pushViewController:helpVC animated:YES];
    }];
    
    BaseArrowCellItem *feedbackItem = [BaseArrowCellItem  createBaseCellItemWithIcon:@"deviceFeedback" AndTitle:@"反馈" SubTitle:nil ClickOption:^{
        SystemFeedBackViewController *feedBack = [[SystemFeedBackViewController alloc] initWithNibName:@"SystemFeedBackViewController" bundle:nil];
        [self.navigationController pushViewController:feedBack animated:YES];
    }];
    
    BaseArrowCellItem *aboutItem = [BaseArrowCellItem  createBaseCellItemWithIcon:@"deviceAbout" AndTitle:@"关于" SubTitle:nil ClickOption:^{
        SystemAboutViewController *about = [[SystemAboutViewController alloc] initWithNibName:@"SystemAboutViewController" bundle:nil];
        [self.navigationController pushViewController:about animated:YES];
    }];
    
    BaseCellItemGroup *group3 = [BaseCellItemGroup createGroupWithItem:@[helpItem,feedbackItem,aboutItem]];
    [self.dataList addObject:group3];
}


-(void)synDownloadData
{
    if ([self isVisible]) {
        [SVProgressHUD show];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self downloadDeviceList];
    });
}
-(void)downloadDeviceList
{
    //1、如果设备数为0则无法设置定时
    //2、如果设备数为1则在当前界面设置
    //3、跳入设备列表界面进行设置
    [SkywareDeviceManager DeviceGetAllDevicesSuccess:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
        if (self.deviceArraylist.count) {
            [self.deviceArraylist removeAllObjects];
        }
        if ([result.message intValue] == 200) {
            NSArray *jsonArray =result.result;
            NSMutableString *deviceIdBuffer = [[NSMutableString alloc] init];
            for (int i=0; i< jsonArray.count; i++) {
                NSDictionary *dictionary = [jsonArray objectAtIndex:i];
                if (dictionary[@"device_id"]) {
                    [deviceIdBuffer appendString:dictionary[@"device_id"]];
                    [deviceIdBuffer appendString:@","];
                }
                DeviceVo *vo= [[DeviceVo alloc] initWithDic:dictionary];
                if ([dictionary objectForKey:@"device_data"]) {
                    if ([dictionary objectForKey:@"device_data"][@"updatetime"]) {
                        NSString *strData = dictionary[@"device_data"][@"updatetime"];
                        vo.deviceData.serverUpdateTime = [strData integerValue];
                    }
                }                
//                DeviceData *deviceM = [[DeviceData alloc] initWithBase64String: [vo.device_data[@"bin"] toHexStringFromBase64String]];
//                deviceM.serverUpdateTime = [obj.device_data[@"updatetime"] integerValue];
//                if ([manager.currentDevice.device_mac isEqualToString:obj.device_mac]) {
//                    ((DeviceData *)manager.currentDevice.device_data).serverUpdateTime = deviceM.serverUpdateTime;
//                }
    
                [self.deviceArraylist insertObject:vo atIndex:i];
            }
            [self.tableView reloadData];
        }
    } failure:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
        if([result.message  intValue] == 404) {//没有设备
            [self.tableView reloadData];
        }
    }];
}
-(void)setNavBar
{
    [self setNavTitle:@"更多"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"e8e8e8"];
}

#pragma mark 更新用户信息
- (void)userInfoUpdateStatus:(NSNotification *)notification
{
    [self downLoadUserInfo];
}

#pragma mark 获取用户信息
-(void)downLoadUserInfo
{
    [SkywareUserManager UserGetUserWithParamesers:[NSArray new] Success:^(SkywareResult *result) {
        if ([result.message intValue] == 200) {
            NSArray *arr = result.result;
            if (arr.count == 0) {
                return ;
            }
            if (arr.count > 0) {
                if ([arr objectAtIndex:0][@"user_prefer"]!= nil) {
                    NSDictionary *dicNotice=  [NSJSONSerialization JSONObjectWithData:[[arr objectAtIndex:0][@"user_prefer"] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                    [ModelNotice sharedModelNotice].notice_pm = dicNotice[@"notice_pm"];
                    [ModelNotice sharedModelNotice].notice_pm_value = dicNotice[@"notice_pm_value"];
                    [ModelNotice sharedModelNotice].notice_filter = dicNotice[@"notice_filter"];
                }
            }
            filterAlertOnOff =  [[ModelNotice sharedModelNotice].notice_filter  boolValue];
            pmAlertOnOff = [[ModelNotice sharedModelNotice].notice_pm  boolValue];
            [self.tableView reloadData];
        }
        [SVProgressHUD dismiss];
    } failure:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
    }];
}


#pragma mark UITableView Delegate ------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  self.dataList.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 3;
    }else if (section == 2){
        return 5;
    }else{
        return 3;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //单独处理 section2 里面设置
    if (indexPath.section == 2){
        if (indexPath.row == 0 || indexPath.row == 1) {
            DeviceSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceSettingTableViewCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"DeviceSettingTableViewCell" owner:nil options:nil] lastObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
            }
            if (indexPath.row == 0) {
                cell.imageView.image = [UIImage imageNamed:@"deviceFilter"];//加icon
                cell.lblTitle.text = @"除尘周期提醒";
            }else{
                cell.imageView.image = [UIImage imageNamed:@"deviceAir"];//加icon
               cell.lblTitle.text =  @"空气质量报警";
            }
            cell.row = indexPath.row;
            cell.model = [ModelNotice sharedModelNotice];
            return cell;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlterCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"AlterCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.font = [UIFont systemFontOfSize:17];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
           
            //增加了校准时间
            if (indexPath.row == 2) {
                cell.imageView.image = [UIImage imageNamed:@"deviceTimer"];//加icon
                cell.textLabel.text = @"时间校准";
            }else if(indexPath.row == 3){
                cell.imageView.image = [UIImage imageNamed:@"deviceTime"];//加icon
                cell.textLabel.text = @"定时";
            }else{
                cell.imageView.image = [UIImage imageNamed:@"deviceAuto"];//加icon
                cell.textLabel.text = @"智能模式";
            }
            if (self.deviceArraylist.count == 1) { //只有一台设备时
                DeviceVo *deviceVo = self.deviceArraylist.firstObject;
                if (indexPath.row == 2) {//校准时间
                    cell.detailTextLabel.text =  deviceVo.deviceData.calibarateTime;
                }else if(indexPath.row == 3){//定时是否开启
                    SetShowTimerModel *timeModel = [[SetShowTimerModel alloc] init];
                    cell.detailTextLabel.text = [timeModel getOneDeviceShowTimeText:deviceVo];
                }else{ //智能模式
                    FanModeModel *model = deviceVo.deviceData.fanModel;
                    if (model.status) {
                        cell.detailTextLabel.text = [model strFanMode];
                    }else{
                        cell.detailTextLabel.text = @"未开启";
                    }
                }
            }else{
                cell.detailTextLabel.text = @"";
            }
            return cell;
        }
    }else{
        BaseCellItemGroup *group = self.dataList[indexPath.section];
        BaseCellItem *item = group.item[indexPath.row];
        
        BaseTableViewCell *cell = nil;
        if ([item isKindOfClass:[BaseArrowCellItem class]]) {
            cell = [BaseTableViewCell createProfileBaseCellWithTableView:tableView andCellStyle:UITableViewCellStyleValue1];
        }else if([item isKindOfClass:[BaseSubtitleCellItem class]]){
            cell = [BaseTableViewCell createProfileBaseCellWithTableView:tableView andCellStyle:UITableViewCellStyleSubtitle];
        }else if ([item isKindOfClass:[BaseSwitchCellItem class]]){
            cell = [BaseTableViewCell createProfileBaseCellWithTableView:tableView andCellStyle:UITableViewCellStyleSubtitle];
        }else{
            cell = [BaseTableViewCell createProfileBaseCellWithTableView:tableView andCellStyle:UITableViewCellStyleDefault];
        }
        cell.items = item;
        return cell;
    }
}

#pragma mark 返回
- (void)onBack:(id)sender {
    [self.navigationController  popViewControllerAnimated:YES];
}

-(void)updateNotice:(NSDictionary *)param
{
    [SkywareUserManager UserEditUserWithParamesers:@{@"user_prefer":    [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:param options:0 error:nil] encoding:NSUTF8StringEncoding]} Success:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
        if ([result.message intValue] == 200) {
            NSLog(@"修改成功");
            [ModelNotice sharedModelNotice].notice_pm  = [param objectForKey:@"notice_pm"];
            [ModelNotice sharedModelNotice].notice_filter = [param objectForKey:@"notice_filter"];
        }
    } failure:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
    }];
}

- (void) onHelpCloseButtonOnClicked
{
    NSLog(@"helpCloseButtonClicked!");
}
-(void)switchValueChanged:(UISwitch *)mySwitch indexRow:(NSInteger)row
{
    if (row == 0) {//滤网
        filterAlertOnOff = mySwitch.isOn;
    }else{//pm值
        pmAlertOnOff = mySwitch.isOn;
    }
    NSDictionary *param = @{
                            @"notice_pm":[NSString stringWithFormat:@"%@",[NSNumber numberWithBool:pmAlertOnOff]],
                            @"notice_filter":[NSString stringWithFormat:@"%@",[NSNumber numberWithBool:filterAlertOnOff]],
                            @"notice_pm_value":@"50"
                            };
    [self updateNotice:param];
}


#pragma mark - QRCode 代理
- (void)ReaderCode:(QRCodeViewController *)readerViewController didScanResult:(NSString *)result
{
    [MainDelegate.navigationController dismissViewControllerAnimated:YES completion:nil];
    NSArray *deviceInfos = [result componentsSeparatedByString:@";"]; //deviceId,deviceName,当前时间 秒 数
    NSInteger preTime = 0;
    NSInteger nowTime = [[NSDate new] timeIntervalSince1970];
    NSString *deviceName=@"";
    if (deviceInfos.count >= 3) {
        deviceName = deviceInfos[1];
        deviceId = deviceInfos[0];
        preTime = [deviceInfos[2] integerValue];
    }
    if (isEmptyString(deviceId)) {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"二维码有误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return;
    }
    //判断二维码是否过期
    if ((nowTime - preTime) > 5*60) {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"二维码已失效" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return;
    }
    //从二维码中提取设备信息
    UIAlertView *QRCodeAlert = [[UIAlertView alloc ]initWithTitle:@"提示" message:[NSString stringWithFormat:@"是否要添加\"%@\"",deviceName] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    QRCodeAlert.delegate = self;
    [QRCodeAlert show];
}

- (void)ReaderCoderDidCancel:(QRCodeViewController *)readerViewController
{
    [MainDelegate.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=alertView.cancelButtonIndex) {  //被分享的设备，是否要绑定该设备
        //先查询设备判断设备是否锁定，如果锁定则不能绑定
        SkywareDeviceQueryInfoModel *deviceModel = [[SkywareDeviceQueryInfoModel alloc] init];
        deviceModel.id = deviceId; //从二维码中读取设备mac和设备id
        [SVProgressHUD showWithStatus:@"加载中..."];
        [SkywareDeviceManager DeviceQueryInfo:deviceModel  Success:^(SkywareResult *result) {
            if ([result.message intValue] == 200) {
                //检查设备是否锁定
                NSDictionary *deviceInfomation = result.result;
                DeviceVo *tempDevice = [[DeviceVo alloc] initWithDic:deviceInfomation];
                if ([tempDevice.deviceLock intValue]==0) {
                    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"设备已锁定，不能绑定" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil] show];
                     [SVProgressHUD dismiss];
                    return;
                }else{
                    //调绑定接口
                    [SkywareDeviceManager DeviceBindUserNew:@{@"deviceid":deviceId,@"userstate":@"1"} Success:^(SkywareResult *result) {
                        if ([result.message intValue] == 200) {
                            [SVProgressHUD showSuccessWithStatus:@"绑定成功"];
                        }else{
                            [SVProgressHUD dismiss];
                        }
                    } failure:^(SkywareResult *result) {
                        [SVProgressHUD dismiss];
                        if ([result.message intValue] == 403 ) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"您已绑定过该设备" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
                                [alertView show];
                            });
                        }
                        else{
                            [SVProgressHUD showErrorWithStatus:@"绑定设备失败"];
                        }
                    }];
                }
            }else{
                [SVProgressHUD dismiss];
            }
        } failure:^(SkywareResult *result) {
            [SVProgressHUD dismiss];
        }];
    }
}

#pragma mark - Observer Management
- (void)registerObserver
{
    [NotificationCenter addObserver:self selector:@selector(synDownloadData) name:DeviceModeChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfo) name:kEditUserNickNameRefreshTableView object:nil];
}

-(BOOL)isVisible{
    return (self.isViewLoaded && self.view.window);
}

-(void)dealloc{
    [NotificationCenter removeObserver:self];
}
-(NSMutableArray *)deviceArraylist
{
    if (_deviceArraylist == nil) {
        _deviceArraylist = [NSMutableArray new];
    }
    return _deviceArraylist;
}

@end
