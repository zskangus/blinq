//
//  SKUserNotification.h
//  UserNotifications
//
//  Created by zsk on 2016/11/11.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKUserNotification : NSObject

// 判断是否是IOS 10
+ (BOOL)judgeSystemVersionIsIos10;

// ios 注册通知
+ (void)requestNotificationAndSetDelegate:(id)delegate;

// 发送通知
+ (void)addNotification:(NSString*)title body:(NSString*)body identifier:(NSString*)identifier;

// 删除通知
+ (void)removeNotification:(NSString*)identifier;

@end
