//
//  LabelCollectionViewCell.h
//  StarSix
//
//  Created by ybyao07 on 15/9/15.
//  Copyright (c) 2015年 skyware. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface LabelCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lbl;
@property (weak, nonatomic) IBOutlet UILabel *uint;



-(void)updateViewIsPm:(BOOL)isPm;

@end
