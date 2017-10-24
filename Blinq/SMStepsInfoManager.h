//
//  SMStepsInfoManager.h
//  Blinq
//
//  Created by zsk on 2017/8/15.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMStepDB.h"

@interface SMStepsInfoManager : NSObject

- (void)startPedometer:(void(^)(SMStepModel *step))event;

- (void)stopPedometer;

- (void)getPedometerPowerState:(void(^)(BOOL state))state;

- (void)getCurrentSteps:(void(^)(SMStepModel *step))completion error:(void(^)(NSError *error))errorInfo;

- (void)getSevenSteps:(void(^)(void))completion error:(void(^)(NSError *error))errorInfo;

- (void)authorizeHealthKit:(void(^)(BOOL success, NSError *error))compltion;

- (void)getAllStepDataStart:(void(^)(void))start completion:(void(^)(void))completion error:(void(^)(NSError *error))errorInfo;

- (void)getHealthPowerState:(void(^)(BOOL power))state;
@end
