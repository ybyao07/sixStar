//
//  TempCollectionViewCell.m
//  StarSix
//
//  Created by ybyao07 on 15/9/15.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "TempCollectionViewCell.h"

@implementation TempCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)updateView:(DeviceVo *)model isInside:(BOOL)inside
{
    if (inside) {
        self.location.text = @"室  内";
        self.tempValue.text = model==nil?@"--":[NSString stringWithFormat:@"%.1f",model.deviceData.deviceInsideTem];
    }else{
        self.location.text = @"室  外";
        self.tempValue.text =  model==nil?@"--":[NSString stringWithFormat:@"%.1f",model.deviceData.deviceOutsideTem] ;
    }
}


@end
