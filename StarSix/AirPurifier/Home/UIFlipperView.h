//
//  UIFlipperView.h
//  AirPurifier
//
//  Created by bluE on 14-8-22.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFlipperView : UIView

@property NSInteger mWhichChild;
@property CAAnimation *mInAnimation;
- (void)showPrevious;
- (void)showNext;


- (void)setDisplayedChild:(NSInteger) whichChild;
-(NSInteger)getDisplayedChild;


-(UIView*)getChildAt:(NSInteger) index;
-(void)showOnly:(NSInteger)childIndex animamated:(BOOL) animate LeftToRight: (BOOL)flipToRight;
-(void)showChildFirstView:(UIView *)childFirstView;

- (void)showSubView:(UIView *)subView animation:(BOOL)animated;
@end
