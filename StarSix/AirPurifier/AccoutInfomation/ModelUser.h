//
//  ModelUser.h
//  AirPurifier
//
//  Created by ybyao07 on 15/4/2.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "BaseModel.h"
#import "ModelNotice.h"

@interface ModelUser : BaseModel

@property (nonatomic, strong) NSString *login_id;
@property (nonatomic,strong) NSString *user_id;
@property (nonatomic, strong) NSString *user_name;//昵称
@property (nonatomic, strong) NSString *user_img;
@property (nonatomic, strong) NSString *user_email;//邮箱
@property (nonatomic, strong) NSString *user_phone;

//@property (nonatomic,strong) ModelNotice *noticeModel;



@end
