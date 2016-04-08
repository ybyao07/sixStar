//
//  AlertBox.h
//  AirManager
//

#import <Foundation/Foundation.h>

@protocol AlertBoxDelegate <NSObject>

@optional

/**
 *  normal alert "ok" button click delegate
 **/
- (void)alertBoxOkButtonOnClicked;

/**
 *  retry alert "retry" button click delegate
 **/
- (void)retryBoxOkButtonOnClicked;

/**
 *  retry alert "cancel" button click delegate
 **/
- (void)retryBoxCancelButtonOnClicked;

/**
 *  check succeed alert "succeed" button click delegate
 **/
- (void)succeedBoxOkButtonOnClicked;

/**
 *  check succeed alert "failed" button click delegate
 **/
- (void)succeedBoxCancelButtonOnClicked;

/**
 *  update version now
 **/
- (void)updateVersionButtonOnClicked;

/**
 *  not update version
 **/
- (void)notUpdateVersionButtonOnClicked;


/**
 *  showHelp
 **/
- (void) onHelpCloseButtonOnClicked;

/*关于
 */
-(void)onAboutCloseButtonOnClicked;

/**设备管理，编辑，解锁，解绑，取消
 **/
-(void)onDeviceManageCancelButtonOnClicked;
-(void)onDeviceManageUnbindingButtonOnClicked;
-(void)onDeviceManageUnlockButtonOnClicked;
-(void)onDeviceManageEditButtonOnClicked;

/**配置设备 熄灯，闪烁，常亮
 **/
-(void)onLightCloseButtonOnClicked;
-(void)onLightBlinkButtonOnClicked;
-(void)onLightOpenButtonOnClicked;

/**设置之前保证净化器指示灯闪烁
 **/
-(void)onConditionButtonOnClicked;

/**重试连接
 **/
-(void)onTryAgainButtonOnClicked;
/**
 * 解锁，解绑，锁定提示框
 **/

//改变PMAlert value
-(void)changePMAlertValue:(NSString *)PMAlertValue;

-(void)onBindLockUnlockOKButtonOnClicked:(NSString *)msgUnlockOrUnbinding;

//注销
-(void)onLogoutSure;

@end

@interface AlertBox : NSObject

// This method will show an alert box when it needs only a OK button, without a Cancel button
+ (void)showWithMessage:(NSString *)message;

// This method will show an alert box when it needs a OK button and a Cancel button
// Set delegate to nil if it does not need any callback action in OK button calling
+ (void)showWithMessage:(NSString *)message delegate:(id <AlertBoxDelegate>)delegate showCancel:(BOOL)show;

+ (void)showIsRetryBoxWithDelegate:(id <AlertBoxDelegate>)delegate;

+ (void)showIsSucceedWithMessage:(NSString *)message delegate:(id <AlertBoxDelegate>)delegate;

+ (void)showIsUpdateWithMessage:(NSString *)message delegate:(id <AlertBoxDelegate>)delegate;

+ (void)showHelpInfomationMessage:(NSString *)message delegate:(id <AlertBoxDelegate>)delegate;

+(void)showAboutMessage:(NSString *)message
                            delegate:(id<AlertBoxDelegate>)delegate;

+(void)showBindLockView:(NSString *)message delegate:(id<AlertBoxDelegate>)delegate;

//zhu xiao
+(void)showLogoutView:(NSString *)message delegate:(id<AlertBoxDelegate>)delegate;

//显示PM25的设置值
+(void)showPmSetting:(NSString *)pmValue delegate:(id<AlertBoxDelegate>)delegate;

@end
