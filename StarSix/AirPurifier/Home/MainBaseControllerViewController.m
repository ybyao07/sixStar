//
//  MainBaseControllerViewController.m
//  HangingFurnace
//
//  Created by ybyao07 on 16/4/1.
//  Copyright © 2016年 skyware. All rights reserved.
//

#import "MainBaseControllerViewController.h"
#import "DeviceUserTest.h"
#import "LoadingCoverView.h"
#import "AddDeviceViewController.h"

@interface MainBaseControllerViewController ()<UIAlertViewDelegate,UIActionSheetDelegate,QRCodeViewControllerDelegate>
{
    BOOL isNoResetDevice;         // 分享设备中 是否有被重置的设备
    BOOL isNoSharedDefinedDevice; // 是否有分享的设备
    BOOL isNoMasterReset;         //主人的设备被重置
}
@property (nonatomic,strong) NSMutableArray *devicesUndefined;// 分享用户确认未确认是否绑定设备
@property (nonatomic,strong) NSMutableArray *devicesReset;  //分享的设备被重置
@property (nonatomic,strong) NSMutableArray *devicesMasterReset; //主人的设备被重置


@property (nonatomic,strong) LoadingCoverView *coverView;

@end

@implementation MainBaseControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)downloadDevicesForView
{
    if (![BaseNetworkTool isConnectNetWork]) {
        [self showNetWorkView:YES];
        __weak typeof(self) weakself = self;
        self.networkRefreshOption =^{
            [weakself downloadDevicesForView];
        };
        return;
    }else{
        [self showNetWorkView:NO];
        [self showCoverView:YES];
    }
    [SkywareDeviceManager DeviceGetUndefinedDevicesSuccess:^(SkywareResult *result) {
        if ([result.message intValue] == 200) {
            NSArray *jsonArray =result.result;
            if (jsonArray.count > 0) {
                [self.devicesUndefined removeAllObjects];
                [self.devicesReset removeAllObjects];
                [self.devicesMasterReset removeAllObjects];
                for (int i = 0 ; i < jsonArray.count; i++) {
                    DeviceUserTest *deviceUser = [DeviceUserTest mj_objectWithKeyValues:jsonArray [i]];
                    if ([deviceUser.device_state intValue]== 1) {  //设备状态 1：未确认绑定 3：主用户重新配网
                        [self.devicesUndefined addObject:deviceUser];
                    }
                    if ([deviceUser.device_state intValue]== 3) {//主人重置了该设备
                        [self.devicesReset addObject:deviceUser];
                    }
                    if ([deviceUser.device_state intValue] == 4) { //主人的设备被别人重置
                        [self.devicesMasterReset addObject:deviceUser];
                    }
                }
                if (self.devicesReset.count > 0) { //被重置的设备
                    NSMutableString *devicesR = [NSMutableString new];
                    [self.devicesReset enumerateObjectsUsingBlock:^(DeviceUserTest *deviceU, NSUInteger idx, BOOL * _Nonnull stop) {
                        [devicesR appendString:[NSString stringWithFormat:@"\"%@\"",deviceU.device_name]];
                        if (idx!=self.devicesReset.count) {
                            [devicesR appendString:@","];
                        }
                    }];
                    NSString *resetDevicesStr = [NSString stringWithFormat:@"%@已被主人解绑，您无法查看该设备",devicesR];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:resetDevicesStr delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                    alertView.tag = AlertViewResetDevice;
                    [alertView show];
                }else{
                    isNoResetDevice = YES;
                }
                if (self.devicesUndefined.count > 0) { //分享的设备
                    NSMutableString *devicesShare = [NSMutableString new]; //设备名称
                    NSMutableString *devicesShareUser = [NSMutableString new];// 分享的主人id
                    [self.devicesUndefined enumerateObjectsUsingBlock:^(DeviceUserTest *deviceU, NSUInteger idx, BOOL * _Nonnull stop) {
                        [devicesShare appendString:deviceU.device_name];
                        [devicesShareUser appendString:deviceU.login_id];
                        if (idx!=self.devicesReset.count) {
                            [devicesShare appendString:@","];
                            [devicesShareUser appendString:@","];
                        }
                    }];
                    NSString *shareDevicesStr = [NSString stringWithFormat:@"用户%@给您分享了%ld台设备，%@",devicesShareUser,self.devicesUndefined.count,devicesShare];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:shareDevicesStr delegate:nil cancelButtonTitle:@"绑定" otherButtonTitles:@"不绑定",nil];
                    alertView.tag = AlertViewUndefinedDevice;
                    [alertView show];
                }else{
                    isNoSharedDefinedDevice = YES;
                }
                if (self.devicesMasterReset.count > 0) {
                    NSMutableString *strMasterUserIds = [NSMutableString new];
                    [self.devicesMasterReset enumerateObjectsUsingBlock:^(DeviceUserTest *deviceU, NSUInteger idx, BOOL * _Nonnull stop) {
                        [strMasterUserIds appendString:[NSString stringWithFormat:@"\"%@\"已被\"%@\"占用",deviceU.device_name,deviceU.login_id]];
                        //                        if (idx!=self.devicesMasterReset.count) {
                        [strMasterUserIds appendString:@","];
                        //                        }
                    }];
                    [strMasterUserIds appendString:@"您已被解绑"];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:strMasterUserIds delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    alertView.tag = AlertViewMasterHasBeenReset;
                    [alertView show];
                }else{
                    isNoMasterReset = YES;
                }
            }
        }else{
            [self downloadDeviceList];
        }
    } failure:^(SkywareResult *result) {
        if ([result.message integerValue] == 404) { //
            [self downloadDeviceList];
        }else{
            [self showCoverView:NO];
            [self showNetWorkView:YES];
            __weak typeof(self) weakself = self;
            self.networkRefreshOption =^{
                [weakself downloadDevicesForView];
            };
        }
    }];
}
/**
 *  获取设备列表
 */
-(void)downloadDeviceList
{
    [SkywareDeviceManager DeviceGetAllDevicesSuccess:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
        if ([result.message intValue] == 200) {
            if (_downloadDeviceSuccess) {
                _downloadDeviceSuccess(result);
            }
        }
        [self showNetWorkView:NO];
        [self showCoverView:NO];
    } failure:^(SkywareResult *result) {
        [self showNetWorkView:NO];
        [self showCoverView:NO];
        [SVProgressHUD dismiss];
        if([result.message intValue] == 404) {//没有设备
            if (_downloadDeviceFailure) {
                _downloadDeviceFailure();
            }
        }
    }];
}


/**
 *  设备不在线
 */
-(void)showAlterView
{
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"设备已离线" message:@"请检查：\n1.设备是否连接电源；\n2.WiFi是否正常；\n3.请尝试重新配置WiFi；\n当检查完毕，请重新刷新；" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新配置WiFi",@"刷新", nil];
    view.tag = AlertViewWifi;
    [view show];
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == AlertViewWifi) { //掉线
        if (buttonIndex == 1) { //重新配网
            AddDeviceViewController *add = [[AddDeviceViewController alloc] init];
            add.addDevice = NO;
            [self.navigationController pushViewController: add animated:YES];
        }
        if (buttonIndex == 2) { //刷新列表
            [self downloadDeviceList];
        }
    }
    else if(alertView.tag == ALertViewNoNet){ //断网
        if (buttonIndex != alertView.cancelButtonIndex) {
            [self downloadDeviceList];
        }
    }else if (alertView.tag == AlertViewUndefinedDevice){
        
    }else if (alertView.tag == AlertViewResetDevice){//确认，提交服务器 （解绑）
        NSMutableString *arrReset = [NSMutableString new];
        [self.devicesReset enumerateObjectsUsingBlock:^(DeviceUserTest *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [arrReset appendString:obj.device_id];
            [arrReset appendString:@"_"];
        }];
        [SkywareDeviceManager DeviceCancelUndefinedDevice:[NSArray arrayWithObject:[arrReset substringToIndex:arrReset.length - 1]] Success:^(SkywareResult *result) {
            NSLog(@"重置列表成功");
            isNoResetDevice = YES;
            if (isNoResetDevice && isNoSharedDefinedDevice && isNoMasterReset) {
                [self downloadDeviceList];
            }
        } failure:^(SkywareResult *result) {
            //
            NSLog(@"重置失败");
        }];
    }else if (alertView.tag == AlertViewMasterHasBeenReset) {
        NSMutableString *arrResetMaster = [NSMutableString new];
        [self.devicesMasterReset enumerateObjectsUsingBlock:^(DeviceUserTest *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [arrResetMaster appendString:obj.device_id];
            [arrResetMaster appendString:@"_"];
        }];
        [SkywareDeviceManager DeviceCancelUndefinedDevice:[NSArray arrayWithObject:[arrResetMaster substringToIndex:arrResetMaster.length - 1]] Success:^(SkywareResult *result) {
            NSLog(@"主人成功");
            isNoMasterReset = YES;
            if (isNoResetDevice && isNoSharedDefinedDevice && isNoMasterReset) {
                [self downloadDeviceList];
            }
        } failure:^(SkywareResult *result) {
            NSLog(@"主人失败");
        }];
    }else if (alertView.tag == AlertViewCode){
        if (buttonIndex!=alertView.cancelButtonIndex) {  //被分享的设备，是否要绑定该设备
            //先查询设备判断设备是否锁定，如果锁定则不能绑定
            NSString *deviceId = objc_getAssociatedObject(alertView, "deviceId");
            SkywareDeviceQueryInfoModel *deviceModel = [[SkywareDeviceQueryInfoModel alloc] init];
            deviceModel.id = deviceId; //从二维码中读取设备mac和设备id
            [SVProgressHUD showWithStatus:@"加载中..."];
            [SkywareDeviceManager DeviceQueryInfo:deviceModel  Success:^(SkywareResult *result) {
                [SVProgressHUD dismiss];
                if ([result.message intValue] == 200) {
                    //检查设备是否锁定
                    SkywareDeviceInfoModel *tempDevice = [SkywareDeviceInfoModel mj_objectWithKeyValues:result.result];
                    if ([tempDevice.device_lock intValue]==0) {
                        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"设备已锁定，不能绑定" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil] show];
                        return;
                    }else{
                        //调绑定接口
                        [SkywareDeviceManager DeviceBindUserNew:@{@"deviceid":deviceId,@"userstate":@"1"} Success:^(SkywareResult *result) {
                            if ([result.message intValue] == 200) {
                                [SVProgressHUD showSuccessWithStatus:@"绑定成功"];
                                [self downloadDeviceList];
                            }
                        } failure:^(SkywareResult *result) {
                            [SVProgressHUD showErrorWithStatus:@"绑定设备失败"];
                        }];
                    }
                }
            } failure:^(SkywareResult *result) {
                [SVProgressHUD dismiss];
            }];
        }
    }else if (alertView.tag == 11) // 第一次添加设备
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"IKnow"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //进入添加设备界面
        AddDeviceViewController *add = [[AddDeviceViewController alloc] init];
        add.addDevice = YES;
        [self.navigationController pushViewController: add animated:YES];
    }
}

#pragma mark UIActionSheet 代理
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // 扫描二维码，调入二维码扫描
        QRCodeViewController *readCode = [[QRCodeViewController alloc] init];
        readCode.delegate = self;
        [MainDelegate.navigationController presentViewController:readCode animated:YES completion:nil];
    }
    if (buttonIndex == 0) {
        //弹出提示框
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"IKnow"] integerValue] != 1) {
            UIAlertView *alertIKnow = [[UIAlertView alloc] initWithTitle:@"" message:@"您一旦添加设备，原用户将自动被解绑" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            alertIKnow.tag =  11;
            [alertIKnow show];
        }else{
            AddDeviceViewController *add = [[AddDeviceViewController alloc] init];
            add.addDevice = YES;
            [self.navigationController pushViewController: add animated:YES];
        }
    }
}

#pragma mark - QRCode 代理
- (void)ReaderCode:(QRCodeViewController *)readerViewController didScanResult:(NSString *)result
{
    [MainDelegate.navigationController dismissViewControllerAnimated:YES completion:nil];
    NSArray *deviceInfos = [result componentsSeparatedByString:@";"]; //deviceId,deviceName,当前时间 秒 数
    NSInteger preTime = 0;
    NSInteger nowTime = [[NSDate new] timeIntervalSince1970];
    NSString *deviceName=@"";
    NSString *deviceId;
    
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
    UIAlertView *QRCodeAlert = [[UIAlertView alloc ]initWithTitle:@"提示" message:[NSString stringWithFormat:@"是否要绑定\"%@\"",deviceName] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    QRCodeAlert.tag = AlertViewCode;
    QRCodeAlert.delegate = self;
    objc_setAssociatedObject(QRCodeAlert, "deviceId", deviceId, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [QRCodeAlert show];
}
- (void)ReaderCoderDidCancel:(QRCodeViewController *)readerViewController
{
    [MainDelegate.navigationController dismissViewControllerAnimated:YES completion:nil];
}


-(LoadingCoverView *)coverView
{
    if (!_coverView) {
        _coverView = [[LoadingCoverView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight)];
        [self.view addSubview:_coverView];
    }
    return _coverView;
}

-(void)showCoverView:(BOOL)need
{
    if (need) {
        [self.view bringSubviewToFront:self.coverView];
    }else{
        for (UIView *subView in [self.view subviews]) {
            if(subView!=self.coverView){
                [self.view bringSubviewToFront:subView];
            }
        }
        [self.view sendSubviewToBack:self.coverView];
    }
}
#pragma  mark 懒加载
-(NSMutableArray *)devicesUndefined
{
    if (!_devicesUndefined) {
        _devicesUndefined = [NSMutableArray new];
    }
    return _devicesUndefined;
}
-(NSMutableArray *)devicesReset
{
    if (!_devicesReset) {
        _devicesReset = [NSMutableArray new];
    }
    return _devicesReset;
}
-(NSMutableArray *)devicesMasterReset
{
    if (!_devicesMasterReset) {
        _devicesMasterReset = [NSMutableArray new];
    }
    return _devicesMasterReset;
}


@end
