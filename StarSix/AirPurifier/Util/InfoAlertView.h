//
//  InfoAlertView.h
//  AirPurifier
//
//  Created by bluE on 14-8-22.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoAlertView : UIAlertView
@property(nonatomic, retain) UITextField* _oldPwd;    // 旧密码输入框
@property(nonatomic, strong) UITextField* _Pwd;    // 新密码输入框
@property(nonatomic, retain) UITextField* _cfmPwd;    // 新密码确认框

@end
