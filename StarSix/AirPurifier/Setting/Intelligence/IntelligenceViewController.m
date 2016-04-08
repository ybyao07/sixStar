//
//  IntelligenceViewController.m
//  StarSix
//
//  Created by ybyao07 on 15/9/17.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "IntelligenceViewController.h"
#import "FanModeModel.h"
#import "PureLayout.h"
#import "RadioTableViewCell.h"
#import "SwitchHeaderView.h"
#import "UIColor+Category.h"
#import "CO2TableViewCell.h"
#import "PMSetTableViewCell.h"
#import "YBPmPickerView.h"
#import "AirPurifierViewController.h"
#import "AirPurifierAppDelegate.h"
#import "UtilConversion.h"
#import "SendCommandManager.h"
#import "IQKeyboardManager.h"
#import "PopHintView.h"
@interface IntelligenceViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSArray *arrModes;
}

@property (nonatomic,strong) FanModeModel *currentFanModel;
@property (nonatomic,strong) YBPmPickerView *pmPickerView;
@end

//PM2.5设置值的范围
static const NSInteger PmSettingValueMin=10;
static const NSInteger PmSettingValueMax = 1000;
//CO2设置值的范围
static const NSInteger CO2SettingValueMin = 800;
static const NSInteger CO2SettingValueMax = 1800;

@implementation IntelligenceViewController
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
    manager.shouldResignOnTouchOutside = NO;
    manager.shouldToolbarUsesTextFieldTintColor = NO;
    manager.enableAutoToolbar=NO;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enableAutoToolbar=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavView];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    arrModes = @[@"静音模式",@"CO2调节",@"PM2.5调节"];
    if (_deviceVo) {
        _currentFanModel = _deviceVo.deviceData.fanModel;
    }else
    {
        _currentFanModel = [[FanModeModel alloc] init];
    }
}

-(void)initNavView
{
    [self addBarItemTitle:@"智能模式"];
    [self addBarBackButtonItemWithImageName:@"back_normal" selImageName:@"back_pressed" action:@selector(onBack)];
}

#pragma mark UITableViewDelegate
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
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
        _currentFanModel.status = swithM.isOn; //开启，关闭模式
        //发送指令
        NSString *strCommand;
        //根据_currentFanModel来发送指令
        if (!_currentFanModel.status) {//关闭智能模式
            strCommand = @"2000";
        }else{
            strCommand = [NSString stringWithFormat:@"20%@",[UtilConversion decimalToHex:_currentFanModel.inteMode]] ;
        }
        [self sendModeCommand:strCommand];
        [self.tableView reloadData];
    };
    switchHeader.model = _currentFanModel;
    [bgView addSubview:switchHeader];
    return bgView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 3) {
     RadioTableViewCell * radioCell =   [self creatRadioCellInTableView:tableView forIndex:indexPath];
        return radioCell;
    }
//        else if (indexPath.row == 3){
//        static NSString *CO2Identifier = @"CO2Cell";
//        CO2TableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:CO2Identifier];
//        if (cell == nil) {
//            cell = [[[NSBundle mainBundle] loadNibNamed:@"CO2TableViewCell" owner:nil options:nil] lastObject];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        }
//        cell.lblTitle.text = @"CO2调节";
//        cell.editBlock = ^(long value){
//            NSLog(@"the CO2 value is %ld",value);
//            _currentFanModel.CO2 = value;
//            NSString *strCmd = [NSString stringWithFormat:@"61%@",[UtilConversion decimalToTwoByteHex:_currentFanModel.CO2]];
//            [self sendModeCommand:strCmd];
//        };
//        cell.txValue.text =[NSString stringWithFormat:@"%ld",_currentFanModel.CO2];
//        return cell;
//    }else{
//        static NSString *PMIdentifier = @"PMCell";
//        PMSetTableViewCell *PmCell  = [tableView dequeueReusableCellWithIdentifier:PMIdentifier];
//        if (PmCell == nil) {
//            PmCell = [[[NSBundle mainBundle] loadNibNamed:@"PMSetTableViewCell" owner:nil options:nil] lastObject];
//            PmCell.selectionStyle = UITableViewCellSelectionStyleNone;
//            PmCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        }
//        PmCell.lblTitle.text = @"PM2.5调节";
//        PmCell.editBlock = ^(long value){
//            NSLog(@"the pm value is %ld",value);
//            _currentFanModel.pm25 = value;
//            NSString *strCmd = [NSString stringWithFormat:@"63%@",[UtilConversion decimalToTwoByteHex:_currentFanModel.pm25]];
//            [self sendModeCommand:strCmd];
//        };
//        PmCell.txValue.text =[NSString stringWithFormat:@"%ld",_currentFanModel.pm25] ;
//        return PmCell;
//    }
    else{
        static NSString *CO2Identifier = @"CO2Cell";
        CO2TableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:CO2Identifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CO2TableViewCell" owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        __weak typeof(CO2TableViewCell) *weakCell = cell;
        if (indexPath.row == 3) {//CO2
            weakCell.lblTitle.text = @"CO2调节";
            weakCell.isCO2 = YES;
            weakCell.lblUnit.text = @"ppm";
            weakCell.editBlock = ^(long value){
                NSLog(@"the CO2 value is %ld",value);
                _currentFanModel.CO2 = value;
                NSString *strCmd = [NSString stringWithFormat:@"61%@",[UtilConversion decimalToTwoByteHex:_currentFanModel.CO2]];
                [self sendModeCommand:strCmd];
            };
            weakCell.txValue.text =[NSString stringWithFormat:@"%ld",_currentFanModel.CO2];
        }else{
            weakCell.lblTitle.text = @"PM2.5调节";
            weakCell.lblUnit.text = @"ug/m³";
            weakCell.editBlock = ^(long value){
                NSLog(@"the pm value is %ld",value);
                _currentFanModel.pm25 = value;
                NSString *strCmd = [NSString stringWithFormat:@"63%@",[UtilConversion decimalToTwoByteHex:_currentFanModel.pm25]];
                [self sendModeCommand:strCmd];
            };
            weakCell.txValue.text =[NSString stringWithFormat:@"%ld",_currentFanModel.pm25] ;
        }
        return cell;
    }
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
        if (_currentFanModel.inteMode == Silience) {
            [radioCell.radioBtn setSelected:YES];
        }else{
            [radioCell.radioBtn setSelected:NO];
        }
    }else if (indexPath.row == 1){
        if (_currentFanModel.inteMode == CO2Adjust) {
            [radioCell.radioBtn setSelected:YES];
        }else{
            [radioCell.radioBtn setSelected:NO];
        }
    }else{
        if (_currentFanModel.inteMode == PMAdjust) {
            [radioCell.radioBtn setSelected:YES];
        }else{
            [radioCell.radioBtn setSelected:NO];
        }
    }
    radioCell.radioBlock = ^{
        if (indexPath.row  == 0) {
            _currentFanModel.inteMode = Silience;
        }else if (indexPath.row == 1){
            _currentFanModel.inteMode = CO2Adjust;
        }else{
            _currentFanModel.inteMode = PMAdjust;
        }
        //发送指令
        NSString *strCommand = [NSString stringWithFormat:@"20%@",[UtilConversion decimalToHex:_currentFanModel.inteMode]] ;
        [self sendModeCommand:strCommand];
        [self.tableView reloadData];
    };
    //设置开启，关闭的背景色-----------
    if (_currentFanModel.status) {
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
    if (indexPath.row == 3) {//CO2调节设置
//        self.pmPickerView = [[YBPmPickerView alloc] initWithStyle:YBPmValue delegate:self];
//        [self.pmPickerView showInView:self.view];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CO2设置" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 1;
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        UITextField *value = [alert textFieldAtIndex:0];
        value.placeholder = @"请输入(800~1800)";
        value.keyboardType = UIKeyboardTypeNumberPad;
        [alert show];
    }else if (indexPath.row == 4){//pm调节
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pm2.5设置" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 2;
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        UITextField *value = [alert textFieldAtIndex:0];
        value.placeholder = @"请输入(10~1000)";
        value.keyboardType = UIKeyboardTypeNumberPad;
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) { //CO2调节
        if (buttonIndex != [alertView cancelButtonIndex]) {
         UITextField *textField = [alertView textFieldAtIndex:0];
            if ([textField.text integerValue] < CO2SettingValueMin || [textField.text integerValue] > CO2SettingValueMax) {
                [PopHintView showViewWithTitle:@"CO2调节范围为(800~1800)"];
                [alertView show];
                return;
            }else{
                //发送指令
                _currentFanModel.CO2 = [textField.text integerValue];
                NSString *strCmd = [NSString stringWithFormat:@"61%@",[UtilConversion decimalToTwoByteHex:_currentFanModel.CO2]];
                [self sendModeCommand:strCmd];
                //刷新界面
                CO2TableViewCell *CO2Cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
                CO2Cell.txValue.text =[NSString stringWithFormat:@"%ld",_currentFanModel.CO2];
            }
        }
    }else{
        if (buttonIndex != [alertView cancelButtonIndex]) {
            UITextField *textField = [alertView textFieldAtIndex:0];
            if ([textField.text integerValue] < PmSettingValueMin || [textField.text integerValue] > PmSettingValueMax) {
                [PopHintView showViewWithTitle:@"PM2.5调节范围为(10~1000)"];
                [alertView show];
                return;
            }else{
                //发送指令
                _currentFanModel.pm25 = [textField.text integerValue];
                NSString *strCmd = [NSString stringWithFormat:@"63%@",[UtilConversion decimalToTwoByteHex:_currentFanModel.pm25]];
                [self sendModeCommand:strCmd];
                
                //刷新界面
                CO2TableViewCell *pmCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
                pmCell.txValue.text =[NSString stringWithFormat:@"%ld",_currentFanModel.pm25];
            }
        }
    }
}
#pragma mark - pickerViewDelegate
-(void)pickerDidChangedStatus:(YBPmPickerView *)picker
{
//    CO2TableViewCell *pmCell = (CO2TableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    _currentFanModel.pm25 = [picker.pmValue intValue];
    NSString *cur = [NSString stringWithFormat:@"63%@",[UtilConversion decimalToTwoByteHex:_currentFanModel.pm25]];
    [self sendModeCommand:cur];
    [self.tableView reloadData];
}

-(void)onBack
{
    if (_currentFanModel.status) {
        if (_currentFanModel.inteMode==0) {
            [[[UIAlertView alloc ]initWithTitle:@"" message:@"您还未进行模式选择" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---发送指令
-(void)sendModeCommand:(NSString *)cmd
{
    [SendCommandManager sendIntelligenceCmd:self.deviceVo withCmd:cmd];
    [NotificationCenter postNotificationName:DeviceModeChangeNotification object:nil];
}





@end
