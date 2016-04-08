//
//  YBPmPickerView.h
//  StarSix
//
//  Created by ybyao07 on 15/9/19.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    YBPmValue,
} YBPmValueStyle;

@class YBPmPickerView;

@protocol YBPmValuePickerDelegate <NSObject>

-(void)pickerDidChangedStatus:(YBPmPickerView *)picker;

@end
@interface YBPmPickerView : UIView <UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *pmPicker;

@property (nonatomic,assign) id<YBPmValuePickerDelegate> delegate;
@property (nonatomic) YBPmValueStyle pickerStyle;

@property (nonatomic,strong) NSString *pmValue;

-(id)initWithStyle:(YBPmValueStyle)pickerStyle delegate:(id<YBPmValuePickerDelegate>)delegate;
-(void)showInView:(UIView *)view;
-(void)cancelPicker;
-(void)remove;


@end
