//
//  AlertBoxViewController.m
//  AirManager
//

#import "AlertBoxViewController.h"
#import "AirPurifierAppDelegate.h"

@interface AlertBoxViewController ()
{
    IBOutlet UIButton       *_okButtonLeft;
    IBOutlet UIButton       *_okButtonCenter;
    IBOutlet UIButton       *_cancelButton;
    IBOutlet UIImageView    *_splitImageView;
    IBOutlet UILabel        *_titleLabel;
}

@end

@implementation AlertBoxViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
//    DDLogFunction();
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _delegate = nil;
    }
    return self;
}

- (void)viewDidLoad
{
//    DDLogFunction();
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
//    DDLogFunction();
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getter / Setter Methods

- (void)setMessage:(NSString *)message
{
//    DDLogFunction();
    dispatch_async(dispatch_get_main_queue(), ^{
        _titleLabel.text = message;
    });
}

- (void)setHasCancelButton:(BOOL)hasCancelButton
{
//    DDLogFunction();
    dispatch_async(dispatch_get_main_queue(), ^{
        _okButtonCenter.hidden = hasCancelButton;
        _okButtonLeft.hidden = !hasCancelButton;
        _cancelButton.hidden = !hasCancelButton;
        _splitImageView.hidden = !hasCancelButton;
    });
}

#pragma mark - Button Events Methods

- (void)dismiss:(void(^)())completionHandler
{
//    DDLogFunction();
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            self.view.alpha = 0;
        }
        completion:^(BOOL finished){
            [self.view removeFromSuperview];
            MainDelegate.isShowingAlertBox = NO;
            if(completionHandler)
            {
                completionHandler();
            }
        }];
    });
}

- (IBAction)okButtonOnClicked:(id)sender
{
    DDLogFunction();
    [self dismiss:^
    {
        if (_delegate && [_delegate respondsToSelector:@selector(alertBoxOkButtonOnClicked)])
        {
            [_delegate alertBoxOkButtonOnClicked];
        }
    }];
}

- (IBAction)cancelButtonOnClicked:(id)sender
{
//    DDLogFunction();
    
    [self dismiss:^{}];
}

@end
