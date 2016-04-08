//
//  SwitchHeaderView.h
//  StarSix
//
//  Created by ybyao07 on 15/9/17.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"

typedef void(^ModeStatusChanged)(BaseModel *,UISwitch *);
@protocol SwitchModeDelegate <NSObject>

-(void)modeStatusChangedOnModel:(BaseModel *)model;

@end

@interface SwitchHeaderView : UIView

@property (nonatomic,strong) BaseModel *model;
@property (nonatomic,strong) id<SwitchModeDelegate> delegate;
@property (nonatomic,strong) ModeStatusChanged block;


@end
