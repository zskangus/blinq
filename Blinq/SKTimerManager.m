//
//  SKTimerManager.m
//  integration
//
//  Created by zsk on 2017/4/27.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import "SKTimerManager.h"
#import <UIKit/UIKit.h>

@interface SKTimerManager()

@property (nonatomic,assign) NSInteger repeatCountLimit;
@property (nonatomic,assign) NSInteger timerRepeatCount;
@property (nonatomic,assign) NSTimeInterval timeInterval;
@property (nonatomic,assign) NSTimeInterval timeSumInterval;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,copy)TimerUpdateBlock updateBlock;


@end

@implementation SKTimerManager

- (void)createTimerWithType:(TimerType)type updateInterval:(NSTimeInterval)interval repeatCount:(NSInteger)repeatCount update:(TimerUpdateBlock)block{
    
    self.repeatCountLimit = repeatCount;
    self.timeInterval = interval;
    self.updateBlock = block;
    
    if (type == TimerType_create_open) {
        [self startTimer];
    }
}

- (void)startTimer{
    
    //把计数归零
    self.timerRepeatCount = 0;
    
    //开启之前先关闭定时器
    [self stopTimer];

    //创建timer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(actionFunc) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    NSLog(@"开启定时器");
}

- (void)stopTimer{
    [self.timer setFireDate:[NSDate distantFuture]];
    self.timer = nil;
    //[self endBackgroundTask];
}

- (void)actionFunc{
    
    if (self.timerRepeatCount == self.repeatCountLimit) {
        [self stopTimer];
        return;
    }
    
    self.updateBlock();
    self.timerRepeatCount++;
    
    NSTimeInterval backgroundTimeRemaining =[[UIApplication sharedApplication] backgroundTimeRemaining];
    
    NSLog(@"backgroundTaskIdentifier  剩余时间:%f",backgroundTimeRemaining);
}


- (void)dealloc{
    [self stopTimer];
}

@end
