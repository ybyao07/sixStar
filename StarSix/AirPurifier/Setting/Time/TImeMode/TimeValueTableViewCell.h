//
//  TimeValueTableViewCell.h
//  StarSix
//
//  Created by ybyao07 on 15/9/17.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^InfoClicked)();

@interface TimeValueTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *infoView;

@property (weak, nonatomic) IBOutlet UIImageView *chechImgView;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeView;

@property (nonatomic,strong) InfoClicked infoClickOption;
@end
