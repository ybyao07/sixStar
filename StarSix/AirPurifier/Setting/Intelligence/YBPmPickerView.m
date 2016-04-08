//
//  YBPmPickerView.m
//  StarSix
//
//  Created by ybyao07 on 15/9/19.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "YBPmPickerView.h"

#define kDuration 0.5
#define kToobarHeight 40
#define _pickerViewHeight 216
@interface YBPmPickerView()
{
    UIToolbar *_toolbar;
    UIView *coverView;//蒙版
}
@property (nonatomic,strong) NSArray *pmValues;
@end

@implementation YBPmPickerView

@synthesize delegate=_delegate;
@synthesize pickerStyle=_pickerStyle;
@synthesize pmPicker=_pmPicker;

-(id)initWithStyle:(YBPmValueStyle)pickerStyle delegate:(id<YBPmValuePickerDelegate>)delegate
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"YBPmPickerView" owner:self options:nil] lastObject];
    if (self) {
        self.delegate = delegate;
        self.pickerStyle = pickerStyle;
        self.pmPicker.dataSource = self;
        self.pmPicker.delegate = self;
        self.backgroundColor = myColor(234, 234, 234);
        //加载数据
        if(self.pickerStyle == YBPmValue){
            self.pmValues =[NSArray arrayWithObjects:@"10",@"20",@"30",@"40",@"50",@"60", nil];
            self.pmValue = self.pmValues[0];
        }
        _toolbar = [self setToolbarStyle];
        [self setToolbarWithPickViewFrame];
        [self setFrame];
        [self addSubview:_toolbar];
        
    }
    return self;
}
//添加蒙版
-(void)addCoverBlackView
{
    UIView *view = [[UIApplication sharedApplication].windows lastObject];
    coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,kScreenH)];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remove)];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0.5;
    coverView.tag = 10001;
    [coverView addGestureRecognizer:gesture];
    [view addSubview:coverView];
}

-(UIToolbar *)setToolbarStyle
{
    UIToolbar *toolbar=[[UIToolbar alloc] init];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(remove)];
    leftItem.tintColor = [UIColor redColor];
    UIBarButtonItem *centerSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doneClick)];
    rightItem.tintColor = myColor(39, 183, 187);
    toolbar.items=@[leftItem,centerSpace,rightItem];
    toolbar.backgroundColor = myColor(245, 245, 245);
    return toolbar;
}
-(void)setToolbarWithPickViewFrame{
    _toolbar.frame = CGRectMake(0, 0, kScreenW, kToobarHeight);
}
-(void)setFrame{
    CGFloat toolViewX = 0;
    CGFloat toolViewH = _pickerViewHeight+kToobarHeight;
    CGFloat toolViewY;
    toolViewY = [UIScreen mainScreen].bounds.size.height - toolViewH;
    CGFloat toolViewW = [UIScreen mainScreen].bounds.size.width;
    self.frame = CGRectMake(toolViewX, toolViewY, toolViewW, toolViewH);
}
//移除
-(void)remove
{
    [self removeFromSuperview];
    [coverView removeFromSuperview];
}

//完成
-(void)doneClick
{
    if ([self.delegate respondsToSelector:@selector(pickerDidChangedStatus:)]) {
        [self.delegate pickerDidChangedStatus:self];
    }
    [self remove];
}
#pragma mark -PickerView lifecycle
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.pickerStyle == YBPmValue) {
        return 1;
    }else{
        return 1;
    }
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return self.pmValues.count;
            break;
        default:
            return 0;
            break;
    }
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.pickerStyle == YBPmValue) {
        switch (component) {
            case 0:
                return [self.pmValues objectAtIndex:row];
                break;
            default:
                return @"";
                break;
        }
    }else{
        return @"";
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.pickerStyle == YBPmValue) {
        [self.pmPicker selectRow:row inComponent:component animated:YES];
        self.pmValue = [self.pmValues objectAtIndex:row];
//        switch (component) {
//            case 0:
//                [self.pmPicker selectRow:row inComponent:component animated:YES];
//                break;
//                
//            default:
//                break;
//        }
    }
}

#pragma mark - animation
-(void)showInView:(UIView *)view
{
    self.frame = CGRectMake(0, view.frame.size.height, self.frame.size.width, self.frame.size.height);
    [view addSubview:self];
    [self addCoverBlackView];
    [UIView animateWithDuration:kDuration animations:^{
        self.frame = CGRectMake(0, view.frame.size.height-self.frame.size.height, self.frame.size.width, self.frame.size.height);
        //移动蒙版
        coverView.frame = CGRectMake(0,0, kScreenW, kScreenH-self.frame.size.height);
    }];
}
-(void)cancelPicker
{
    [UIView animateWithDuration:kDuration animations:^{
        self.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        [self remove];
    }];
}





@end
