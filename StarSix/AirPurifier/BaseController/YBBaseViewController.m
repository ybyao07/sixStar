//
//  BaseViewController.m
//  StarSix
//
//  Created by ybyao07 on 15/9/16.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "YBBaseViewController.h"
#import "PureLayout.h"
#import "UIColor+Category.h"
#import "UIView+Extension.h"


#define kNavItemSapcing 15
#define kItem 30

@interface YBBaseViewController ()

@end

@implementation YBBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden=YES;
    //自定义导航条
    [self setupNavBar];
}

#pragma mark - 自定义导航条
- (void)setupNavBar
{
    UIView *navBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 64)];
    navBar.backgroundColor= kNavigationBarColor;
    [self.view addSubview:navBar];
    _navBar=navBar;
}

//创建导航栏按钮的方法
- (UIButton *)addBarButtonItemWithTitle:(NSString *)title image:(NSString *)imageName selector:(SEL)selector isLeft:(BOOL)isLeft
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame=CGRectZero;
    
    if (isLeft) {
        if(title.length>0){
            CGSize size=[title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
            [btn setTitle:title forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font=[UIFont systemFontOfSize:17];
            frame=CGRectMake(kNavItemSapcing,20+(44-size.height)*0.5, size.width, size.height);
        }else if(imageName.length>0){
            UIImage *image=[UIImage imageNamed:imageName];
            [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            frame=CGRectMake(kScreenW-image.size.width-kNavItemSapcing,20+(44-image.size.height*1.1)*0.5, image.size.width*1.1 , image.size.height*1.1);
        }
    }
    else{
        if(title.length>0){
            CGSize size=[title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
            [btn setTitle:title forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font=[UIFont systemFontOfSize:17];
            frame=CGRectMake(kScreenW-size.width-kNavItemSapcing-10,20+(44-size.height)*0.5, size.width+20, size.height);
        }else if(imageName.length>0){
            UIImage *image=[UIImage imageNamed:imageName];
            [btn setImage:image forState:UIControlStateNormal];
            [btn.imageView setContentMode:UIViewContentModeScaleAspectFill];
            //            [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            //            frame=CGRectMake(kScreenW-image.size.width-kNavItemSapcing - 18,20+(44-image.size.height*1.1)*0.5 - 4, image.size.width+18, image.size.height+8);
            frame=CGRectMake(kScreenW-image.size.width-kNavItemSapcing - 24,20, 70, 44);
        }
    }
    //添加按钮点击事件
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    btn.tag=11;
    //设置按钮尺寸
    [btn setFrame:frame];
    [_navBar addSubview:btn];
    return btn;
}

//设置导航栏标题
- (void)addBarItemTitle:(NSString *)title
{
    _titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0, kScreenW-90, 44)];
    _titleLabel.text=title;
    _titleLabel.textAlignment=NSTextAlignmentCenter;
    _titleLabel.font=[UIFont boldSystemFontOfSize:22];
    _titleLabel.textColor=[UIColor whiteColor];
    _titleLabel.center=CGPointMake(kScreenW*0.5,20+44*0.5);
    [_navBar addSubview:_titleLabel];
}

// 更改导航栏标题

-(void)changeBarItemTitle:(NSString *)title
{
    _titleLabel.text = title;
}

//设置返回按钮样式
- (void)addBarBackButtonItemWithImageName:(NSString *)imageName  selImageName:(NSString *)selImageName action:(SEL)selector
{
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.contentMode=UIViewContentModeCenter;
    UIImage *image=[UIImage imageNamed:imageName];
    [backBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:selImageName] forState:UIControlStateHighlighted];
    [backBtn setFrame:CGRectMake(-16, 20+(44-image.size.height*1.5)*0.5,image.size.width*2, image.size.height*1.5)];
    [backBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    //[backBtn setBackgroundColor:[UIColor redColor]];
//    [backBtn addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    [_navBar addSubview:backBtn];
}

-(void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)addNavigationBarCenterView:(UIView *)centerView
{
    CGSize size = centerView.size;
    centerView.translatesAutoresizingMaskIntoConstraints = NO;
    [_navBar addSubview:centerView];
    [centerView autoSetDimensionsToSize:size];
    [centerView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [centerView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_navBar withOffset:10];
}

@end
