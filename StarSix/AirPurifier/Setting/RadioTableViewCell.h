//
//  RadioTableViewCell.h
//  StarSix
//
//  Created by ybyao07 on 15/9/17.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^radioClickOption)();

@interface RadioTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *bigBtn;

@property (weak, nonatomic) IBOutlet UIButton *radioBtn;
@property (weak, nonatomic) IBOutlet UILabel *modeName;


@property (nonatomic,assign) BOOL isSlected;
@property (nonatomic,strong) radioClickOption radioBlock;




@end
