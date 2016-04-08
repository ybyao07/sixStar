//
//  Identifier.m
//  AirPurifier
//
//  Created by bluE on 14-8-20.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import "Identifier.h"
#import "AirPurifierAppDelegate.h"
#import "AlertBox.h"
#import "AFNetworking.h"
#import <SMS_SDK/SMS_SDK.h>

@implementation Identifier
+(void)getIndentifier:(NSURL *)URLString phoneNumber:(NSString *)PhoneNumber
{
    //post提交的参数，格式如下：参数1名字=参数1数据&参数2名字＝参数2数据&参数3名字＝参数3数据&...
    NSString *post = [NSString stringWithFormat:@"user_phone=%@",PhoneNumber];
    NSMutableURLRequest *request =  [MainDelegate requestUrl:URLString method:@"POST" postFormData:post];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response,NSData *data,NSError *error)
     {
         NSString *errorInfo = Localized(@"网络异常,请稍后再试");
         if(error)
         {
             [AlertBox showWithMessage:errorInfo];
         }
         else
         {
             NSDictionary *result = [MainDelegate parseJsonData:data];
//             NSString *strResult = [result objectForKey:@"result"];
             NSString *strCode = [result objectForKey:@"respCode"];
             //将NSData类型的返回值转换成NSString类型
             // NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]
             NSLog(@"user login check result:%@",result);
             if ([strCode isEqualToString:@"1"]) {
                 //发送成功
             }
             if ([strCode isEqualToString:@"0"]) {
                 NSString *errorInfo = Localized(@"发送失败");
                 [AlertBox showWithMessage:errorInfo];
             }
        }
     }];
}

+(void)getCodeAgain:(NSString *)phoneNumber onView:(UIView *)view
{
    [MainDelegate showProgressHubInView:view];
    [SMS_SDK getVerifyCodeByPhoneNumber:phoneNumber AndZone:@"86" result:^(enum SMS_GetVerifyCodeResponseState state) {
        [MainDelegate hiddenProgressHubInView:view];
        if (1==state) {
            NSLog(@"block 获取验证码成功");
        }
        else if(0==state)
        {
            NSLog(@"block 获取验证码失败");
            NSString* str=[NSString stringWithFormat:@"验证码发送失败 请稍后重试"];
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"发送失败" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else if (SMS_ResponseStateMaxVerifyCode==state)
        {
            NSString* str=[NSString stringWithFormat:@"请求验证码超上限 请稍后重试"];
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"超过上限" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else if(SMS_ResponseStateGetVerifyCodeTooOften==state)
        {
            NSString* str=[NSString stringWithFormat:@"客户端请求发送短信验证过于频繁"];
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

@end
