//
//  DeviceView.m
//  AirPurifier
//
//  Created by bluE on 14-8-21.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import "DeviceView.h"
#import "UIColor+Utility.h"
#import "PlistManager.h"
#import "AlertBox.h"
#import "PMCollectionViewCell.h"
#import "TempCollectionViewCell.h"
#import "LabelCollectionViewCell.h"
#import "PureLayout.h"
#import "AirPurifierViewController.h"
#import "AppDelegate.h"
#import "SendCommandManager.h"
#import "ModelNotice.h"
#import "Util.h"

@class DeviceVo;
@interface DeviceView()<UICollectionViewDataSource, UICollectionViewDelegate>
{
    long _currentFanFrequency; //风机当前频率
    long _deviceFanFrequency;//返回的当前风机频率
    NSTimer *timer;     //定时风机频率
    NSTimer *tempTimer; //临时Timer
    BOOL isOpen;//设备是否开启
    
    BOOL isLast;
    BOOL isCurrent;
}

@property (weak, nonatomic) IBOutlet UILabel *frequenceValue;  //风机频率
@property (weak, nonatomic) IBOutlet UILabel *rotateSpeed;    //风机转速
@property (weak, nonatomic) IBOutlet UILabel *CO2Value;       //当前CO2浓度


//自适应iphone4,iphone5,iphone6
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTopHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *CO2ViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *windSpeedBottomStraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *frequencyViewHeightConstraint;
//iphone4
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hzBottomAlignmentConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mhBottomAlignmentConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *frequencyTopConstraint;


@property (weak, nonatomic) IBOutlet UILabel *unitHz;


@property (strong, nonatomic) UIAlertView *pmAlertView;//pm提示框
//@property (strong, nonatomic) UIAlertView *filterAlertView;//滤网提示框
//@property (strong,nonatomic) UIAlertView  *wifiAlertView;


//@property (nonatomic,weak) IBOutlet UICollectionView *myCollectionView;
@property (nonatomic,strong)  UICollectionView *myCollectionView;


@end
@implementation DeviceView
static const float kMargin = 3.0;     //外边沿间隙
static const float kLineSpacing = 1.5;//UICollectionViewCell之间的间距

static const NSInteger  fanFreaquencyMin = 10; //风机最低频率
static const NSInteger  fanFrequencyMax = 50;  //风机最高频率

+(DeviceView *)instanceDeviceView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"DeviceView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    _currentFanFrequency = 30;
    CGFloat viewHeight = kWindowHeight - 54 - 64;
    if (IS_IPHONE_4_OR_LESS) {
        _viewTopHeight.constant = viewHeight*280/544;
    }else{
        _viewTopHeight.constant = viewHeight*46/100;
    }
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowlayout.sectionInset = UIEdgeInsetsMake(kMargin, kMargin, kMargin, kMargin);
    flowlayout.minimumLineSpacing = kLineSpacing;
    flowlayout.minimumInteritemSpacing = 0;

    self.myCollectionView =
    [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, _viewTopHeight.constant) collectionViewLayout:flowlayout];
    self.myCollectionView.backgroundColor= [UIColor whiteColor];
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    
    self.myCollectionView.showsHorizontalScrollIndicator = NO;
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"PMCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PMCollectionViewCell"];
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"TempCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TempCollectionViewCell"];
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"LabelCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LabelCollectionViewCell"];
    [_viewTop addSubview:_myCollectionView];
}

-(void)layoutSubviews
{
    if (IS_IPHONE_6 || IS_IPHONE_6P) {
        self.frame = CGRectMake(4, 0, kWindowWidth, kWindowHeight-70-64);
    }else{
        self.frame = CGRectMake(4, 0, kWindowWidth, kWindowHeight-54-64);
    }
    CGFloat viewHeight = kWindowHeight - 54 - 64;
    if (IS_IPHONE_4_OR_LESS) {
        _frequenceValue.font = [UIFont systemFontOfSize:42];
        _rotateSpeed.font = [UIFont systemFontOfSize:44];
        _viewTopHeight.constant = viewHeight*280/544;
        _CO2ViewHeight.constant = viewHeight*60/544;
        //转速的位置
        _frequencyTopConstraint.constant = 15;
        _windSpeedBottomStraint.constant = (viewHeight*164/544)*50/450 ;
        _frequencyViewHeightConstraint.constant = (viewHeight*164/544)*180/450;
        _hzBottomAlignmentConstraint.constant = 0;
        _mhBottomAlignmentConstraint.constant = 0;
    }else{
        _viewTopHeight.constant = viewHeight*46/100;
        _CO2ViewHeight.constant = viewHeight*11/100;
        //转速的位置
        _windSpeedBottomStraint.constant = (viewHeight*43/100)*65/450 ;
        _frequencyViewHeightConstraint.constant = (viewHeight*43/100)*150/450;
    }
    [_myCollectionView reloadData];
    [super layoutSubviews];
}


-(void)setDeviceModel:(DeviceVo *)deviceModel
{
    _deviceModel = deviceModel;
    [self.myCollectionView reloadData];
    [self refreshView];
}
#pragma mark - UICollectionViewDataSource methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kWindowWidth-2*kMargin-2*kLineSpacing)/3.0, (_viewTop.bounds.size.height-2*kMargin-kLineSpacing)/2.0);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *pmIdentifier = @"PMCollectionViewCell";
    static NSString *tempIdentifier = @"TempCollectionViewCell";
    static NSString *lblIdentifier = @"LabelCollectionViewCell";
    PMCollectionViewCell *pmCell = [collectionView dequeueReusableCellWithReuseIdentifier:pmIdentifier forIndexPath:indexPath];
    TempCollectionViewCell *tempCell = [collectionView dequeueReusableCellWithReuseIdentifier:tempIdentifier forIndexPath:indexPath];
    LabelCollectionViewCell *lblCell = [collectionView dequeueReusableCellWithReuseIdentifier:lblIdentifier forIndexPath:indexPath];
    if (indexPath.row == 0) {
        [lblCell updateViewIsPm:YES];
        return lblCell;
    }else if (indexPath.row == 1){
        [lblCell updateViewIsPm:NO];
        return lblCell;
    }else if (indexPath.row == 2) {
        [pmCell updateView:_deviceModel isInside:YES];
        return pmCell;
    }else if (indexPath.row == 4){
        [pmCell updateView:_deviceModel isInside:NO];
        return pmCell;
    }else if (indexPath.row == 3){
        [tempCell updateView:_deviceModel isInside:YES];
        return tempCell;
    }else if (indexPath.row == 5){
//        tempCell.backgroundColor = myColor(250, 193, 26);
        [tempCell updateView:_deviceModel isInside:NO];
        return tempCell;
    }else{
        return tempCell;
    }
}

#pragma mark----控制频率，风量---- 增加或者减少，以5为间隔
- (IBAction)decreaseClicked:(UIButton *)sender {
        _currentFanFrequency = _currentFanFrequency - 5;
        if (_currentFanFrequency <= fanFreaquencyMin) {
            _currentFanFrequency = fanFreaquencyMin;
        }
        [self sendFanCommand];
}
- (IBAction)increaseClicked:(UIButton *)sender {
        _currentFanFrequency = _currentFanFrequency + 5;
        if (_currentFanFrequency >= fanFrequencyMax) {
            _currentFanFrequency = fanFrequencyMax;
        }
        [self sendFanCommand];
}

#pragma mark ---发送指令
-(void)sendFanCommand
{
    //记录指令时间(间隔8s查询一次）
    if (timer!=nil) {
        [timer invalidate];
    }
    if (![(AppDelegate *)[UIApplication sharedApplication].delegate beforeSendBaseonWifiLock:_deviceModel]) {
        return;
    }
    _frequenceValue.text = [NSString stringWithFormat:@"%@",@(_currentFanFrequency)];
    [self startTimer];
    //如果timer存在，先停止timer，再启动新的timer
    [tempTimer invalidate];
    tempTimer =nil;
    tempTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sendCmdAfterTwoSeconds) userInfo:nil repeats:NO];
}

//2秒之后发送
-(void)sendCmdAfterTwoSeconds
{
    DeviceVo *temp = [_deviceModel copy];
    temp.deviceData.fanFrequency = _currentFanFrequency;
    [SendCommandManager sendFanFrequency:temp];
}

-(void)refreshView
{
    if ([_deviceModel.deviceOnline intValue] == DeviceOnlineOn) {
        if ([_deviceModel.deviceData.btnPower boolValue]) {
            _unitHz.hidden = NO;
            _rotateSpeed.text = [NSString stringWithFormat:@"%ld",_deviceModel.deviceData.fanRotateSpeed];
        }else{
            _unitHz.hidden = YES;
            _rotateSpeed.text = @"已关机";
        }
        _deviceFanFrequency = _deviceModel.deviceData.fanFrequency;
        if (timer==nil && !timer.isValid) { //定时器无效时才刷新界面
            _currentFanFrequency = _deviceModel.deviceData.fanFrequency;
            _frequenceValue.text = [NSString stringWithFormat:@"%ld",_deviceModel.deviceData.fanFrequency];//设置
        }
        _CO2Value.text =[NSString stringWithFormat:@"%ldppm",_deviceModel.deviceData.CO2Density] ;
        //开启空气质量报警
            if (_deviceModel.deviceData.deviceInsidePm > 75) {
                isCurrent = YES;
                if (!isLast && isCurrent) {
                    isLast = YES;
                    if (self.pmAlertView==nil) {
                        self.pmAlertView = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"\"%@\"空气质量差，请注意空气循环",_deviceModel.deviceName] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [self.pmAlertView show];
                    }
                }
            }else{
                isLast = NO;
                isCurrent = NO;
            }
    }else{//设备已离线
        _unitHz.hidden = YES;
        _rotateSpeed.text = @"已离线";
        _currentFanFrequency = _deviceModel.deviceData.fanFrequency;
        _frequenceValue.text = [NSString stringWithFormat:@"%ld",_deviceModel.deviceData.fanFrequency];//设置
        _CO2Value.text =[NSString stringWithFormat:@"%ldppm",_deviceModel.deviceData.CO2Density] ;
    }
}

//定时开启更新频率
-(void)updateFrequency
{
    //定时更新，发送5s之后再更新（如果失败，提示失败）
    if (_deviceFanFrequency !=[_frequenceValue.text integerValue]) {
        [[[UIAlertView alloc ]initWithTitle:@"" message:@"网络异常，调节失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }
    _frequenceValue.text = [NSString stringWithFormat:@"%ld",_deviceModel.deviceData.fanFrequency];//设置
    _currentFanFrequency = _deviceModel.deviceData.fanFrequency;
    [timer invalidate];
    timer = nil;
}

-(void)startTimer
{
    timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:5] interval:1 target:self selector:@selector(updateFrequency) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
