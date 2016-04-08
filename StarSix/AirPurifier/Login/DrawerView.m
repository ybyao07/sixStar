//
//  DrawerView.m
//  DrawerDemo
//
//  Created by Zhouhaifeng on 12-3-27.
//  Copyright (c) 2012年 CJLU. All rights reserved.
//

#import "DrawerView.h"
#define Height 30
@implementation DrawerView
@synthesize contentView,parentView,drawState;
@synthesize arrow;

- (id)initWithView:(UIView *) contentview parentView :(UIView *) parentview;
{
    self = [super initWithFrame:CGRectMake(0,0,kScreenW, contentview.frame.size.height+Height)];
    NSLog(@"width = %f,height = %f",contentview.frame.size.width,contentview.frame.size.height);
    if (self) {
        // Initialization code        
        contentView = contentview;
        parentView = parentview;
        //一定要开启
        [parentView setUserInteractionEnabled:YES];
        //嵌入内容区域的背景
        UIImage *drawer_bg = [UIImage imageNamed:@"thirdlogin_dialog.png"];
        UIImageView *view_bg = [[UIImageView alloc]initWithImage:drawer_bg];
        [view_bg setFrame:CGRectMake(0,Height,contentview.frame.size.width, contentview.bounds.size.height)];
        [self addSubview:view_bg];
        //头部拉拽的区域背景
        UIImage *drawer_handle = [UIImage imageNamed:@"connectonclick_1.png"];
        UIImageView *view_handle = [[UIImageView alloc]initWithImage:drawer_handle];
        [view_handle setFrame:CGRectMake(0,0,contentview.frame.size.width,Height)];
        [self addSubview:view_handle];
        //"使用合作网站账号登陆"
        UITextField *txtCollaborator = [[UITextField alloc] init];
        txtCollaborator.text = @"使用合作网站账号登录";
        txtCollaborator.enabled = NO;
        txtCollaborator.textAlignment = NSTextAlignmentCenter;
        txtCollaborator.textColor = [UIColor grayColor];
        txtCollaborator.font = [UIFont systemFontOfSize:13.0f];
        [txtCollaborator setFrame:CGRectMake(0, Height/2-10, kScreenW-40, Height)];
        [self addSubview:txtCollaborator];
        //箭头的图片，暂时没有使用
//        UIImage *drawer_arrow = [UIImage imageNamed:@"drawer_arrow.png"];
//        UIImage *drawer_arrow = [UIImage imageNamed:@"0.png"];
//        arrow = [[UIImageView alloc]initWithImage:drawer_arrow];
//        [arrow setFrame:CGRectMake(0,0,15,15)];
//        arrow.center = CGPointMake(kScreenW/2.0, Height/2);
//        [self addSubview:arrow];
        //嵌入内容的UIView
        [contentView setFrame:CGRectMake(0,Height+5,contentview.frame.size.width, contentview.bounds.size.height+Height)];
        [self addSubview:contentView];
        //移动的手势
        UIPanGestureRecognizer *panRcognize=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];  
        panRcognize.delegate=self;  
        [panRcognize setEnabled:YES];  
        [panRcognize delaysTouchesEnded];  
        [panRcognize cancelsTouchesInView];
        [self addGestureRecognizer:panRcognize];
        //单击的手势
        UITapGestureRecognizer *tapRecognize = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];  
        tapRecognize.numberOfTapsRequired = 1;  
        tapRecognize.delegate = self;  
        [tapRecognize setEnabled :YES];  
        [tapRecognize delaysTouchesBegan];  
        [tapRecognize cancelsTouchesInView];
        [self addGestureRecognizer:tapRecognize];
        
        //设置两个位置的坐标 view在父窗口中的位置设置
        downPoint = CGPointMake(kScreenW/2+20, parentview.frame.size.height+contentview.frame.size.height/2-Height);
        upPoint = CGPointMake(kScreenW/2+20, parentview.frame.size.height-contentview.frame.size.height/2-Height+30);
        self.center =  downPoint;
        //设置起始状态
        drawState = DrawerViewStateDown;
    }
    return self;
}
#pragma UIGestureRecognizer Handles  
/*    
 *  移动图片处理的函数 
 *  @recognizer 移动手势 
 */  
- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:parentView]; 
    if (self.center.y + translation.y < upPoint.y) {
        self.center = upPoint;
    }else if(self.center.y + translation.y > downPoint.y)
    {
        self.center = downPoint;
    }else{
        self.center = CGPointMake(self.center.x,self.center.y + translation.y);  
    }
    [recognizer setTranslation:CGPointMake(0, 0) inView:parentView];  
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {  
        [UIView animateWithDuration:0.1 delay:0.05 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    if (self.center.y < downPoint.y*3/5)
                {
                    self.center = upPoint;
                    [self transformArrow:DrawerViewStateUp];
                }else
                {
                    self.center = downPoint;
                    [self transformArrow:DrawerViewStateDown];
                }

        } completion:nil];  
 
    }    
}  

/* 
 *  handleTap 触摸函数 
 *  @recognizer  UITapGestureRecognizer 触摸识别器 
 */  
-(void) handleTap:(UITapGestureRecognizer *)recognizer  
{  
        [UIView animateWithDuration:0.1 delay:0.05 options:UIViewAnimationOptionTransitionCurlDown animations:^{
            if (drawState == DrawerViewStateDown) {
                self.center = upPoint;
                [self transformArrow:DrawerViewStateUp];
            }else
            {
                self.center = downPoint;
                [self transformArrow:DrawerViewStateDown];
            }
        } completion:nil];  
} 

/* 
 *  transformArrow 改变箭头方向
 *  state  DrawerViewState 抽屉当前状态 
 */ 
-(void)transformArrow:(DrawerViewState) state
{
        //NSLog(@"DRAWERSTATE :%d  STATE:%d",drawState,state);
        [UIView animateWithDuration:0.3 delay:0.35 options:UIViewAnimationOptionCurveEaseOut animations:^{  
           if (state == DrawerViewStateUp){   
                    arrow.transform = CGAffineTransformMakeRotation(M_PI);
                }else
                {
                     arrow.transform = CGAffineTransformMakeRotation(0);
                }
        } completion:^(BOOL finish){
               drawState = state;
        }];
}


@end
