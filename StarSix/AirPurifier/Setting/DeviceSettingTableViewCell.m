//
//  DeviceSettingTableViewCell.m
//  StarSix
//
//  Created by ybyao07 on 15/9/16.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "DeviceSettingTableViewCell.h"

@interface DeviceSettingTableViewCell()

@property (weak, nonatomic) IBOutlet UISwitch *switchView;

@end
@implementation DeviceSettingTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [_switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)setModel:(ModelNotice *)model
{
    _model = model;
    if (_row == 0) {//滤网
        [_switchView setOn:[_model.notice_filter boolValue]];
    }else{
        [_switchView setOn:[_model.notice_pm boolValue]];
    }
}
-(void)switchAction:(UISwitch *)sender
{
    if ([self.delegate respondsToSelector:@selector(switchValueChanged:indexRow:)]){
        [self.delegate switchValueChanged:sender indexRow:_row];
    }
}

@end
