//
//  BindLockViewController.m
//  AirPurifier
//
//  Created by bluE on 14-8-27.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import "BindLockViewController.h"

@interface BindLockViewController ()
@property (weak, nonatomic) IBOutlet UIButton *roundBtnSure;
@property (weak, nonatomic) IBOutlet UIButton *roundBtnCancel;

@end

@implementation BindLockViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _roundBtnCancel.layer.cornerRadius = 2;
    _roundBtnSure.layer.cornerRadius = 2;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onOK:(id)sender {
    [self dismiss:^
     {
         if (self.delegate && [self.delegate respondsToSelector:@selector(onBindLockUnlockOKButtonOnClicked:)])
         {
             [self.delegate onBindLockUnlockOKButtonOnClicked:_txtBindOrLock.text];
         }
     }];
}

- (IBAction)onCancel:(id)sender {
    [self dismiss:^
     {
         if (self.delegate && [self.delegate respondsToSelector:@selector(onDeviceManageCancelButtonOnClicked)])
         {
             [self.delegate onDeviceManageCancelButtonOnClicked];
         }
     }];
}

- (IBAction)onClose:(id)sender {
    [self dismiss:^
     {
         if (self.delegate && [self.delegate respondsToSelector:@selector(onDeviceManageCancelButtonOnClicked)])
         {
             [self.delegate onDeviceManageCancelButtonOnClicked];
         }
     }];
}
@end
