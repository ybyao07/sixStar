//
//  ModelNotice.h
//  AirPurifier
//
//  Created by ybyao07 on 15/4/2.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "BaseModel.h"
#import "LXSingleton.h"


@interface ModelNotice : NSObject

LXSingletonH(ModelNotice)

@property (nonatomic,strong) NSNumber *notice_pm;
@property (nonatomic,strong) NSNumber *notice_pm_value;
@property (nonatomic,strong) NSNumber *notice_filter;



@end
