//
//  CustomTimeViewController.m
//  HangingFurnace
//
//  Created by 李晓 on 15/9/9.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "CustomTimeViewController.h"
#import "selectDataPickView.h"
#import "PureLayout.h"
#import "UIView+Extension.h"
#import "NSString+Extension.h"
#import "UIWindow+Extension.h"
#import "UIColor+Utility.h"

@interface CustomTimeViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate,DoneButtonClicked>
{
    selectDataPickView *_pick;
    NSIndexPath *_indexPath; // 点击的Cell indexPath ，设置选中的时间以及温度
}

@property (nonatomic,strong) NSMutableArray *hourArray;
@property (nonatomic,strong) NSMutableArray *minuteArray;

@end

@implementation CustomTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavView];
    [self.dataList addObjectsFromArray:@[@"开启",@"关闭"]];
    [self addNavRightBtn];
//    [kNotificationCenter addObserver:self selector:@selector(selectDatePickViewCenterBtnClick:) name:kSelectCustomDatePickNotification object:nil];
}
-(void)initNavView
{
    [self setNavTitle:@"编辑时间段"];
//    [self addBarBackButtonItemWithImageName:@"back_normal" selImageName:@"back_pressed" action:@selector(onBack)];
}
#pragma mark - Method
- (void) addNavRightBtn
{
//    __weak typeof (self.dataList) data = self.dataList;
//    __weak typeof (self.tableView) tableView = self.tableView;
//    __weak typeof (self.navigationController) nav = self.navigationController;
//    [self setRightBtnWithImage:nil orTitle:@"确定" ClickOption:^{
//        [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
//            NSLog(@"%@",cell.detailTextLabel.text);
//        }];
//        [nav popViewControllerAnimated:YES];
//    }];
}

#pragma mark - UIPickerView 选择时间Delegate
-(void)doneTimeClicked:(UIPickerView *)picker withTimeValue:(NSString *)time
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_indexPath];
    cell.detailTextLabel.text = time;
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CustomTimeViewControllerCellID = @"CustomTimeViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomTimeViewControllerCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CustomTimeViewControllerCellID];
    }
    cell.textLabel.text = self.dataList[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
//    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.detailTextLabel.textColor = [UIColor colorWithHex:0x868686 alpha:1.0];
    cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = self.customModel.openTime;
    }else if (indexPath.row == 1){
        cell.detailTextLabel.text = self.customModel.closeTime;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _indexPath = indexPath;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_indexPath];
    NSString *selectWeekStr = cell.detailTextLabel.text;
    [self createTimePickviewWithInitTime:selectWeekStr];
}

- (void) createTimePickviewWithInitTime:(NSString *) define
{
    selectDataPickView *pick = [selectDataPickView createSelectDatePickView];
    pick.delegate = self;
    _pick = pick;
    pick.pickView.delegate =self ;
    pick.pickView.dataSource = self;
    //覆盖半透明层
    UIButton *cover = [UIButton newAutoLayoutView];
    [cover addTarget:pick action:@selector(cleanMethod) forControlEvents:UIControlEventTouchUpInside];
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.4;
    [[UIWindow getCurrentWindow] addSubview:cover];
    [cover autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    pick.cleanClick = ^{
        [cover removeFromSuperview];
    };
    pick.frame = CGRectMake(0, kWindowHeight, kWindowWidth, 240);
    [[UIWindow getCurrentWindow] addSubview:pick];
    [UIView animateWithDuration:0.4f animations:^{
        pick.y = (kWindowHeight - pick.height);
    } completion:^(BOOL finished) {
        
    }];

    NSArray *array = [define componentsSeparatedByString:@":"];
    [array enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL *stop) {
//        [pick.pickView selectRow:[[str getTheCorrect] integerValue] inComponent:idx animated:YES];
    }];
}

#pragma mark - UIPickerViewDataSource,UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
        if (component == 0) { // 小时
            return self.hourArray.count;
        }else{// 分钟
            return self.minuteArray.count;
        }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
        NSDictionary *attributeDict = @{NSForegroundColorAttributeName :kNavigationBarColor,NSFontAttributeName:[UIFont systemFontOfSize:16]};
    NSAttributedString *attributedString = nil;
    if (component == 0) {
        attributedString = [[NSAttributedString alloc] initWithString:self.hourArray[row] attributes:attributeDict];
    }else{
        attributedString = [[NSAttributedString alloc] initWithString:self.minuteArray[row] attributes:attributeDict];
    }
    return attributedString;
}

-(void)NavBackBtnClick
{
    _customModel.openTime  = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].detailTextLabel.text;
    _customModel.closeTime = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].detailTextLabel.text;
    //保存时间
    NSDictionary *accountDetails = @{@"timeModel":_customModel,
                                     @"index":@(_indexOfTimer),
                                    };
    
    [NotificationCenter postNotificationName:@"TimeSetingNotification" object:self userInfo:accountDetails];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 懒加载
- (NSMutableArray *)hourArray
{
    if (!_hourArray) {
        _hourArray = [[NSMutableArray alloc] init];
        for (int i = 0; i<24; i++) {
            [_hourArray addObject:[NSString stringWithFormat:@"%.2d 时",i]];
        }
    }
    return _hourArray;
}

- (NSMutableArray *)minuteArray
{
    if (!_minuteArray) {
        _minuteArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 60; i++) {
            [_minuteArray addObject:[NSString stringWithFormat:@"%.2d 分",i]];
        }
    }
    return _minuteArray;
}

@end
