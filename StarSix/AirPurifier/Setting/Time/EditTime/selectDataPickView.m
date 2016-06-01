//
//  selectDataPickView.m
//  HangingFurnace
//
//  Created by 李晓 on 15/9/10.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "selectDataPickView.h"
#import "UIView+Extension.h"

@interface selectDataPickView()
{
    NSString *timeValue;
}

@end
@implementation selectDataPickView

+ (instancetype) createSelectDatePickView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"selectDataPickView" owner:nil options:nil]lastObject];
}

- (IBAction)cancelBtnClick:(UIButton *)sender {
    [self cleanMethod];
}

- (IBAction)sureBtnClick:(UIButton *)sender {
    NSInteger hour = [self.pickView selectedRowInComponent:0];
    NSInteger minute= [self.pickView selectedRowInComponent:1];
    NSString *timeHour = [NSString stringWithFormat:@"%.2ld",hour];
    NSString *timeMinute = [NSString stringWithFormat:@"%.2ld",minute];
    timeValue = [NSString stringWithFormat:@"%@:%@",timeHour,timeMinute];
    [self cleanMethod];
    [self doneClicked];
}

- (void) cleanMethod
{
    [UIView animateWithDuration:0.4f animations:^{
        self.y = kWindowHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.cleanClick) {
            self.cleanClick();
        }
    }];
}
-(void)doneClicked
{
    if ([self.delegate respondsToSelector:@selector(doneTimeClicked:withTimeValue:)]) {
        [self.delegate doneTimeClicked:self.pickView withTimeValue:timeValue];
    }
}


@end
