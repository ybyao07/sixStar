//
//  LoadingCoverView.m
//  AirPurifier
//
//  Created by ybyao07 on 16/1/26.
//  Copyright © 2016年 skyware. All rights reserved.
//

#import "LoadingCoverView.h"
@implementation LoadingCoverView
-(instancetype)initWithFrame:(CGRect)frame
{
    self= [super initWithFrame:frame];
    if (self!=nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
        label.text = @"正在获取设备列表，请稍后...";
        label.font = [UIFont systemFontOfSize:15];
        [label sizeToFit];
        label.center = self.center;
        [self addSubview:label];
        self.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1.0];
    }
    return self;
}

@end
