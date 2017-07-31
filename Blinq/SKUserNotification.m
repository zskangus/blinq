//
//  SKUserNotification.m
//  UserNotifications
//
//  Created by zsk on 2016/11/11.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "SKUserNotification.h"
#import <UIKit/UIKit.h>

#define IOS10_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)

@implementation SKUserNotification

+ (BOOL)judgeSystemVersionIsIos10{
    
    if (IOS10_OR_LATER) {
        return YES;
    }else{
        return NO;
    }
}

+ (void)requestNotificationAndSetDelegate:(id)delegate results:(void(^)(BOOL granted))results{

    // 使用 UNUserNotificationCenter 来管理通知
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    //监听回调事件
    center.delegate = delegate;
    
    //iOS 10 使用以下方法注册，才能得到授权
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              // Enable or disable features based on authorization.
                              
                              results(granted);
                              
                          }];
    
    //获取当前的通知设置，UNNotificationSettings 是只读对象，不能直接修改，只能通过以下方法获取
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        
    }];
    
}

+ (void)addNotification:(NSString *)title body:(NSString *)body identifier:(NSString *)identifier{
    
    // 创建通知内容
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString localizedUserNotificationStringForKey:title arguments:nil];
    content.body = [NSString localizedUserNotificationStringForKey:body arguments:nil];
    content.sound = [UNNotificationSound defaultSound];
    
    // 1秒后发出通知
    UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
                                                  triggerWithTimeInterval:1 repeats:NO];
    
    // 创建请求
    UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:identifier
                                                                          content:content trigger:trigger];
    
    // 安排通知
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:nil];
    
}

+ (void)removeNotification:(NSString *)identifier{
    
    // 删除通知
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    [center removeDeliveredNotificationsWithIdentifiers:@[identifier]];
    
}

@end
