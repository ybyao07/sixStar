//
//  AccountManageViewController.m
//  AirPurifier
//
//  Created by bluE on 14-8-15.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import "AccountManageViewController.h"
#import "NIcknameModifyViewController.h"
#import "PasswordModifyViewController.h"
#import "AirPurifierAppDelegate.h"
#import "UserLoginedInfo.h"
#import "AlertBox.h"
#import "LoginViewController.h"
#import "UIColor+Utility.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "UserInfoType.h"
#import "SkywareUserManagement.h"
#import "UIImage+Extension.h"

#define USERINFO_FACE @"userImage"
@interface AccountManageViewController ()

@end

@implementation AccountManageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"accountManage" ofType:@"plist"];
    self.listSettings = [NSMutableArray arrayWithContentsOfFile:path];
    [self initNavView];
    [self createViews];
    [self registerObserver];
    [self downLoadUserInfo];
}

-(void)initNavView
{
    [self addBarItemTitle:@"账号管理"];
    [self addBarBackButtonItemWithImageName:@"back_normal" selImageName:@"back_press" action:@selector(back:)];
}

-(void)createViews
{
    self.settingTableView.delegate =self;
    self.settingTableView.dataSource = self;
    self.settingTableView.backgroundColor = [UIColor clearColor];
    
    UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(imgUserClicked)];
    self.imgUser.userInteractionEnabled  = YES;
     self.imgUser.contentMode = UIViewContentModeScaleAspectFit;
    self.tapView.userInteractionEnabled = YES;
    [self.tapView addGestureRecognizer:tapGesture];
//    [self.imgUser addGestureRecognizer:tapGesture];
}
#pragma mark 获取用户信息
-(void)downLoadUserInfo
{
    [SkywareUserManagement UserGetUserWithParamesers:[NSArray new] Success:^(SkywareResult *result) {
        //
        if ([result.message intValue] == 200) {
            NSArray *arr = result.result;
            _model = [[ModelUser alloc] initWithDic:[arr objectAtIndex:0]];
            //显示头像
            [self.imgUser sd_setImageWithURL:[NSURL URLWithString:_model.user_img] placeholderImage:[UIImage imageNamed:@"view_userface"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                _txtUserName.text = _model.user_name;
                _txtPhoneNumber.text = _model.user_phone?_model.user_phone:@"未绑定手机";
                _txtMail.text = _model.user_email?_model.user_email:@"未绑定邮箱";
            });
        }
        [SVProgressHUD dismiss];
    } failure:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
    }];
}



#pragma mark - Observer Management
- (void)registerObserver
{
    [NotificationCenter addObserver:self
                           selector:@selector(userInfoUpdateStatus:)
                               name:UserNameModifiedNotification
                             object:nil];
    
    [NotificationCenter addObserver:self
                           selector:@selector(userInfoUpdateStatus:)
                               name:UserPhoneModifiedNotification
                             object:nil];
    
    [NotificationCenter addObserver:self
                           selector:@selector(userInfoUpdateStatus:)
                               name:UseMailNotification
                             object:nil];
}
- (void)removeObserver
{
    [NotificationCenter removeObserver:self name:UserNameModifiedNotification object:nil];
    [NotificationCenter removeObserver:self name:UserPhoneModifiedNotification object:nil];
    [NotificationCenter removeObserver:self name:UseMailNotification object:nil];
}

-(void)dealloc{
    [self removeObserver];
}
- (void)userInfoUpdateStatus:(NSNotification *)notification
{
    [self downLoadUserInfo];
}


#pragma  mark -TableView Delegate
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = self.listSettings[indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"EuphemiaUCAS" size:15];
    cell.accessoryType =    UITableViewCellAccessoryDisclosureIndicator;
    return  cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listSettings count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *selected = self.listSettings[indexPath.row];
    if ([selected isEqual:@"昵称修改"]) {
        NIcknameModifyViewController *nickNameController = [[NIcknameModifyViewController alloc] initWithNibName:@"NIcknameModifyViewController" bundle:nil];
        nickNameController.model = _model;
        [self.navigationController pushViewController:nickNameController animated:YES];
    }
    if ([selected isEqual:@"修改密码"]) {
//        if (MainDelegate.loginedInfo.userPhone.length ==0) {
//             [AlertBox showWithMessage:@"请先绑定手机"];
//              return;
//        }
        PasswordModifyViewController *passwordController = [[PasswordModifyViewController alloc] initWithNibName:@"PasswordModifyViewController" bundle:nil];
        [self.navigationController pushViewController:passwordController animated:YES];
    }
    if ([selected isEqual:@"注销"]) {
        [AlertBox showLogoutView:@"logout" delegate:self];
       }
}
#pragma mark 退出登陆
-(void)onLogoutSure
{
    MainDelegate.loginedInfo = nil;
    NSDictionary *dicLoginInfoCopy = [UserDefault objectForKey:LoginInfo];
    NSDictionary *dicLoginInfo = @{
                                   LoginUserName:[dicLoginInfoCopy objectForKey: LoginUserName],
                                   LoginPassWord:[dicLoginInfoCopy objectForKey: LoginPassWord],
                                   LoginType:[dicLoginInfoCopy objectForKey: LoginType],
                                   IsAutoLogin:[dicLoginInfoCopy objectForKey:IsAutoLogin],
                                   UserID:[dicLoginInfoCopy objectForKey: UserID]
                                   };
    [UserDefault setObject:dicLoginInfo forKey:LoginInfo];
    [UserDefault synchronize];
    
    LoginViewController *mainView = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    mainView.isLogout = YES;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mainView];
    navController.navigationBarHidden = YES;
    MainDelegate.window.rootViewController = navController;
    [MainDelegate reloadInputViews];

}

- (IBAction)back:(id)sender {
    [self removeObserver];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 更改头像
- (void)imgUserClicked {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"照相机", @"图库", nil];
    actionSheet.alpha=1;
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
}

#pragma mark --ActionSheet Delegate----
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag)
    {
        case 1:
            switch (buttonIndex)
        {
            case 0:
            {
#if TARGET_IPHONE_SIMULATOR
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Camera not available." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
#elif TARGET_OS_IPHONE
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;//照相机
                picker.delegate = self;
                picker.allowsEditing = YES;
                [self presentViewController:picker animated:YES completion:nil];
#endif
            }
                break;
            case 1:
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//相册
                picker.allowsEditing = YES;
                picker.delegate = self;
                 [self presentViewController:picker animated:YES completion:nil];
            }
                break;
        }
            break;
        default:
            break;
    }
}
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    self.imgUser.image = info[UIImagePickerControllerEditedImage];///??????????????
    //上传头像到服务器
    [SkywareUserManagement UserUploadIconWithParamesers:nil Icon:[info[UIImagePickerControllerEditedImage] scaleToSize:CGSizeMake(100, 100)] FileName:@"file.png" Success:^(SkywareResult *result) {
        if ([result.message intValue] == 200) {
            NSMutableDictionary *param= [NSMutableDictionary new];
            [param setObject:result.icon_url forKey:@"user_img"];
            [SkywareUserManagement UserEditUserWithParamesers:param Success:^(SkywareResult *result) {
                [SVProgressHUD dismiss];
                if ([result.message intValue] == 200) {
                    [NotificationCenter postNotificationName:UserImgModifiedNotification object:nil];
                }
            } failure:^(SkywareResult *result) {
                [SVProgressHUD dismiss];
            }];
        }else{
            [SVProgressHUD dismiss];
        }
    } failure:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
    }];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 保存图片
- (NSString *)saveImageWithImage:(UIImage *)image
{
    if (image) {
        //创建日期格式化对象
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *date1=[NSDate date];
        NSString *homePath = NSHomeDirectory();
        //set image path
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//        NSString *imagePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"sms.gif"]];   // 保存文件的名称
        NSString *imagePath = [homePath stringByAppendingPathComponent:@"tmp/headico.jpg"];
        //save image
        [UIImageJPEGRepresentation(image,1.0) writeToFile:imagePath atomically:YES];
        NSString *faceUrl = [[NSUserDefaults standardUserDefaults] objectForKey:USERINFO_FACE];
        if (faceUrl) {
            //移除之前的头像
                  [[SDImageCache sharedImageCache] removeImageForKey:faceUrl];
        }
        NSDate *date2 = [NSDate date];
        NSTimeInterval time=[date2 timeIntervalSinceDate:date1];
        NSLog(@"TimeInterval = %f",time);
        return imagePath;
    }else
    {
        return nil;
    }
}


@end
