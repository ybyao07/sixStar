//
//  UserTableViewCell.m
//  StarSix
//
//  Created by ybyao07 on 15/9/16.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "UserTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface UserTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgUser;
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;

@end
@implementation UserTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.imgUser.contentMode = UIViewContentModeScaleAspectFill;
    self.imgUser.layer.masksToBounds = YES;
    self.imgUser.layer.cornerRadius = self.imgUser.bounds.size.height/2.0;  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)setModel:(ModelUser *)model
{
    _model = model;
    [self.imgUser sd_setImageWithURL:[NSURL URLWithString:_model.user_img] placeholderImage:[UIImage imageNamed:@"view_userface"]];
    _txtUserName.text = _model.user_name;
}
@end
