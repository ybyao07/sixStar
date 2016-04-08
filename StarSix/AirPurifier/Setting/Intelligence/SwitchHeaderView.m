//
//  SwitchHeaderView.m
//  StarSix
//
//  Created by ybyao07 on 15/9/17.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "SwitchHeaderView.h"
#import "PureLayout.h"
#import "FanModeModel.h"
#import "DeviceSettingTimeModel.h"


@interface SwitchHeaderView()
{
    UILabel *_modeName;
    UISwitch *_switchMode;
}
@end

@implementation SwitchHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [UILabel newAutoLayoutView];
        [self addSubview:label];
        
        [label autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [label autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
        label.font = [UIFont systemFontOfSize:19];
        _modeName = label;
        
        UISwitch *swithM = [UISwitch newAutoLayoutView];
        [swithM addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:swithM];
        
        [swithM autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [swithM autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
        _switchMode = swithM;
    }
    return self;
}


-(void)setModel:(BaseModel *)model
{
    _model = model;
    if ([model isKindOfClass:[FanModeModel class]]) {
        FanModeModel *fanModel = (FanModeModel *)model;
        _modeName.text = @"智能模式";
        [_switchMode setOn:fanModel.status];
    }else if ([model isKindOfClass:[DeviceSettingTimeModel class]]){
        DeviceSettingTimeModel *timeModel = (DeviceSettingTimeModel *)model;
        _modeName.text = @"定时";
        [_switchMode setOn:timeModel.status];
    }
}

-(void)switchValueChanged:(UISwitch *)switchM
{
    if (self.block) {
        _block(_model,switchM);
    }
}

@end
