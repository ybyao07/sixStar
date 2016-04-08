//
//  DeviceDetailViewCell.m
//  AirPurifier
//
//  Created by blue on 15/4/14.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "DeviceDetailViewCell.h"

@interface DeviceDetailViewCell()



@end

@implementation DeviceDetailViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    
    return self;
}

-(void)createUI
{
    UIButton *btnGround = [[UIButton alloc] init];
    btnGround.frame = self.frame;
    btnGround.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:btnGround];
    self.btnSelected = btnGround;
    
    UIImageView *img=[[UIImageView alloc] init];
    img.frame = CGRectMake(20, 6, 32, 32);
    img.contentMode = UIViewContentModeScaleAspectFit;
    img.image = [UIImage imageNamed:@"deviceIcon"];
    [self.contentView addSubview:img];
    
    UILabel *deviceName = [[UILabel alloc] init];
    deviceName.frame = CGRectMake(CGRectGetMaxX(img.frame)+6, 0, 120, self.frame.size.height);
    deviceName.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:deviceName];
    self.lblDeviceName = deviceName;
    
    UILabel *indicator = [[UILabel alloc] init];
    indicator.frame = CGRectMake(kScreenW - 80, 0, 60, self.frame.size.height);
    indicator.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:indicator];
    self.lblLockingIndicator = indicator;
}

//-(void)setDeviceVo:(DeviceVo *)deviceVo
//{
//    self.lblDeviceName.text = deviceVo.deviceName;
//    if ([deviceVo.deviceLock intValue]== DeviceLock) {
//        self.lblLockingIndicator.text = @"已锁定";
//    }
//    else if ([deviceVo.deviceLock intValue] == DeviceUnLock) {
//        self.lblLockingIndicator.text = @"未锁定";
//    }
//    cell.btnSelected.tag = indexPath.row;
//    
//    [self addTarget:self action:@selector(editAirDevice:) onButton:cell.btnSelected];
//    
//}



@end
