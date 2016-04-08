//
//  LabelCollectionViewCell.m
//  StarSix
//
//  Created by ybyao07 on 15/9/15.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "LabelCollectionViewCell.h"
#import "ModelNotice.h"


@interface LabelCollectionViewCell()
{
    
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopValue;

@end

@implementation LabelCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    if (IS_IPHONE_4_OR_LESS) {
        _constraintTopValue.constant = 20;
    }
    if (IS_IPHONE_6 || IS_IPHONE_6P) {
        _lbl.font = [UIFont systemFontOfSize:26];
        _uint.font = [UIFont systemFontOfSize:20];
    }
    
}

-(void)updateViewIsPm:(BOOL)isPm
{
    if (isPm) {
        self.lbl.text = @"PM2.5";
        self.uint.text = @"ug/m³";
        if ([[ModelNotice sharedModelNotice].notice_filter boolValue]) {
            self.imgView.hidden = NO;
        }else{
            self.imgView.hidden = YES;
        }
    }else{
        self.lbl.text = @"温度";
        self.uint.text = @"（ ℃ ）";
        self.imgView.hidden = YES;
    }
}



@end
