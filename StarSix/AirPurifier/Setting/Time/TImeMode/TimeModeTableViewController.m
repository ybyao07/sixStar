//
//  TimeModeTableViewController.m
//  StarSix
//
//  Created by ybyao07 on 15/9/17.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "TimeModeTableViewController.h"
#import "SwitchHeaderView.h"
#import "RadioTableViewCell.h"
#import "CustomTimeViewController.h"
#import "TimeValueTableViewCell.h"
#import "AirPurifierAppDelegate.h"
#import "AirPurifierViewController.h"
#import "UtilConversion.h"
#import "SendCommandManager.h"

@interface TimeModeTableViewController ()
{
    NSArray *arrModes;
}
@property (nonatomic,strong) DeviceSettingTimeModel *currentTimeModel;

@end

@implementation TimeModeTableViewController

//00X XXXX
const static unsigned int timeOneOpen = 8;//定时器1开
const static unsigned int timeTwoOpen = 16; //定时器2开
const static unsigned int timeThreeOpen = 32;//定时器3开

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavView];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    arrModes = @[@"每天",@"仅一次",@"工作日"];
    if (_deviceVo) {
        _currentTimeModel = _deviceVo.deviceData.timeModel;
    }else{
        _currentTimeModel = [[DeviceSettingTimeModel alloc] init];
        _currentTimeModel.oneSettingTimeModel = [CustomModel createCustomModelWithOpenTime:@"08:00" CloseTime:@"10:00" isOpen:NO];
        _currentTimeModel.twoSettingTimeModel = [CustomModel createCustomModelWithOpenTime:@"09:00" CloseTime:@"12:00" isOpen:NO];
        _currentTimeModel.threeSettingTimeModel = [CustomModel createCustomModelWithOpenTime:@"13:00" CloseTime:@"23:00" isOpen:NO];
    }
    [NotificationCenter addObserver:self selector:@selector(updateTimeTableView:) name:@"TimeSetingNotification" object:nil];
}

-(void)updateTimeTableView:(NSNotification *)nofify
{
    NSMutableDictionary *dic = (NSMutableDictionary *)nofify.userInfo;
    CustomModel *model =  dic[@"timeModel"];
    int index = [dic[@"index"] intValue];
    NSString *strCmd;
    if (index == 3) {
        _currentTimeModel.oneSettingTimeModel = model;
        strCmd = [self getTimerStringCmd:_currentTimeModel.oneSettingTimeModel cmdCode:@"51"];
    }else if (index == 4){
        _currentTimeModel.twoSettingTimeModel = model;
        strCmd = [self getTimerStringCmd:_currentTimeModel.twoSettingTimeModel cmdCode:@"52"];
    }else{
        _currentTimeModel.threeSettingTimeModel = model;
        strCmd = [self getTimerStringCmd:_currentTimeModel.threeSettingTimeModel cmdCode:@"53"];
    }
    //这里只需要发送定时时间，不用考虑是否开启定时
    [self sendModeCommand:strCmd];
    [self.tableView reloadData];
}




-(void)initNavView
{
    [self addBarItemTitle:@"定时"];
    [self addBarBackButtonItemWithImageName:@"back_normal" selImageName:@"back_pressed" action:@selector(onBack)];
}

#pragma mark UITableViewDelegate
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 65;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 64)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_white"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.frame = CGRectMake(0, 20, kScreenW, 44);
    [bgView addSubview:imageView];
    
    SwitchHeaderView *switchHeader = [[SwitchHeaderView alloc] initWithFrame:CGRectMake(0, 20, kScreenW, 44)];
    switchHeader.backgroundColor = [UIColor whiteColor];
    switchHeader.block = ^(BaseModel *model,UISwitch *swithM){
        _currentTimeModel.status = swithM.isOn;
        //发送指令
        NSString *strCommand;
        //根据_currentTimeModel来发送指令-- 这里包含两种指令（1、模式开关指令）
        if (!_currentTimeModel.status) {//关闭定时模式
            strCommand = @"5000";
        }else{
            strCommand = [self getTimerMode] ;
        }
        [self sendModeCommand:strCommand];
        [self.tableView reloadData];
    };
    switchHeader.model = _currentTimeModel;
    [bgView addSubview:switchHeader];
    return bgView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 3) {
        RadioTableViewCell * radioCell =   [self creatRadioCellInTableView:tableView forIndex:indexPath];
        return radioCell;
    }else{
        static NSString *cellID = @"TimeCell";
        TimeValueTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TimeValueTableViewCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [self setTimeCheckViewCell:cell AtIndex:indexPath.row];
        cell.infoClickOption = ^{
            CustomTimeViewController *timeVC = [[CustomTimeViewController alloc] init];
            CustomModel *customModel;
            if (indexPath.row == 3) {
                customModel = _currentTimeModel.oneSettingTimeModel;
            }else if(indexPath.row == 4){
                customModel = _currentTimeModel.twoSettingTimeModel;
            }else{
                customModel = _currentTimeModel.threeSettingTimeModel;
            }
            timeVC.customModel = customModel;
            timeVC.indexOfTimer = indexPath.row;
            [self.navigationController pushViewController:timeVC animated:YES];
        };
        return cell;
    }
}

//设置UITableViewCell的选中状体
-(void)setTimeCheckViewCell:(TimeValueTableViewCell *)cell AtIndex:(NSInteger)index
{
    CustomModel *model;
    if (index == 3) {
       model = _currentTimeModel.oneSettingTimeModel;
    }else if (index == 4){
        model = _currentTimeModel.twoSettingTimeModel;
    }else{
        model = _currentTimeModel.threeSettingTimeModel;
    }
    if (model.isOpen) {
//        cell.imageView.image = [UIImage imageNamed:@"check"];
        cell.chechImgView.image = [UIImage imageNamed:@"check"];
    }else{
//        cell.imageView.image = [UIImage imageNamed:@"uncheck"];
        cell.chechImgView.image = [UIImage imageNamed:@"uncheck"];
    }
    cell.lblTimeView.text = [NSString stringWithFormat:@"%@ - %@",model.openTime,model.closeTime];
//    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@",model.openTime,model.closeTime];
//    
//    cell.accessoryView = [[UIView alloc] initWithFrame:CGRectZero];
}


//创建UITableViewCell
-(RadioTableViewCell *)creatRadioCellInTableView:(UITableView *)tableView forIndex:(NSIndexPath *)indexPath
{
    static NSString *radiocellIdentifier = @"RadioCell";
    RadioTableViewCell *radioCell = [tableView dequeueReusableCellWithIdentifier:radiocellIdentifier];
    if (radioCell == nil) {
        radioCell = [[[NSBundle mainBundle] loadNibNamed:@"RadioTableViewCell" owner:nil options:nil] lastObject];
        radioCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    radioCell.modeName.text = arrModes[indexPath.row];
    if (indexPath.row== 0) {
        if (_currentTimeModel.mode == Everyday) {
            [radioCell.radioBtn setSelected:YES];
        }else{
            [radioCell.radioBtn setSelected:NO];
        }
    }else if (indexPath.row == 1){
        if (_currentTimeModel.mode == OnlyOnce) {
            [radioCell.radioBtn setSelected:YES];
        }else{
            [radioCell.radioBtn setSelected:NO];
        }
    }else{
        if (_currentTimeModel.mode == Weekday) {
            [radioCell.radioBtn setSelected:YES];
        }else{
            [radioCell.radioBtn setSelected:NO];
        }
    }
    radioCell.radioBlock = ^{
        if (indexPath.row  == 0) {
            _currentTimeModel.mode = Everyday;
        }else if (indexPath.row == 1){
            _currentTimeModel.mode = OnlyOnce;
        }else{
            _currentTimeModel.mode = Weekday;
        }
        //发送指令
        [self sendModeCommand:[self getTimerMode]];
        [self.tableView reloadData];
    };
    //设置开启，关闭的背景色-----------
    if (_currentTimeModel.status) {
        radioCell.contentView.backgroundColor = [UIColor colorWithHexString:@"f3f2f2"];
        radioCell.radioBtn.userInteractionEnabled = YES;
        radioCell.bigBtn.userInteractionEnabled = YES;
    }else{//置灰不可用
        radioCell.contentView.backgroundColor = [UIColor lightGrayColor];
        radioCell.radioBtn.userInteractionEnabled = NO;
        radioCell.bigBtn.userInteractionEnabled = NO;
    }
    return radioCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *strCmd;
    CustomModel *model;
    if (indexPath.row == 3) {
        model = _currentTimeModel.oneSettingTimeModel;
        strCmd = [self getTimerStringCmd:_currentTimeModel.oneSettingTimeModel cmdCode:@"51"];
    }else if (indexPath.row == 4){
        model = _currentTimeModel.twoSettingTimeModel;
        strCmd = [self getTimerStringCmd:_currentTimeModel.twoSettingTimeModel cmdCode:@"52"];
    }else if (indexPath.row == 5){
        model = _currentTimeModel.threeSettingTimeModel;
        strCmd = [self getTimerStringCmd:_currentTimeModel.threeSettingTimeModel cmdCode:@"53"];
    }
//    [self sendModeCommand:strCmd];
    if (model.isOpen) {
        model.isOpen = NO;
    }else{
        model.isOpen = YES;
    }
    //发送定时指令(包括 定时器 指定位置的值 eg.定时器1打开，则对应的定时器1的模式为置为1，否则置为0
    [self sendModeCommand:[NSString stringWithFormat:@"%@%@",strCmd,[self getTimerMode]]];
    [self.tableView reloadData];
}
//更新时间时间段模型
//-(void)updateTimePeridoModel:(NSInteger)index
//{
//    CustomModel *model = [_currentTimeModel.timePeriod objectAtIndex:index];
//    if (model.isOpen) {
//        model.isOpen = NO;
//    }else{
//        model.isOpen = YES;
//    }
//    [_currentTimeModel.timePeriod replaceObjectAtIndex:index withObject:model];
//    [self.tableView reloadData];
//}

//定时器命令字符串
-(NSString *)getTimerStringCmd:(CustomModel *)mode cmdCode:(NSString *)code
{
    NSArray *timeOpenArray = [mode.openTime componentsSeparatedByString:@":"];
    NSArray *timeCloseArray = [mode.closeTime componentsSeparatedByString:@":"];
    return [NSString stringWithFormat:@"%@%@%@%@%@",code,
            [UtilConversion decimalToHex:[timeOpenArray[0] intValue]],
            [UtilConversion decimalToHex:[timeOpenArray[1] intValue]],
            [UtilConversion decimalToHex:[timeCloseArray[0] intValue]],
            [UtilConversion decimalToHex:[timeCloseArray[1] intValue]]];
}
-(NSString *)getTimerMode
{
    unsigned int totalMode = _currentTimeModel.mode;
    if (_currentTimeModel.oneSettingTimeModel.isOpen) {
        totalMode = totalMode +timeOneOpen;
    }
    if (_currentTimeModel.twoSettingTimeModel.isOpen) {
        totalMode = totalMode + timeTwoOpen;
    }
    if (_currentTimeModel.threeSettingTimeModel.isOpen) {
        totalMode = totalMode + timeThreeOpen;
    }
   return [NSString stringWithFormat:@"50%@",[UtilConversion decimalToHex:totalMode]] ;
}

#pragma mark ---发送指令
-(void)sendModeCommand:(NSString *)cmd
{
    [SendCommandManager sendSettingTimeCmd:self.deviceVo withCmd:cmd];
    [NotificationCenter postNotificationName:DeviceModeChangeNotification object:nil];
}


-(void)onBack
{
    //开启情况下，如果没有选择模式或者定时，则提醒用户选择
    if (_currentTimeModel.status) {
        if ((!_currentTimeModel.oneSettingTimeModel.isOpen&&!_currentTimeModel.twoSettingTimeModel.isOpen&&!_currentTimeModel.threeSettingTimeModel.isOpen) ||_currentTimeModel.mode==None) {
            [[[UIAlertView alloc ]initWithTitle:@"" message:@"您还未进行模式/时间段选择" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}



@end
