//
//  SMStepService.h
//  Blinq
//
//  Created by zsk on 2017/8/15.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>
#import <CoreMotion/CoreMotion.h>
#import <UIKit/UIDevice.h>

@interface SMStepService : NSObject

+(instancetype)shareService;

- (void)startPedometer:(void(^)(NSInteger value))event;

- (void)stopPedometer;

// 获取当天的步数 - CMPedometer
- (void)getCurrentSteps:(void(^)(NSInteger steps,NSInteger distance,NSDate *date))info error:(void(^)(NSError *error))errorInfo;

// 获取7天的步数 - CMPedometer
- (void)getSevenDaySteps:(void(^)(NSDate *date,NSInteger value, NSError *error))stepsInfo completion:(void(^)(void))completion;

// 检查权限及数据是否可用 - HKHealthStore
- (void)authorizeHealthKit:(void(^)(BOOL success, NSError *error))compltion;

// 获取所有步数 - HKHealthStore
- (void)getAllStepCount:(void(^)(NSDate *date,NSInteger value, NSError *error))stepsInfo completion:(void(^)(void))completion;

- (void)getStepCountFromHealth:(void(^)(double value,NSDate *date, NSError *error))completion;

@end
