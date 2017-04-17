//
//  NotificationConfig.h
//  cjj
//
//  Created by 聂晶 on 15/11/25.
//  Copyright © 2015年 cjj. All rights reserved.
//

#import "ModuleClass.h"


#define Notification_MASK_POWER (1LL << 63)
#define Notification_MASK_VIB (1LL << 62)
#define Notification_MASK_COLOR (0x07LL << 59)
#define Notification_MASK_APPID (0xFFLL << 51)
#define Notification_MASK_CATID (0xFFLL << 43)
#define Notification_MASK_Interval (0x3FLL<< 37)
#define Notification_MASK_COUNT (0xFFFLL << 21)
#define Notification_MASK_REMINDCOUNT  (0xFFFFLL)





#define CAT_ID_OTHER 0
//  Incoming Call
#define CAT_ID_CALL  1
//  Missed Call
#define  CAT_ID_MISSED_CALL  2
//  Voice Mail
#define  CAT_ID_VOICE_MAIL  3
//  Social network
#define  CAT_ID_SOCIAL  4
//  Schedule
#define  CAT_ID_SCHEDULE  5
//  Email
#define  CAT_ID_EMAIL 6
//  News Feed
#define  CAT_ID_NEWS  7
//  Health and Fitness
#define  CAT_ID_HEALTH_FITNESS  8
//  Business and Finance
#define  CAT_ID_BUSINESS_FINANCE  9
//  Location
#define  CAT_ID_LOCATION 10
//  Entertainment
#define  CAT_ID_ENTERTAINMENT 11
//
#define  CAT_ID_NB  12
//// / All supported categories
#define  CAT_ID_ALL_SUPPORTED_CAT  0xFF

// / Other
#define  APP_ID_OTHER      0
// / com.apple.MobileSMS
#define  APP_ID_SMS        1
// / com.tencent.xin
#define  APP_ID_WECHAT     2
// / com.tencent.mqq
#define  APP_ID_QQ         3

#define  APP_ID_LINKEDIN   4

#define  APP_ID_FACEBOOK   5

#define  APP_ID_TWITTER    6

#define  APP_ID_SKYPE      7

#define  APP_ID_WHATSAPP   8

#define  APP_ID_MESSENGER  9


@interface NotificationConfig : ModuleClass

@property BOOL Power;
@property BOOL Vib;
@property NSInteger Color;
@property NSInteger AppID;
@property NSInteger CatID;

@property NSInteger Interval;
@property NSInteger Count;
@property NSInteger RemindCount;

+(NotificationConfig *)buid:(UInt64)config;

-(UInt64) convert;

@end
