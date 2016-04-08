//
//  DeviceSettingTableViewCell.h
//  StarSix
//
//  Created by ybyao07 on 15/9/16.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelNotice.h"


@protocol SwitchValueChangedDelegate <NSObject>

-(void)switchValueChanged:(UISwitch *)mySwitch indexRow:(NSInteger)row;

@end

@interface DeviceSettingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (nonatomic,assign) NSInteger row;
@property (nonatomic,strong) id<SwitchValueChangedDelegate> delegate;
@property (nonatomic,strong) ModelNotice *model;


@end
