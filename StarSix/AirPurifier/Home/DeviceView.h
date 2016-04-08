//
//  DeviceView.h
//  AirPurifier
//
//  Created by bluE on 14-8-21.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFlipperView.h"
#import "DeviceVo.h"
@interface DeviceView : UIFlipperView

@property (weak, nonatomic) IBOutlet UIView *viewTop;

@property (nonatomic,strong) DeviceVo *deviceModel;

+(DeviceView *)instanceDeviceView;


@end
