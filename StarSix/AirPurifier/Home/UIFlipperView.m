//
//  UIFlipperView.m
//  AirPurifier
//
//  Created by bluE on 14-8-22.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import "UIFlipperView.h"

#define kFlingTime  0.18
@implementation UIFlipperView
@synthesize mWhichChild;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)showPrevious
{
    [self setDisplayedChild:(mWhichChild-1)];
}
- (void)showNext
{
    [self setDisplayedChild:(mWhichChild+1)];
}
- (void)setDisplayedChild:(NSInteger) whichChild
{
    BOOL flipToRight;
    if (whichChild > mWhichChild) {
        flipToRight = true;
    }
    else{
        flipToRight = false;
    }
    mWhichChild = whichChild;
    if (whichChild >= [self  getChildCount]) {
        mWhichChild = 0;
    } else if (whichChild < 0) {
        mWhichChild = [self  getChildCount] - 1;
    }
    [self showOnly:mWhichChild animamated:YES LeftToRight:flipToRight];
}
-(NSInteger)getDisplayedChild
{
    return mWhichChild;
}
-(void)showOnly:(NSInteger)childIndex animamated:(BOOL) animate  LeftToRight: (BOOL)flipToRight
{
    const int count = [self getChildCount];
    for (int i = 0; i < count; i++) {
        UIView *child = [self getChildAt:i];
        if (i == childIndex) {
            child.hidden=NO;
            if (flipToRight) {
                //动画效果，右滑动
                [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:child cache:YES];
                CATransition *transition = [CATransition animation];
                transition.duration =kFlingTime;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
                transition.type = kCATransitionMoveIn;
                transition.subtype = kCATransitionFromRight;//{kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom};
                [child.layer addAnimation:transition forKey:nil];
            }
            else{
                [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:child cache:YES];
                CATransition *transition = [CATransition animation];
                transition.duration =kFlingTime;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
                transition.type = kCATransitionMoveIn;
                transition.subtype = kCATransitionFromLeft;//{kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom};
                [child.layer addAnimation:transition forKey:nil];
            }
          
        } else {
            if (!child.hidden) {
                if (flipToRight) {
                    [UIView animateWithDuration:kFlingTime delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                        child.frame = CGRectMake(-child.frame.size.width,0, child.frame.size.width, child.frame.size.height);
                        child.alpha=0.0;
                    } completion:^(BOOL finished) {
                        child.frame = CGRectMake(0,0, child.frame.size.width, child.frame.size.height);
                        //                [self printSubviews];
                        child.hidden = YES;
                        child.alpha=1.0;
                    }];
                }else{
                    [UIView animateWithDuration:kFlingTime delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                        child.frame = CGRectMake(child.frame.size.width,0, child.frame.size.width, child.frame.size.height);
                        child.alpha=0.0;
                    } completion:^(BOOL finished) {
                        child.frame = CGRectMake(0,0, child.frame.size.width, child.frame.size.height);
                        //                [self printSubviews];
                        child.hidden = YES;
                        child.alpha=1.0;
                    }];
                }
            }
        }
    }

}
-(int)getChildCount
{
    NSArray *subviews = [self subviews];
    return  [subviews count];
}

-(UIView*)getChildAt:(NSInteger) index
{
    NSArray *subviews = [self subviews];
    return [subviews objectAtIndex:index];
}

-(void)showChildFirstView:(UIView *)childFirstView
{
    const int count = [self getChildCount];
    for (int i = 0; i < count; i++) {
        const UIView *child = [self getChildAt:i];
        child.hidden = YES;
    }
     childFirstView.hidden = NO;
}

- (void)showSubView:(UIView *)subView animation:(BOOL)animated
{
    if (animated) {
        subView.hidden = NO;
        subView.transform = CGAffineTransformMakeScale(0.01f, 0.01f);//将要显示的view按照正常比例显示出来
        [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut]; //InOut 表示进入和出去时都启动动画
        [UIView setAnimationDuration:0.5];//动画时间
        subView.transform=CGAffineTransformMakeScale(1.0f, 1.0f);//先让要显示的view最小直至消失
        [UIView commitAnimations]; //启动动画
    }
}
@end
