//
//  CO2TableViewCell.m
//  StarSix
//
//  Created by ybyao07 on 15/9/17.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "CO2TableViewCell.h"

@implementation CO2TableViewCell

//PmValue设置的范围
static const NSInteger PmSettingValueMin=10;
static const NSInteger PmSettingValueMax = 1000;
//CO2设置值的范围
static const NSInteger CO2SettingValueMin = 800;
static const NSInteger CO2SettingValueMax = 1800;
- (void)awakeFromNib {
    // Initialization code
    if (_isCO2) {
        self.btnEdit.tag = 1;
    }else{
        self.btnEdit.tag = 2;
    }
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (_isCO2) {
        if ([textField.text integerValue] < CO2SettingValueMin || [textField.text integerValue] > CO2SettingValueMax) {
            UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"" message:@"您输入的范围不符合要求，CO2范围为(800~1800)" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alterView show];
        }
    }else{
        if ([textField.text integerValue] < PmSettingValueMin || [textField.text integerValue] > PmSettingValueMax) {
            UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"" message:@"您输入的范围不符合要求，PM2.5范围为(10~1000)" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alterView show];
        }
    }
    self.btnEdit.hidden = YES;
    if (self.editBlock) {
        self.editBlock([textField.text integerValue]);
    }
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.btnEdit.hidden = YES;
    [self endEditing:YES];
}







@end
