//
//  CustomTimeViewController.h
//  HangingFurnace
//
//  Created by 李晓 on 15/9/9.
//  Copyright (c) 2015年 skyware. All rights reserved.
//


#import "CustomModel.h"
#import "BaseTableViewController.h"
@interface CustomTimeViewController : BaseTableViewController

@property (nonatomic,strong) CustomModel *customModel;
@property (nonatomic,assign) NSInteger indexOfTimer;

@end
