//
//  AlidayuManager.h
//  ssss
//
//  Created by zsk on 16/5/3.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^smsState)(BOOL isSendSuccessful);

@interface AlidayuManager : NSObject

+(void)sendMessageToContact:(NSString *)Tel andAreaCode:(NSString*)areaCode message:(NSString*)message address:(NSMutableDictionary *)address isSendSuccessful:(smsState)isSendSuccessful;

+ (void)alidayMessageToContact:(NSString *)Tel address:(NSMutableDictionary *)address isSendSuccessful:(smsState)isSendSuccessful;

@end
