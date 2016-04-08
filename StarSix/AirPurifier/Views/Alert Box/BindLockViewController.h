//
//  BindLockViewController.h
//  AirPurifier
//
//  Created by bluE on 14-8-27.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import "AlertBoxViewController.h"

@interface BindLockViewController : AlertBoxViewController

@property (weak, nonatomic) IBOutlet UITextView *txtBindOrLock;
- (IBAction)onOK:(id)sender;
- (IBAction)onCancel:(id)sender;
- (IBAction)onClose:(id)sender;

@end
