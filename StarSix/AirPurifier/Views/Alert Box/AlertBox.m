//
//  AlertBox.m
//  AirManager
//

#import "AlertBox.h"
#import "AirPurifierAppDelegate.h"
#import "AlertBoxViewController.h"
#import "RetryBoxViewController.h"
#import "SucceedBoxViewController.h"
#import "VersionCheckViewController.h"
#import "AboutViewController.h"
#import "BindLockViewController.h"
#import "LogoutViewController.h"
#import "UIColor+Utility.h"
#import "SettingPMViewController.h"

//static AlertBox     *_sharedInstance = nil;

@interface AlertBox()

@property (nonatomic, strong) AlertBoxViewController *alertBoxViewController;
@property (nonatomic, strong) SucceedBoxViewController *succeedBoxViewController;
@property (nonatomic, strong) RetryBoxViewController *retryBoxViewController;
@property (nonatomic, strong) VersionCheckViewController *versionCheckViewController;
@property (nonatomic,strong) AboutViewController *aboutViewController;
@property (nonatomic,strong) BindLockViewController *bindLockViewController;
@property (nonatomic,strong)LogoutViewController *logoutViewController;

@property(nonatomic,strong)SettingPMViewController *settingPMViewController;
@end

@implementation AlertBox

+ (void)showWithMessage:(NSString *)message
{
//    DDLogFunction();
    [AlertBox showWithMessage:message delegate:nil showCancel:NO];
}

+ (void)showWithMessage:(NSString *)message delegate:(id <AlertBoxDelegate>)delegate showCancel:(BOOL)show
{
//    DDLogFunction();
    dispatch_async(dispatch_get_main_queue(), ^{
        if( MainDelegate.isShowingAlertBox ) return;
        MainDelegate.isShowingAlertBox = YES;
        AlertBoxViewController *vc = [AlertBox sharedInstance].alertBoxViewController;
        vc.delegate = delegate;
        vc.view.alpha = 0;
        vc.view.frame = MainDelegate.window.frame;
        [MainDelegate.window addSubview:vc.view];
        [UIView animateWithDuration:0.3 animations:^{
            vc.view.alpha = 1.0;
        }];
        vc.message = message;
        vc.hasCancelButton = show;
    });
}

+ (void)showIsRetryBoxWithDelegate:(id <AlertBoxDelegate>)delegate
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(MainDelegate.isShowingAlertBox)return;
        MainDelegate.isShowingAlertBox = YES;
    
        RetryBoxViewController *vc = [AlertBox sharedInstance].retryBoxViewController;
        vc.delegate = delegate;
    
        vc.view.alpha = 0;
        vc.view.frame = MainDelegate.window.frame;
        [MainDelegate.window addSubview:vc.view];
        [UIView animateWithDuration:0.3 animations:^{
            vc.view.alpha = 1.0;
        }];
    });
}

+ (void)showIsSucceedWithMessage:(NSString *)message delegate:(id <AlertBoxDelegate>)delegate
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(MainDelegate.isShowingAlertBox)return;
        MainDelegate.isShowingAlertBox = YES;
        
        SucceedBoxViewController *vc = [AlertBox sharedInstance].succeedBoxViewController;
        vc.delegate = delegate;
        vc.view.alpha = 0;
        vc.view.frame = MainDelegate.window.frame;
        [MainDelegate.window addSubview:vc.view];
        [UIView animateWithDuration:0.3 animations:^{
            vc.view.alpha = 1.0;
        }];

        vc.message = message;
        vc.hasCancelButton = (delegate) ? YES : NO;
    });
}

+ (void)showIsUpdateWithMessage:(NSString *)message delegate:(id <AlertBoxDelegate>)delegate
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(MainDelegate.isShowingAlertBox)return;
        MainDelegate.isShowingAlertBox = YES;
        
        VersionCheckViewController *vc = [AlertBox sharedInstance].versionCheckViewController;
        vc.delegate = delegate;
        vc.view.alpha = 0;
        vc.view.frame = MainDelegate.window.frame;
        [MainDelegate.window addSubview:vc.view];
        [UIView animateWithDuration:0.3 animations:^{
            vc.view.alpha = 1.0;
        }];
        
        vc.message = message;
        vc.hasCancelButton = (delegate) ? YES : NO;
    });
}
+(void)showAboutMessage:(NSString *)message
               delegate:(id<AlertBoxDelegate>)delegate
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(MainDelegate.isShowingAlertBox)return;
        MainDelegate.isShowingAlertBox = YES;
        
        AboutViewController *vc = [AlertBox sharedInstance].aboutViewController;
        vc.delegate = delegate;
        vc.view.alpha = 0;
        vc.view.frame = MainDelegate.window.frame;
        [MainDelegate.window addSubview:vc.view];
        [UIView animateWithDuration:0.3 animations:^{
            vc.view.alpha = 1.0;
        }];
    });
}

+(void)showBindLockView:(NSString *)message delegate:(id<AlertBoxDelegate>)delegate
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(MainDelegate.isShowingAlertBox)return;
        MainDelegate.isShowingAlertBox = YES;
        
        BindLockViewController *vc = [AlertBox sharedInstance].bindLockViewController;
        vc.delegate = delegate;
        vc.view.alpha = 0;
        vc.view.frame = MainDelegate.window.frame;
        
        [MainDelegate.window addSubview:vc.view];
        [UIView animateWithDuration:0.3 animations:^{
            vc.view.alpha = 1.0;
        }];
          vc.txtBindOrLock.text = message;
    });
}

+(void)showLogoutView:(NSString *)message delegate:(id<AlertBoxDelegate>)delegate
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(MainDelegate.isShowingAlertBox)return;
        MainDelegate.isShowingAlertBox = YES;
        LogoutViewController *vc = [AlertBox sharedInstance].logoutViewController;
        vc.delegate = delegate;
        vc.view.alpha = 0;
        vc.view.frame = MainDelegate.window.frame;
        [MainDelegate.window addSubview:vc.view];
        [UIView animateWithDuration:0.3 animations:^{
            vc.view.alpha = 1.0;
        }];
    });
}

//显示PM25的设置值
+(void)showPmSetting:(NSString *)pmValue delegate:(id<AlertBoxDelegate>)delegate
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(MainDelegate.isShowingAlertBox)return;
        MainDelegate.isShowingAlertBox = YES;
        SettingPMViewController *vc = [AlertBox sharedInstance].settingPMViewController;
        vc.delegate = delegate;
        vc.curPmValue = [pmValue integerValue];
        vc.view.alpha = 0;
        vc.view.frame = MainDelegate.window.frame;
        [MainDelegate.window addSubview:vc.view];
        [UIView animateWithDuration:0.3 animations:^{
            vc.view.alpha = 1.0;
        }];
    });
}

+ (AlertBox *)sharedInstance
{
//    DDLogFunction();
//    if (!_sharedInstance)
//    {
//        _sharedInstance = [[AlertBox alloc] init];
//    }
//    
//    return _sharedInstance;
    static AlertBox *singleton = nil;
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        singleton = [[super allocWithZone:NULL] init];
    });
    return singleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}


- (id)init
{
//    DDLogFunction();
    //if (_sharedInstance) return _sharedInstance;
    self = [super init];
    if (self)
    {
        self.alertBoxViewController = [[AlertBoxViewController alloc] initWithNibName:@"AlertBoxViewController" bundle:nil];
        self.succeedBoxViewController = [[SucceedBoxViewController alloc] initWithNibName:@"SucceedBoxViewController" bundle:nil];
        self.retryBoxViewController = [[RetryBoxViewController alloc] initWithNibName:@"RetryBoxViewController" bundle:nil];
        self.versionCheckViewController = [[VersionCheckViewController alloc] initWithNibName:@"VersionCheckViewController" bundle:nil];
        self.aboutViewController=[[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
        self.bindLockViewController =[[BindLockViewController alloc]initWithNibName:@"BindLockViewController" bundle:nil];
        
        self.logoutViewController = [[LogoutViewController alloc]initWithNibName:@"LogoutViewController" bundle:nil];
        
        self.settingPMViewController = [[SettingPMViewController alloc] initWithNibName:@"SettingPMViewController" bundle:nil];
    }

    return self;
}

@end
