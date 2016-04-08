//
//  TimeValueTableViewCell.m
//  StarSix
//
//  Created by ybyao07 on 15/9/17.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "TimeValueTableViewCell.h"

@implementation TimeValueTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.infoView.userInteractionEnabled = YES;
    UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(infoClicked:)];
    [self.infoView addGestureRecognizer:gesture];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)infoClicked:(UITableViewCell *)cell
{
    if (self.infoClickOption) {
        _infoClickOption();
    }
}

@end
