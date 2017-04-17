//
//  SMMessageManager.h
//  Blinq
//
//  Created by zsk on 16/5/20.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NotificationInfo;

@interface SMMessageManager : NSObject

+ (void)obtainNotificationInfo;

+ (void)GetAllNotificationInfo;

+ (void)saveAppInfo:(NotificationInfo*)appInfo;

+ (void)requestAllData;

+ (void)saveSwitchInfo:(NotificationInfo*)switchInfo;

+ (void)smartRemindPower:(BOOL)setOn;

+ (void)antilostPower:(BOOL)setOn;

+ (void)emergencyPower:(BOOL)setOn;

+ (void)vibratePower:(BOOL)setOn;

+ (void)flashPower:(BOOL)setOn;

//更改信息存储方式
+ (void)setupNotificationInfo;

//重新配置数据
+ (void)againSetupNotificationInfo;

//确保开启电话及短信开关的方法
+ (void)openNotificationPower;

@end
