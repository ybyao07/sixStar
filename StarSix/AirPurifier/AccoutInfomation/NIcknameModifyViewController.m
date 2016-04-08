//
//  NIcknameModifyViewController.m
//  AirPurifier
//
//  Created by bluE on 14-8-15.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import "NIcknameModifyViewController.h"
#import "AirPurifierAppDelegate.h"
#import "AlertBox.h"
#import "UserLoginedInfo.h"
#import "UserInfoType.h"
#import "PopHintView.h"
#import "SkywareUserManagement.h"
#import "Util.h"
#import "IQKeyboardManager.h"
#define  kMaxLength  10
@interface NIcknameModifyViewController ()<UITextFieldDelegate>
{
        BOOL _wasKeyboardManagerEnabled;
}

@property (weak, nonatomic) IBOutlet UIButton *roundBtnSure;

@end

@implementation NIcknameModifyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _roundBtnSure.layer.cornerRadius = 4;
//    [self.headNavigationBar setBackgroundImage:[UIImage imageNamed:@"view_settingheader.png"] forBarMetrics:UIBarMetricsDefault];
    [self initNavView];
    
    _txtUserName.text = _model.user_name;
    
    [NotificationCenter addObserver:self selector:@selector(textFieldEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:_txtUserName];
}
-(void)initNavView
{
    [self addBarItemTitle:@"昵称修改"];
    [self addBarBackButtonItemWithImageName:@"back_normal" selImageName:@"back_press" action:@selector(back:)];
}

- (IBAction)onModifyNickname:(id)sender {
    [_txtUserName resignFirstResponder];
    if (isEmptyString(_txtUserName.text)) {
        [_txtUserName resignFirstResponder];
        [PopHintView showViewWithTitle:@"输入不能为空"];
        return;
    }
    NSMutableDictionary *param= [NSMutableDictionary new];
    [param setObject:_txtUserName.text forKey:@"user_name"];
    [SkywareUserManagement UserEditUserWithParamesers:param Success:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
        if ([result.message intValue] == 200) {
            [NotificationCenter postNotificationName:UserNameModifiedNotification object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
    }];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldEditChanged:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;
//    [textField setText:[Util disable_emoji:[textField text]]];

    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];//键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) {//简体中文输入
        UITextRange *selectedRange = [textField  markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
                NSLog(@"text:%@",textField.text);
            }
        }
        //有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    //中文输入法以外的直接对其统计限制即可
    else{
        if (toBeString.length >kMaxLength) {
            textField.text = [toBeString substringToIndex:kMaxLength];
        }
    }
   
}

-(void)dealloc{
    [NotificationCenter removeObserver:self];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
