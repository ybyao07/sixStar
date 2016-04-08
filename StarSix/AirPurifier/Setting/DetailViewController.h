//
//  DetailViewController.h
//  AirPurifier
//
//  Created by bluE on 14-8-18.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertBox.h"
#import <MessageUI/MessageUI.h>
#import <MQTTKit.h>
#import "YBBaseViewController.h"
@interface DetailViewController : YBBaseViewController <UITableViewDataSource,UITableViewDelegate,AlertBoxDelegate,MFMailComposeViewControllerDelegate>
{
  
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) MQTTClient *mqClient;
//- (IBAction)onShare:(id)sender;

@end
