//
//  DeviceManageViewController.m
//  AirPurifier
//
//  Created by bluE on 14-8-25.
//  Copyright (c) 2014年 skyware. All rights reserved.
//
#import "DeviceManageViewController.h"
#import "AlertBox.h"
#import "DeviceEditViewController.h"
#import "DeviceBindingViewController.h"
#import "AirPurifierAppDelegate.h"
#import "UserLoginedInfo.h"
#import "DeviceVo.h"
#import "DeviceVo.h"
#import "skySDK.h"
#import "SkywareDeviceManagement.h"
#import "DeviceDetailViewCell.h"



@interface DeviceManageViewController ()<UIActionSheetDelegate>
{
    DeviceVo *currentSelectedDevice;
    NSString *lockOrUnlock;
    BOOL isEditing;
}
@end
@implementation DeviceManageViewController
-(NSMutableArray *)listDevices{
    if (!_listDevices) {
        _listDevices = [NSMutableArray array];
    }
    return _listDevices;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addBarItemTitle:@"设备管理"];
    [self addBarBackButtonItemWithImageName:@"back_normal" selImageName:@"back_pressed" action:@selector(onBack:)];
    self.ListView.delegate =self;
    self.ListView.dataSource = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self refreshListView];//更改设备信息后刷新列表
}

- (void)editAirDevice:(UIButton *)sender
{
    currentSelectedDevice = self.listDevices[sender.tag];
    //锁定，解锁
    if ([currentSelectedDevice.deviceLock intValue] == DeviceLock) {
        lockOrUnlock =@"解锁";
    }
    else if([currentSelectedDevice.deviceLock intValue] == DeviceUnLock){
        lockOrUnlock =@"锁定";
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"编辑",@"解绑",lockOrUnlock, nil];
    [actionSheet showInView:self.view];
}

#pragma mark UIActionSheetDelegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==0) { //编辑
        DeviceEditViewController *deviceEditView = [[DeviceEditViewController alloc] initWithNibName:@"DeviceEditViewController" bundle:nil];
        deviceEditView.curDevice = currentSelectedDevice;
        [self.navigationController pushViewController:deviceEditView animated:YES];
    }
    else if(buttonIndex == 1){//解绑
        
        [AlertBox showBindLockView:UNBINDINGSTRING  delegate:self];
        
    }
    else if (buttonIndex == 2){//锁定，解锁
        if ([lockOrUnlock isEqual:@"解锁"]) {
            [AlertBox showBindLockView:UNLOCKINGSTRING delegate:self];
        }
        else if([lockOrUnlock isEqual:@"锁定"]){
            [AlertBox showBindLockView:LOCKINGSTRING delegate:self];
        }
        
        
    }
}
#pragma mark ---- UITableViewDelegate --UITableViewDataResource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listDevices count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"NormalTableViewCell";
    DeviceDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DeviceDetailViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    DeviceVo *deviceInfo = self.listDevices[indexPath.row];
    cell.lblDeviceName.text = deviceInfo.deviceName;
    if ([deviceInfo.deviceLock intValue]== DeviceLock) {
        cell.lblLockingIndicator.text = @"已锁定";
    }
    else if ([deviceInfo.deviceLock intValue] == DeviceUnLock) {
        cell.lblLockingIndicator.text = @"未锁定";
    }
    cell.btnSelected.tag = indexPath.row;
    
    [self addTarget:self action:@selector(editAirDevice:) onButton:cell.btnSelected];
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}


- (void)addTarget:(id)target action:(SEL)action onButton:(UIButton *)btn
{
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark
- (IBAction)onBack:(id)sender {
    [self.navigationController
     popViewControllerAnimated:YES];
}
#pragma mark  设备管理，编辑，解锁，解绑，取消
-(void)onBindLockUnlockOKButtonOnClicked:(NSString *)msgUnlockOrUnbinding
{
    if ([msgUnlockOrUnbinding isEqualToString:UNBINDINGSTRING] ) {//解绑设备
        if ([currentSelectedDevice.deviceLock intValue] == DeviceLock) {
            [AlertBox showWithMessage:@"设备已经锁定，不可以解除绑定"];
            return ;
        }
        [SkywareDeviceManagement DeviceReleaseUser:@[currentSelectedDevice.deviceId] Success:^(SkywareResult *result) {
            [SVProgressHUD dismiss];
            if ([result.message intValue] == 200) {
                [NotificationCenter postNotificationName:AirDeviceRemovedNotification object:nil];
                [SVProgressHUD showSuccessWithStatus:@"解除绑定成功"];
                [self.mqClient unsubscribe:kTopic(currentSelectedDevice.deviceMac) withCompletionHandler:^{
                    NSLog(@"取消订阅设备------%@",(currentSelectedDevice.deviceMac));
                }];//大循环
                [skySDK stopConnectDeviceBasedonMAC:currentSelectedDevice.deviceMac];//小循环
                [self refreshListView];
            }
        } failure:^(SkywareResult *result) {
            [SVProgressHUD showErrorWithStatus:@"解绑失败"];
        }];
    }
    
    else if([msgUnlockOrUnbinding isEqualToString:UNLOCKINGSTRING]
            || [msgUnlockOrUnbinding isEqualToString:LOCKINGSTRING] ){//解锁，锁定
        NSLog(@"UnLocking is successful!");
        DeviceVo *temp = [currentSelectedDevice copy];
        if ([temp.deviceLock intValue] == DeviceUnLock) {
            temp.deviceLock = [NSString stringWithFormat:@"%d",DeviceLock];
        }
        else if([temp.deviceLock intValue] == DeviceLock){
            temp.deviceLock = [NSString stringWithFormat:@"%d",DeviceUnLock] ;
        }
        SkywareDeviceUpdateInfoModel *device_info = [[SkywareDeviceUpdateInfoModel alloc] init];
        device_info.device_lock = temp.deviceLock;
        device_info.device_mac = temp.deviceMac;
        [SVProgressHUD show];
        [SkywareDeviceManagement DeviceUpdateDeviceInfo:device_info Success:^(SkywareResult *result) {
            [SVProgressHUD dismiss];
            if ([result.message intValue] == 200) {
                if ([currentSelectedDevice.deviceLock intValue] == DeviceUnLock) {
                    currentSelectedDevice.deviceLock = [NSString stringWithFormat:@"%d",DeviceLock];
                }
                else if([currentSelectedDevice.deviceLock intValue] == DeviceLock){
                    currentSelectedDevice.deviceLock = [NSString stringWithFormat:@"%d",DeviceUnLock] ;
                }
                [self refreshListView];
            }
        } failure:^(SkywareResult *result) {
            [SVProgressHUD showErrorWithStatus:@"修改设备信息失败"];
        }];
    }
}

//获取绑定设备列表
-(void)refreshListView
{
    [SkywareDeviceManagement DeviceGetAllDevicesSuccess:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
        if ([result.message intValue] == 200) {
            [self.listDevices removeAllObjects];
            NSArray *jsonArray =result.result;
            if([jsonArray count] > 0){
                NSMutableString *deviceIdBuffer = [[NSMutableString alloc] init];
                for (int i=0; i<[jsonArray count]; i++) {
                    NSDictionary *dictionary = [jsonArray objectAtIndex:i];
                    if ([dictionary objectForKey:@"id"]) {
                        [deviceIdBuffer appendString:[dictionary objectForKey:@"id"]];
                        [deviceIdBuffer appendString:@","];
                    }
                    DeviceVo *vo= [[DeviceVo alloc] initWithDic:dictionary];
                    [self.listDevices insertObject:vo atIndex:i];
                }
            }
        }
        [_ListView reloadData];
        //同一账户同时登陆多台设备，使得设备列表和主页面设备同步
//        [[NSNotificationCenter defaultCenter] postNotificationName:AirDeviceChangedNotification object:nil];
    } failure:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
        //        if ([result.message intValue] ==400 ) {//没有设备，设备被全部删除
        //            [self.listDevices removeAllObjects];
        //            [[NSNotificationCenter defaultCenter] postNotificationName:AirDeviceAllDelete object:nil];
        //        }
        [self.listDevices removeAllObjects];
        [[NSNotificationCenter defaultCenter] postNotificationName:AirDeviceAllDelete object:nil];
        [_ListView reloadData];
        //同一账户同时登陆多台设备，使得设备列表和主页面设备同步
//        [[NSNotificationCenter defaultCenter] postNotificationName:AirDeviceChangedNotification object:nil];
    }];

}


@end
