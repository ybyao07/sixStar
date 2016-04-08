//
//  PMSetTableViewCell.h
//  StarSix
//
//  Created by ybyao07 on 15/10/16.
//  Copyright © 2015年 skyware. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^editDoneBlock)(long PMValue);

@interface PMSetTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UITextField *txValue;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (nonatomic,strong) editDoneBlock editBlock;

@end
