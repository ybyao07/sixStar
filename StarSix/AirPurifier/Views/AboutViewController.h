//
//  AboutViewController.h
//  AirPurifier
//
//  Created by bluE on 14-8-25.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import "AlertBoxViewController.h"

@interface AboutViewController : AlertBoxViewController

- (IBAction)onAboutClose;


@property (weak, nonatomic) IBOutlet UILabel *version;

@end
