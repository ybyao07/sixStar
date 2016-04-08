//
//  RadioTableViewCell.m
//  StarSix
//
//  Created by ybyao07 on 15/9/17.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "RadioTableViewCell.h"

@implementation RadioTableViewCell

- (void)awakeFromNib {
    [self.radioBtn setSelected:_isSlected];
}

 -(IBAction)onClick:(id)sender
{
    [self.radioBtn setSelected:YES];
    if (self.radioBlock) {
        _radioBlock();
    }
}





@end
