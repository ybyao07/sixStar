//
//  CommandRepeatedTimer.h
//  HangingFurnace
//
//  Created by ybyao07 on 16/3/31.
//  Copyright © 2016年 skyware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LXSingleton.h>

static  NSTimer * _Nonnull repeatingTimer;
//static  BOOL isStarted;

typedef void(^AfterTimer)();
typedef void(^SucceedTimer)();
@interface CommandRepeatedTimer : NSObject

LXSingletonH(CommandRepeatedTimer)

@property (nonatomic,strong)  AfterTimer _Nullable afterTimer;
@property (nonatomic,strong)  SucceedTimer _Nullable succeedTimer;

/**
 *  防止别人发指令后，我的设备收到指令后弹出提示框
 */
@property (nonatomic,assign)  BOOL isStarted;

-(void)startTimer;

-(void)stopTimer;

-(BOOL)isTimerValid;
//@property(nonatomic,weak) id<CommandRepeatedDelegate> delegate;

@end
