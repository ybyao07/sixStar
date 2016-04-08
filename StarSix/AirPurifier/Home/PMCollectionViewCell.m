//
//  PMCollectionViewCell.m
//  StarSix
//
//  Created by ybyao07 on 15/9/15.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "PMCollectionViewCell.h"
#import "UIView+Extension.h"
#import "PopHintView.h"
#import "ModelNotice.h"
@interface PMCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *pmValue;
@property (weak, nonatomic) IBOutlet UIImageView *imgSlider;
@property (weak, nonatomic) IBOutlet UILabel *location;


//自适应iphone4，iphone5s,iphone6
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceValueConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sliderHeightConstrait;

@end

@implementation PMCollectionViewCell

- (void)awakeFromNib {
}


-(void)updateView:(DeviceVo *)model isInside:(BOOL)inside
{
    if (inside) {
        self.location.text = @"室  内";
        self.pmValue.text = model==nil?@"--":[NSString stringWithFormat:@"%.0f",model.deviceData.deviceInsidePm] ;
        self.imgSlider.image = [self imgSliderFromPmValue:model.deviceData.deviceInsidePm];
        if ([[ModelNotice sharedModelNotice].notice_pm boolValue]) {
            self.imgView.hidden = NO;
        }else{
            self.imgView.hidden = YES;
        }
    }else{
        self.location.text = @"室  外";
        self.pmValue.text = model==nil?@"--":[NSString stringWithFormat:@"%.0f", model.deviceData.deviceOutsidePm];
         self.imgSlider.image = [self imgSliderFromPmValue:model.deviceData.deviceOutsidePm];
        self.imgView.hidden = YES;
    }
}



-(void)layoutSubviews
{
    [super layoutSubviews];
    if (IS_IPHONE_4_OR_LESS) {
        _topSpaceValueConstraint.constant = self.bounds.size.height*20/248;
        _sliderHeightConstrait.constant = self.bounds.size.height*38/248;
    }else{
        _topSpaceValueConstraint.constant = self.bounds.size.height*42/248;
        _sliderHeightConstrait.constant = self.bounds.size.height*50/248;
    }
  //244*248
}

//根据Pm值设置滑竿位置
//绿色：0-35
//黄色：36-75
//红色：76及以上
-(UIImage *)imgSliderFromPmValue:(long)pm
{
    if (pm < 36) {
        return [UIImage imageNamed:@"icon_sliderLeft"];
    }else if(pm < 76){
        return [UIImage imageNamed:@"icon_sliderCenter"];
    }else{
        return [UIImage imageNamed:@"icon_sliderRight"];
    }
}
@end
