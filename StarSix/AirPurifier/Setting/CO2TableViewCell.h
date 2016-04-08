//
//  CO2TableViewCell.h
//  StarSix
//
//  Created by ybyao07 on 15/9/17.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^editDoneBlock)(long CO2Value);

@interface CO2TableViewCell : UITableViewCell <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UITextField *txValue;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UILabel *lblUnit;



@property (nonatomic,strong) editDoneBlock editBlock;
@property (nonatomic,assign) BOOL isCO2;

@end
