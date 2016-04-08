//
//  DeviceDetailViewCell.h
//  AirPurifier
//
//  Created by blue on 15/4/14.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceVo.h"
@interface DeviceDetailViewCell : UITableViewCell
@property (weak, nonatomic)  UILabel *lblDeviceName;
@property (weak, nonatomic)  UILabel *lblLockingIndicator;



@property (weak, nonatomic)  UIButton *btnSelected;

//@property DeviceVo *deviceVo;
@end
