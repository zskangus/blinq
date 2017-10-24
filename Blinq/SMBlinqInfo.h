//
//  SMBlinqInfo.h
//  Blinq
//
//  Created by zsk on 2017/8/2.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMPersonalModel.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface SMBlinqInfo : NSObject

+ (void)setTargetSteps:(double)steps;
+ (double)targetSteps;


+ (void)setUserInfo:(SMPersonalModel*)info;
+ (SMPersonalModel*)userInfo;


+ (void)setStepCounterPower:(BOOL)power;
+ (BOOL)stepCounterPower;

+ (void)setAppleHealthPower:(BOOL)power;
+ (BOOL)appleHealthPower;

+ (void)setIsFirstTimeEnter:(BOOL)power;
+ (BOOL)isFirstTimeEnter;

+ (BOOL)isFirstTimeInStepPage;
+ (void)setIsFirstTimeInStepPage:(BOOL)power;

+ (void)setisHaveHealthAuthorized:(BOOL)power;
+ (BOOL)isHaveHealthAuthorized;

+ (void)setIsloadedAllData:(BOOL)power;
+ (BOOL)isloadedAllData;

+ (void)setStepDataLastLoadTime:(NSString*)time;
+ (NSString*)stepDataLastLoadTime;

+ (void)setCBManagerState:(CBManagerState)state;
+ (CBManagerState)CBManagerState;

+ (void)setTimeOfTheLastHintNewAppVersionWithDate:(NSString*)string;

+ (NSString*)timeOfTheLastHintAppNewVersion;

+ (void)setRingFirmwareUpdateFileUrl:(NSString*)fileUrl;
+ (NSURL *)ringFirmwareUpdateFileUrl;
@end
