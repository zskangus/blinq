//
//  SMBlinqInfo.m
//  Blinq
//
//  Created by zsk on 2017/8/2.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import "SMBlinqInfo.h"

static NSUserDefaults *_userDefaults;

@implementation SMBlinqInfo

+ (void)initialize{
    _userDefaults = [NSUserDefaults standardUserDefaults];
}

+ (void)setTargetSteps:(double)steps{
    [_userDefaults setDouble:steps forKey:@"targetSteps"];
}

+ (double)targetSteps{
    return [_userDefaults integerForKey:@"targetSteps"];
}

+ (void)setUserInfo:(SMPersonalModel*)info{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:info];
    [_userDefaults setObject:data forKey:@"userInfo"];
}

+ (SMPersonalModel*)userInfo{
    NSData *data = [_userDefaults objectForKey:@"userInfo"];
    
    return  [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

+ (void)setStepCounterPower:(BOOL)power{
    [_userDefaults setBool:power forKey:@"stepCounterPower"];
}
+ (BOOL)stepCounterPower{
   return [_userDefaults boolForKey:@"stepCounterPower"];
}

+ (void)setAppleHealthPower:(BOOL)power{
    [_userDefaults setBool:power forKey:@"appleHealthPower"];
}
+ (BOOL)appleHealthPower{
    return [_userDefaults boolForKey:@"appleHealthPower"];
}

+ (void)setisHaveHealthAuthorized:(BOOL)power{
    [_userDefaults setBool:power forKey:@"isHaveHealthAuthorized"];
}

+ (BOOL)isHaveHealthAuthorized{
    return [_userDefaults boolForKey:@"isHaveHealthAuthorized"];
}

+ (void)setIsFirstTimeEnter:(BOOL)power{
    [_userDefaults setBool:power forKey:@"isFirstTimeEnter"];
}
+ (BOOL)isFirstTimeEnter{
    return [_userDefaults boolForKey:@"isFirstTimeEnter"];
}

+ (BOOL)isFirstTimeInStepPage{
    return [_userDefaults boolForKey:@"isFirstTimeInStepPage"];
}

+ (void)setIsFirstTimeInStepPage:(BOOL)power{
    [_userDefaults setBool:power forKey:@"isFirstTimeInStepPage"];
}

+ (void)setIsloadedAllData:(BOOL)power{
    [_userDefaults setBool:power forKey:@"setIsloadedAllData"];
}

+ (BOOL)isloadedAllData{
    return [_userDefaults boolForKey:@"setIsloadedAllData"];
}

+ (void)setStepDataLastLoadTime:(NSString*)time{
    [_userDefaults setObject:time forKey:@"stepDataLastLoadTime"];
}

+ (NSString*)stepDataLastLoadTime{
    return [_userDefaults objectForKey:@"stepDataLastLoadTime"];
}

+ (void)setCBManagerState:(CBManagerState)state{
    [_userDefaults setInteger:state forKey:@"CBManagerState"];
}

+ (CBManagerState)CBManagerState{
    return [_userDefaults integerForKey:@"CBManagerState"];
}

+ (void)setTimeOfTheLastHintNewAppVersionWithDate:(NSString*)string{
    [_userDefaults setObject:string forKey:@"timeOfTheLastHintAppNewVersion"];
    [_userDefaults synchronize];
}

+ (NSString*)timeOfTheLastHintAppNewVersion{
    return [_userDefaults objectForKey:@"timeOfTheLastHintAppNewVersion"];
}

+ (void)setRingFirmwareUpdateFileUrl:(NSString*)fileUrl{
    [_userDefaults setObject:fileUrl forKey:@"otaUpdateFile"];
    [_userDefaults synchronize];
}

+ (NSURL *)ringFirmwareUpdateFileUrl{
    
    NSURL *url = [NSURL URLWithString:[_userDefaults objectForKey:@"otaUpdateFile"]];
    
    //NSURL *url = [NSURL URLWithString:@"asdasd"];
    return url;
}

@end
