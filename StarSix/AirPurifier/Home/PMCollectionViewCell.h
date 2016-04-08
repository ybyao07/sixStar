//
//  PMCollectionViewCell.h
//  StarSix
//
//  Created by ybyao07 on 15/9/15.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceVo.h"

@interface PMCollectionViewCell : UICollectionViewCell


-(void)updateView:(DeviceVo *)model isInside:(BOOL)inside;


@end
