//
//  NotificationConfig.m
//  cjj
//
//  Created by 聂晶 on 15/11/25.
//  Copyright © 2015年 cjj. All rights reserved.
//

#import "NotificationConfig.h"



@implementation NotificationConfig



+(NotificationConfig *)buid:(UInt64)config {
    NotificationConfig *Config =  [[NotificationConfig alloc]init];
    Config.Power = ((config & Notification_MASK_POWER) == Notification_MASK_POWER);
    
    Config.Vib = ((config & Notification_MASK_VIB) == Notification_MASK_VIB);
    Config.Color = (NSInteger) ((config & Notification_MASK_COLOR) >> 59);
    Config.AppID = (NSInteger) ((config & Notification_MASK_APPID) >> 51);
    Config.CatID = (NSInteger) ((config & Notification_MASK_CATID) >> 43);
    Config.Interval = (NSInteger)((config & Notification_MASK_Interval) >> 37);
    Config.Count = (NSInteger)((config & Notification_MASK_COUNT) >> 21);
    Config.RemindCount = (short) (config & 0xFFFFLL);
    return Config;
}

-(UInt64) convert {
    UInt64 res = 0;
    if (self.Power)
        res |= 1LL << 63;
    if (self.Vib)
        res |= 1LL << 62;
    
    res |= ((self.Color & 0x07LL) << 59);
    
    res |= ((self.AppID & 0xFFLL) << 51);
    res |= ((self.CatID & 0xFFLL) << 43);
    res |= ((self.Interval & 0x3FLL) << 37);
    res |= ((self.Count & 0xFFFLL) << 21);
    res |= (self.RemindCount & 0xFFFFLL);
    
    printf("res:%llx   ",res);
    
    return res;
}






@end
