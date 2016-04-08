//
//  LogoutViewController.m
//  AirPurifier
//
//  Created by bluE on 14-10-23.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import "LogoutViewController.h"

@interface LogoutViewController ()

@property (weak, nonatomic) IBOutlet UIButton *roundBtnSure;
@property (weak, nonatomic) IBOutlet UIButton *roundBtnCancel;

@end

@implementation LogoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _roundBtnSure.layer.cornerRadius = 2;
    _roundBtnCancel.layer.cornerRadius = 2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onClose:(id)sender {
   [ self dismiss:^{
   }];
}

- (IBAction)onLogout:(id)sender {
    [self dismiss:^
     {
         if (self.delegate && [self.delegate respondsToSelector:@selector(onLogoutSure)])
         {
             [self.delegate onLogoutSure];
         }
     }];
}

- (IBAction)onCancel:(id)sender {
    [ self dismiss:^{
    }];
}
@end
