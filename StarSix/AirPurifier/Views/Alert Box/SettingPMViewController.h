//
//  SettingPMViewController.h
//  AirPurifier
//
//  Created by bluE on 14-10-28.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import "AlertBoxViewController.h"

@interface SettingPMViewController : AlertBoxViewController


@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)onSure:(id)sender;

@property (nonatomic)  NSUInteger curPmValue;
@end
