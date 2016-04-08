//
//  BaseViewController.h
//  StarSix
//
//  Created by ybyao07 on 15/9/16.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBBaseViewController : UIViewController

@property (nonatomic,strong)UIView *navBar;
@property (nonatomic,strong)UILabel *titleLabel;//标题
/**
 *  创建导航栏按钮的方法
 */
- (UIButton *)addBarButtonItemWithTitle:(NSString *)title image:(NSString *)imageName selector:(SEL)selector isLeft:(BOOL)isLeft;
/**
 *  设置导航栏标题
 */
- (void)addBarItemTitle:(NSString *)title;
/**
 * 更改导航栏标题
 **/
-(void)changeBarItemTitle:(NSString *)title;
/**
 *  设置返回按钮的样式
 */
- (void)addBarBackButtonItemWithImageName:(NSString *)imageName selImageName:(NSString *)selImageName action:(SEL)selector;
/**
 *  添加导航栏CenterView
 */
- (void)addNavigationBarCenterView:(UIView *)centerView;

@end
