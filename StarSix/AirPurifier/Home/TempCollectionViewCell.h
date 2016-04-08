//
//  TempCollectionViewCell.h
//  StarSix
//
//  Created by ybyao07 on 15/9/15.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceVo.h"
@interface TempCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *tempValue;


-(void)updateView:(DeviceVo *)model isInside:(BOOL)inside;


@end
