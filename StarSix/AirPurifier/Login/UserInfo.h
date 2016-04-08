//
//  UserInfo.h
//  AirPurifier
//
//  Created by ybyao07 on 15/4/2.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "BaseModel.h"

@interface UserInfo : BaseModel

@property (nonatomic, strong) NSString *loginID;
@property (nonatomic, strong) NSString *loginPwd;
@property (nonatomic) int loginType;



@end
