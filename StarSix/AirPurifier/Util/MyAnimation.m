//
//  MyAnimation.m
//  AirPurifier
//
//  Created by bluE on 14-9-26.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import "MyAnimation.h"

@implementation MyAnimation
+ (void)showSubView:(UIView *)subView animation:(BOOL)animated
{
    if (animated) {
//        subView.hidden = NO;
//        subView.transform = CGAffineTransformMakeScale(0.9f, 0.9f);//将要显示的view按照正常比例显示出来
//        [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut]; //InOut 表示进入和出去时都启动动画
//        [UIView setAnimationDuration:2.0f];//动画时间
//        subView.transform=CGAffineTransformMakeScale(1.2f, 1.2f);
//        [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
//        [UIView commitAnimations]; //启动动画
//        
//        subView.transform=CGAffineTransformMakeScale(1.2f, 1.2f);
//        [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
//        subView.transform=CGAffineTransformMakeScale(1.0f, 1.0f);//先让要显示的view最小直至消失
//        [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
//        [UIView commitAnimations]; //启动动画
        CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        animation.duration = 0.2;
        NSMutableArray *values = [NSMutableArray array];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        animation.values = values;
        [subView.layer addAnimation:animation forKey:nil];
    }
}

+(void)showView:(UIView *)view
{
    view.alpha = 0.8;
    [UIView animateWithDuration:1.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut animations:^(void){
                            view.alpha = 1.0;
                        }
                     completion:^(BOOL finished){
                     }];

}

@end
