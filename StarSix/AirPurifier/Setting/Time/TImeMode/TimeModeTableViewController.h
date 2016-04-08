//
//  TimeModeTableViewController.h
//  StarSix
//
//  Created by ybyao07 on 15/9/17.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "BaseTableViewController.h"
#import "DeviceSettingTimeModel.h"
#import "DeviceVo.h"
@interface TimeModeTableViewController : BaseTableViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) DeviceVo *deviceVo;


@end
