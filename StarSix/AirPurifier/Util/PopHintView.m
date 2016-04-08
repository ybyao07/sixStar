//
//  PopHintView.m
//  startKitchen
//
//  Created by ybyao07 on 15/3/22.
//  Copyright (c) 2015年 203b. All rights reserved.
//

#import "PopHintView.h"

@implementation PopHintView

{
    NSTimer *_timer;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title
{
    self= [super initWithFrame:frame];
    if (self!=nil) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, kScreenW - 40, 40)];
        [btn setBackgroundImage:[UIImage imageNamed:@"pop_background"] forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateNormal];
        [self addSubview:btn];
        btn.center = self.center;
        NSTimer *timer=[NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(removeFromSuperview) userInfo:nil repeats:NO];
        _timer=timer;
    }
    return self;
}


+(void)showViewWithTitle:(NSString *)title
{
    UIView * view = [[UIApplication sharedApplication].windows lastObject];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, kScreenW - 40, 40)];
    [btn setBackgroundImage:[UIImage imageNamed:@"pop_background"] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [view addSubview:btn];
    btn.tag = 1111111;
    btn.center = view.center;
    [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(hideView) userInfo:nil repeats:NO];
}

+(void)showAlertViewWithTitle:(NSString *)title iconImage:(NSString *)iconStr
{
    UIView * view = [[UIApplication sharedApplication].windows lastObject];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW-60, 70)];
    bgView.tag = 1111111;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bgView.bounds.size.width, bgView.bounds.size.height)];
    imgView.image = [UIImage imageNamed:@"alterBackground"];
    imgView.userInteractionEnabled = YES;
    UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
    [imgView addGestureRecognizer:gesture];
    [bgView addSubview:imgView];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 25, 20, 20)];
    icon.image = [UIImage imageNamed:iconStr];
    [bgView addSubview:icon];
    
    UILabel *textLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+10, 20, bgView.bounds.size.width - 20, 20)];
    textLable.text = title;
    [bgView addSubview:textLable];
    
    [view addSubview:bgView];
    bgView.center = view.center;
}



+ (void)hideView
{
    UIView *view = [[UIApplication sharedApplication].windows lastObject];
    for (UIView *loadingView in view.subviews) {
        if (loadingView.tag == 1111111) {
            [loadingView removeFromSuperview];
        }
    }
}






@end
