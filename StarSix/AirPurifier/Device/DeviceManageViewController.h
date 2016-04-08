//
//  DeviceManageViewController.h
//  AirPurifier
//
//  Created by bluE on 14-8-25.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertBox.h"
#import "YBBaseViewController.h"
#import <MQTTKit.h>
@interface DeviceManageViewController : YBBaseViewController <UITableViewDataSource,UITableViewDelegate, AlertBoxDelegate>

@property (weak, nonatomic) IBOutlet UITableView *ListView;
@property (strong ,nonatomic) NSMutableArray *listDevices;

- (IBAction)onBack:(id)sender;

@property (strong,nonatomic) MQTTClient *mqClient;

@end
