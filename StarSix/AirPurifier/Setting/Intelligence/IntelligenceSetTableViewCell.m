//
//  IntelligenceSetTableViewCell.m
//  StarSix
//
//  Created by ybyao07 on 15/11/12.
//  Copyright © 2015年 skyware. All rights reserved.
//

#import "IntelligenceSetTableViewCell.h"

@interface IntelligenceSetTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *deviceName;
@property (weak, nonatomic) IBOutlet UILabel *intelMode;
@end
@implementation IntelligenceSetTableViewCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(DeviceVo *)model
{
    _model = model;
    self.deviceName.text = model.deviceName;
    //    self.time.text = @"距离开启还有10小时";
    if (model.deviceData.fanModel!=nil) {
//        if (model.deviceData.fanModel.status) {
//            self.modeStr.text = @"已开启";
//        }else{
//            self.modeStr.text = @"未开启";
//        }
        self.intelMode.text = model.deviceData.fanModel.strFanMode;
    }
    
}




@end
