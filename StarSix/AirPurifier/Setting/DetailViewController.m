//
//  DetailViewController.m
//  AirPurifier
//
//  Created by bluE on 14-8-18.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import "DetailViewController.h"
#import "AccountManageViewController.h"
#import "InfoAlertView.h"
#import "DeviceManageViewController.h"
#import "AlertBox.h"
#import "AirPurifierAppDelegate.h"
#import "UserLoginedInfo.h"
#import "UIImage+UIImageExtras.h"
#import "DeviceAddViewController.h"
#import "UIColor+Utility.h"
#import "UIView+Toast.h"
#import "Util.h"
#import "PopHintView.h"
#import "TimeModeTableViewController.h"
#import "IntelligenceViewController.h"
#import "JSON.h"
#import "SettingTableViewController.h"
#import "PureLayout.h"
#import "SkywareUserManagement.h"
#import "HelpViewController.h"
#import "UIImageView+WebCache.h"
#import "FeedbackViewController.h"
#import "UserTableViewCell.h"
#import "SetShowTimerModel.h"
#import "DeviceSettingTableViewCell.h"

@interface DetailViewController () <SwitchValueChangedDelegate>
{
    NSArray *_arrSectionOne;
    NSArray *_arrSectionTwo;
    NSArray *_arrSectionThree;
    NSArray *_iconsArray;
    BOOL pmAlertOnOff;
    BOOL filterAlertOnOff;
}
@property (nonatomic,strong) ModelUser  *userModel;

@property (strong,nonatomic) NSMutableArray *deviceArraylist;

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    MainDelegate.isFromMain = NO;
    [self initData];
    [self initView];
    
    [self registerObserver];
    [self downLoadUserInfo];
    [SVProgressHUD show];
    [self downloadDeviceList];
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
    if (self.deviceArraylist.count) {
        [self.deviceArraylist removeAllObjects];
    }
    [SkywareDeviceManagement DeviceGetAllDevicesSuccess:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
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
                [self.deviceArraylist insertObject:vo atIndex:i];
            }
            [self.tableView reloadData];
        }
    } failure:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
        if([result.message  intValue] == 404) {//没有设备
            [self.tableView reloadData];
        }else{
            [self.view makeToast:@"获取设备列表失败"];
        }
    }];
}
-(void)initData
{
    _arrSectionOne = @[@"设备管理",@"添加设备"];
    _arrSectionTwo = @[@"除尘周期提醒",@"空气质量报警",@"定时",@"智能模式"];
    _arrSectionThree = @[@"帮助",@"反馈",@"关于"];
    _iconsArray = @[@[@"deviceManager",@"deviceAdd"],@[@"deviceFilter",@"deviceAir",@"deviceTime",@"deviceAuto"],@[@"deviceHelp",@"deviceFeedback",@"deviceAbout"]];
}
-(void)initView
{
    [self addBarItemTitle:@"更多"];
    [self addBarBackButtonItemWithImageName:@"back_normal" selImageName:@"back_press" action:@selector(onBack:)];
    self.tableView.backgroundColor = [UIColor colorWithHex:0xe8e8e8 alpha:1];
}


#pragma mark 更新用户信息
- (void)userInfoUpdateStatus:(NSNotification *)notification
{
    [self downLoadUserInfo];
}

#pragma mark 获取用户信息
-(void)downLoadUserInfo
{
    [SkywareUserManagement UserGetUserWithParamesers:[NSArray new] Success:^(SkywareResult *result) {
        if ([result.message intValue] == 200) {
            NSArray *arr = result.result;
            self.userModel = [[ModelUser alloc] initWithDic:[arr objectAtIndex:0]];
            NSDictionary *dicNotice = [[arr objectAtIndex:0][@"user_prefer"] JSONValue];
            [ModelNotice sharedModelNotice].notice_pm = dicNotice[@"notice_pm"];
            [ModelNotice sharedModelNotice].notice_pm_value = dicNotice[@"notice_pm_value"];
            [ModelNotice sharedModelNotice].notice_filter = dicNotice[@"notice_filter"];
            
            filterAlertOnOff =  [[ModelNotice sharedModelNotice].notice_filter  boolValue];
            pmAlertOnOff = [[ModelNotice sharedModelNotice].notice_pm  boolValue];
            [_tableView reloadData];
        }
        [SVProgressHUD dismiss];
    } failure:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
    }];
}


#pragma mark UITableView Delegate ------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return _arrSectionOne.count;
    }else if (section == 2){
        return _arrSectionTwo.count;
    }else{
        return _arrSectionThree.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 14;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 30;
    }else{
        return 1;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 30)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 30)];
        //清空背景颜色
        label.backgroundColor = [UIColor clearColor];
        //        label.textColor = myColor(223, 223, 223);
        label.textColor = [UIColor colorWithHex:0x868686 alpha:1.0];
        label.font = [UIFont systemFontOfSize:14.0];
        //文字居中显示
        label.textAlignment = NSTextAlignmentCenter;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        label.text=@"您可以通过输入或扫描机身编码绑定设备";
        [contentView addSubview:label];
        return contentView;
    }else{
        return  nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80;
    }else{
        return 50;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"UserTableViewCell" owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.model = self.userModel;
        return cell;
    }
    else if(indexPath.section == 1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"OtherCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:17];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.imageView.image = [UIImage imageNamed:_iconsArray[indexPath.section-1][indexPath.row]];//加icon
        cell.textLabel.text = [_arrSectionOne objectAtIndex:indexPath.row];
        return cell;
    }else if (indexPath.section == 2){
        if (indexPath.row == 0 || indexPath.row == 1) {
            DeviceSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceSettingTableViewCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"DeviceSettingTableViewCell" owner:nil options:nil] lastObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
            }
            cell.imageView.image = [UIImage imageNamed:_iconsArray[indexPath.section-1][indexPath.row]];//加icon
            cell.lblTitle.text = [_arrSectionTwo objectAtIndex:indexPath.row];
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
            cell.imageView.image = [UIImage imageNamed:_iconsArray[indexPath.section-1][indexPath.row]];//加icon
            cell.textLabel.text = [_arrSectionTwo objectAtIndex:indexPath.row];
            
            if (self.deviceArraylist.count == 1) { //只有一台设备时
                DeviceVo *deviceVo = self.deviceArraylist.firstObject;
                if (indexPath.row == 2) {//定时是否开启
//                    DeviceSettingTimeModel *model = deviceVo.deviceData.timeModel;
//                    如果设备已开启，则显示当前模式（如果无模式为空，有模式则显示对应模式）
//                    if ([deviceVo.deviceData.btnPower boolValue]) {
//                        if (model.status) {
//                            cell.detailTextLabel.text = [model modeStr];
//                        }else{
//                            cell.detailTextLabel.text = @"未开启";
//                        }
//                    }else{//显示多久后开启
//                       SetShowTimerModel *timeModel = [[SetShowTimerModel alloc] init];
//                       cell.detailTextLabel.text = [timeModel getShowTimeText:deviceVo];
//                    }
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
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OtherCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:17];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.imageView.image = [UIImage imageNamed:_iconsArray[indexPath.section-1][indexPath.row]];//加icon
        cell.textLabel.text = [_arrSectionThree objectAtIndex:indexPath.row];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0) { //账号管理
        [self.navigationController pushViewController:[[AccountManageViewController alloc] initWithNibName:@"AccountManageViewController" bundle:nil] animated:YES];
    }else if([cell.textLabel.text isEqualToString:@"设备管理"]) {
        DeviceManageViewController *deviceController = [[DeviceManageViewController alloc] initWithNibName:@"DeviceManageViewController" bundle:nil];
        deviceController.mqClient = self.mqClient;
        [self.navigationController pushViewController:deviceController animated:YES];
    }else if([cell.textLabel.text isEqualToString:@"添加设备"]) {
        MainDelegate.isFromWifi = NO;
        [self.navigationController pushViewController:[[DeviceAddViewController alloc] initWithNibName:@"DeviceAddViewController" bundle:nil] animated:YES];
    }else if ([cell.textLabel.text isEqualToString:@"空气质量报警"]){
        
    }else if ([cell.textLabel.text isEqualToString:@"定时"]){
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
    }else if ([cell.textLabel.text isEqualToString:@"智能模式"]){
        if(self.deviceArraylist.count == 0){ //无设备
            [PopHintView showViewWithTitle:@"您还未添加设备"];
        }else if (self.deviceArraylist.count == 1){//只有一台设备
            IntelligenceViewController *inteligenceVC = [[IntelligenceViewController alloc] init];
            inteligenceVC.deviceVo = [self.deviceArraylist firstObject];
            [self.navigationController pushViewController:inteligenceVC animated:YES];
        }else{//添加了多台设备
            [self.navigationController pushViewController:[[SettingTableViewController alloc] init] animated:YES];
        }
    }else if ([cell.textLabel.text isEqualToString:@"升级"]){
        
    }else if ([cell.textLabel.text isEqualToString:@"帮助"]){
        [self.navigationController pushViewController:[[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil] animated:YES];
    }else if ([cell.textLabel.text isEqualToString:@"反馈"]){
        [self.navigationController pushViewController:[[FeedbackViewController alloc] init] animated:YES];
        
    }else if ([cell.textLabel.text isEqualToString:@"关于"]){
        [AlertBox showAboutMessage:@"关于" delegate:nil];
    }
}

#pragma mark 返回
- (void)onBack:(id)sender {
    [self.navigationController  popViewControllerAnimated:YES];
}

-(void)updateNotice:(NSDictionary *)param
{
    [SkywareUserManagement UserEditUserWithParamesers:@{@"user_prefer":[param JSONRepresentation]} Success:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
        if ([result.message intValue] == 200) {
            NSLog(@"修改成功");
            [ModelNotice sharedModelNotice].notice_pm  = [param objectForKey:@"notice_pm"];
            [ModelNotice sharedModelNotice].notice_filter = [param objectForKey:@"notice_filter"];
            [NotificationCenter postNotificationName:AirDeviceChangedNotification object:nil];
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


#pragma mark - Observer Management
- (void)registerObserver
{
    [NotificationCenter addObserver:self
                           selector:@selector(userInfoUpdateStatus:)
                               name:UserNameModifiedNotification
                             object:nil];
    [NotificationCenter addObserver:self
                           selector:@selector(userInfoUpdateStatus:)
                               name:UserImgModifiedNotification
                             object:nil];
    [NotificationCenter addObserver:self selector:@selector(synDownloadData) name:DeviceModeChangeNotification object:nil];
    [NotificationCenter addObserver:self selector:@selector(synDownloadData) name:AirDeviceRemovedNotification object:nil];
}
- (void)removeObserver
{
    [NotificationCenter removeObserver:self name:UserNameModifiedNotification object:nil];
    [NotificationCenter removeObserver:self name:UserImgModifiedNotification object:nil];
}
-(BOOL)isVisible{
    return (self.isViewLoaded && self.view.window);
}

-(void)dealloc{
    [self removeObserver];
}
-(NSMutableArray *)deviceArraylist
{
    if (_deviceArraylist == nil) {
        _deviceArraylist = [NSMutableArray new];
    }
    return _deviceArraylist;
}

@end
