//
//  SettingTableViewController.m
//  StarSix
//
//  Created by ybyao07 on 15/9/17.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "SettingTableViewController.h"
#import "DeviceSettingTimeModel.h"
#import "CustomModel.h"
#import "SkywareDeviceManager.h"
#import "TimeModeTableViewController.h"
#import "TimeSetTableViewCell.h"
#import "UIView+Toast.h"
#import "FanModeModel.h"
#import "DeviceVo.h"
#import "CustomTimeViewController.h"
#import "IntelligenceSetTableViewCell.h"
#import "IntelligenceViewController.h"

@interface SettingTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavView];
    [SVProgressHUD show];
    [self downloadData];
    [NotificationCenter addObserver:self selector:@selector(synDownloadData) name:DeviceModeChangeNotification object:nil];
}

-(void)synDownloadData
{
    if ([self isVisible]) {
        [SVProgressHUD show];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self downloadData];
    });
}
-(void)downloadData
{
    [SkywareDeviceManager DeviceGetAllDevicesSuccess:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
        if ([result.message intValue] == 200) {
            if (self.dataList.count) {
                [self.dataList removeAllObjects];
            }
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
                        [self.dataList insertObject:vo atIndex:i];
                    }
                }
            [self.tableView reloadData];
            }
    } failure:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
        if([result.message  intValue] == 404) {//没有设备
            if (self.dataList.count) {
                [self.dataList removeAllObjects];
            }
            [self.tableView reloadData];
        }
    }];
}

-(void)initNavView
{
    if(_isTime){
        [self setNavTitle:@"定时"];
    }else{
        [self setNavTitle:@"智能模式"];
    }
}
#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isTime) {
        static  NSString *CellIdentifier = @"TimeSetTableViewCell";
        TimeSetTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TimeSetTableViewCell" owner:nil options:nil] lastObject];;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row < self.dataList.count) {
            DeviceVo *model = [self.dataList objectAtIndex:indexPath.row];
            cell.model = model;
        }
        return cell;
    }else{//智能模式
        static  NSString *CellIdentifier = @"IntelligenceSetTableViewCell";
        IntelligenceSetTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"IntelligenceSetTableViewCell" owner:nil options:nil] lastObject];;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row < self.dataList.count) {
            DeviceVo *model = [self.dataList objectAtIndex:indexPath.row];
            cell.model = model;
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isTime) {
        TimeModeTableViewController *tmVC = [[TimeModeTableViewController alloc] init];
         tmVC.deviceVo = [self.dataList objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:tmVC animated:YES];
    }else{
        IntelligenceViewController *fanVC = [[IntelligenceViewController alloc] init];
        fanVC.deviceVo = [self.dataList objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:fanVC animated:YES];
    }
}


-(BOOL)isVisible{
    return (self.isViewLoaded && self.view.window);
}

-(void)dealloc
{
    [NotificationCenter removeObserver:self];
}

-(void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}




@end
