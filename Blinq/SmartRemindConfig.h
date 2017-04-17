//
//  SmartRemindConfig.h
//  cjj
//
//  Created by 聂晶 on 15/11/25.
//  Copyright © 2015年 cjj. All rights reserved.
//

#import "ModuleClass.h"
#define B64 ((UInt64)1)
#define SmartRemind_MASK_POWER  (B64 << 63)
#define SmartRemind_MASK_NOTIFICATIONPOWER  (B64 << 62)
#define SmartRemind_MASK_ANTILOSTPOWER (B64 << 61)
#define SmartRemind_MASK_EMERGENCYPOWER (B64 << 60)
#define SmartRemind_MASK_SEDENTARYPOWER (B64 << 59)
#define SmartRemind_MASK_NFTAMOUNT  (0xFFLL << 48)
#define SmartRemind_MASK_REMINDCOUNT (0xFFFFFFFFLL)

#define SmartRemind_MASK_DISVIB (B64 << 58)
#define SmartRemind_MASK_DISFLASH (B64 << 57)

@interface SmartRemindConfig : ModuleClass<NSCoding>
@property BOOL Power;
@property BOOL SedentaryPower;
@property(nonatomic,assign)BOOL EmergencyPower;
@property(nonatomic,assign)BOOL AntilostPower;
@property BOOL NotificationPower;

//-----------
@property(nonatomic,assign)BOOL DisVib;
@property(nonatomic,assign)BOOL DisFlash;


@property NSInteger NtfAmount;
@property NSInteger RemindCount;

+(SmartRemindConfig *)build:(UInt64) config;

-(UInt64)convert;

@end
