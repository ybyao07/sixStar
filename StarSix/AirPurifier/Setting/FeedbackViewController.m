//
//  FeedbackViewController.m
//  Caiaier
//
//  Created by ybyao07 on 15/11/16.
//  Copyright © 2015年 skyware. All rights reserved.
//

#import "FeedbackViewController.h"
#import "GCPlaceholderTextView.h"
#import "PopHintView.h"
#import "IQKeyboardManager.h"
#import "SkywareUserManagement.h"
@interface FeedbackViewController ()<UITextViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tfTitle;
@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *txtContent;

@end

@implementation FeedbackViewController

//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
//    manager.enable = NO;
//    manager.shouldResignOnTouchOutside = NO;
//    manager.shouldToolbarUsesTextFieldTintColor = NO;
//    manager.enableAutoToolbar=NO;
//}
//-(void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
//    manager.enableAutoToolbar=YES;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initNav];
    [self setUpView];
}

-(void)initNav
{
    [self addBarItemTitle:@"意见反馈"];
    [self addBarBackButtonItemWithImageName:@"back_normal" selImageName:@"back_press" action:@selector(back:)];
}
-(void)setUpView
{
    self.view.backgroundColor = [UIColor clearColor];
    
    _tfTitle.layer.cornerRadius=1.0f;
    _tfTitle.layer.masksToBounds=YES;
    _tfTitle.layer.borderColor= [UIColor colorWithHexString:@"7b7b7b"].CGColor;
    _tfTitle.layer.borderWidth= 1.0f;
    _tfTitle.delegate = self;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 44)];
    _tfTitle.leftView = paddingView;
    _tfTitle.leftViewMode = UITextFieldViewModeAlways;
    
    
    _txtContent.layer.cornerRadius=1.0f;
    _txtContent.layer.masksToBounds=YES;
    _txtContent.layer.borderColor= [UIColor colorWithHexString:@"7b7b7b"].CGColor;
    _txtContent.layer.borderWidth= 1.0f;
    _txtContent.delegate = self;
    _txtContent.placeholder = FeedHint;
}
-(IBAction)back:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 反馈按钮点击

-(IBAction)submit:(id)sender
{
    if (isEmptyString(self.tfTitle.text)) {
        [PopHintView showViewWithTitle:@"标题不能为空"];
        return;
    }
    if (isEmptyString(self.txtContent.text)) {
        [PopHintView showViewWithTitle:@"输入内容不能为空"];
        return;
    }
    SkywareUserFeedBackModel *model =[[SkywareUserFeedBackModel alloc ]init];
    model.title= self.tfTitle.text;
    model.content = self.txtContent.text;
    model.app_id = [NSString stringWithFormat:@"%ld",[SkywareInstanceModel sharedSkywareInstanceModel].app_id];
    model.app_version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    model.category = 1;
    [SkywareUserManagement UserFeedBackWithParamesers:model Success:^(SkywareResult *result) {
        if ([result.message intValue] == 200) {
            [[[UIAlertView alloc ]initWithTitle:@"提交反馈成功" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
            [self back:nil];
        }
    } failure:^(SkywareResult *result) {
        [self back:nil];
        NSLog(@"提交反馈失败");
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}







@end
