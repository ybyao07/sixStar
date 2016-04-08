//
//  AboutViewController.m
//  AirPurifier
//
//  Created by bluE on 14-8-25.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //显示版本号
    _version.text = [NSString stringWithFormat:@"软件版本信息:%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    
    _version.text = [NSString stringWithFormat:@"软件版本信息:%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [self.view addGestureRecognizer:tapGr];
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [self dismiss:^{
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onAboutClose {
    
    [self dismiss:^
     {
         if (self.delegate && [self.delegate respondsToSelector:@selector(onAboutCloseButtonOnClicked)])
         {
             [self.delegate onAboutCloseButtonOnClicked];
         }
     }];

}
@end
