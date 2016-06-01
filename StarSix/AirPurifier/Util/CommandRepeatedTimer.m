//
//  CommandRepeatedTimer.m
//  HangingFurnace
//
//  Created by ybyao07 on 16/3/31.
//  Copyright © 2016年 skyware. All rights reserved.
//

#import "CommandRepeatedTimer.h"

@implementation CommandRepeatedTimer
@synthesize isStarted;
LXSingletonM(CommandRepeatedTimer)

-(void)startTimer{
    if (repeatingTimer != nil) {
        [repeatingTimer invalidate];
        isStarted = NO;
    }
    isStarted = YES;
   repeatingTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self selector:@selector(targetMethod:)
                                                    userInfo:[self userInfo] repeats:YES];
}
-(void)stopTimer
{
    [repeatingTimer invalidate];
    repeatingTimer = nil;
    isStarted = NO;
    if (_succeedTimer) {
        _succeedTimer();
    }
}

- (NSDictionary *)userInfo {
    return @{ @"StartDate" : [NSDate date] };
}
- (void)targetMethod:(NSTimer*)theTimer {
    NSDate *startDate = [[theTimer userInfo] objectForKey:@"StartDate"];
    NSTimeInterval start=[startDate timeIntervalSince1970]*1;
    NSDate *nowDate = [NSDate date];
    NSTimeInterval end=[nowDate timeIntervalSince1970]*1;
    if (end - start > 6) {
        if (_afterTimer) {
            _afterTimer();
        }
        //提示发送失败
        SVProgressHUD.minimumDismissTimeInterval = 3;
        [SVProgressHUD showErrorWithStatus:@"别着急，网有点慢，再试试"];
        [self stopTimer];
    }
}

-(BOOL)isTimerValid{
    return isStarted;
}


@end
