//
//  SKTimerManager.h
//  integration
//
//  Created by zsk on 2017/4/27.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TimerType) {
    TimerType_create,
    TimerType_create_open,
};

typedef void(^TimerUpdateBlock)();

@interface SKTimerManager : NSObject

- (void)createTimerWithType:(TimerType)type updateInterval:(NSTimeInterval)interval repeatCount:(NSInteger)repeatCount update:(TimerUpdateBlock)block;

- (void)startTimer;

- (void)stopTimer;

@end
