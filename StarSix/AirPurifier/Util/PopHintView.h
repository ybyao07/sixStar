//
//  PopHintView.h
//  startKitchen
//
//  Created by ybyao07 on 15/3/22.
//  Copyright (c) 2015年 203b. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopHintView : UIView

-(instancetype)initWithFrame:(CGRect)frame withTitle:(NSString  *)title;
+(void)showViewWithTitle:(NSString *)title;

/**
 *  滤网，和PM值提醒
 *
 *  @param title   显示提示内容
 *  @param iconStr 图标的Url
 */
+(void)showAlertViewWithTitle:(NSString *)title iconImage:(NSString *)iconStr;
+(void)hideView;


@end
