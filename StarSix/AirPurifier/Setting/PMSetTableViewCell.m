//
//  PMSetTableViewCell.m
//  StarSix
//
//  Created by ybyao07 on 15/10/16.
//  Copyright © 2015年 skyware. All rights reserved.
//

#import "PMSetTableViewCell.h"

@implementation PMSetTableViewCell
//PmValue设置的范围
static const NSInteger PmSettingValueMin=10;
static const NSInteger PmSettingValueMax = 1000;

- (void)awakeFromNib {
    // Initialization code
    self.btnEdit.hidden = YES;
    self.txValue.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.btnEdit.hidden = NO;
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
        if ([textField.text integerValue] < PmSettingValueMin || [textField.text integerValue] > PmSettingValueMax) {
            UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"" message:@"你输入的范围不符合要求，PM2.5范围为(10~1000)" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alterView show];
            return;
        }
    self.btnEdit.hidden = YES;
    if (self.editBlock) {
        self.editBlock([textField.text integerValue]);
    }
    [self endEditing:YES];
}



@end
