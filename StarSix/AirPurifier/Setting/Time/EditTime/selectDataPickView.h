//
//  selectDataPickView.h
//  HangingFurnace
//
//  Created by 李晓 on 15/9/10.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^cleanBtnClick)();


@protocol DoneButtonClicked <NSObject>

-(void)doneTimeClicked:(UIPickerView *)picker withTimeValue:(NSString *)time;

@end

@interface selectDataPickView : UIView
/**
 *  点击了取消Block
 */
@property (nonatomic,copy) cleanBtnClick cleanClick;
/**
 *  UIPickView
 */
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;
@property (strong,nonatomic) id<DoneButtonClicked> delegate;

/**
 *  取消方法
 */
- (void) cleanMethod;
/**
 *  创建SelectDatePickView
 */
+ (instancetype) createSelectDatePickView;

@end
