//
//  SedentaryConfig.h
//  cjj
//
//  Created by 聂晶 on 15/11/25.
//  Copyright © 2015年 cjj. All rights reserved.
//

#import "ModuleClass.h"

#define Sendentary_MASK_POWER (1L << 63)
#define Sendentary_MASK_VIB (1L << 62)
#define Sendentary_MASK_COLOR (0x07L << 59)
#define Sendentary_MASK_SH (0x1FL << 54)
#define Sendentary_MASK_SM (0x3FLL << 48)
#define Sendentary_MASK_EH (0x1FLL << 43)
#define Sendentary_MASK_EM (0x3FLL << 37)
#define Sendentary_MASK_REPEAT (0x7F << 30)
#define Sendentary_MASK_INTERVAL_MINUTE (0xFF << 22)
#define Sendentary_MASK_REMINDCOUNT (0xFFFF)

@interface SedentaryConfig : ModuleClass

@property BOOL Power;
@property BOOL Vib;
@property NSInteger Color;
@property (nonatomic,strong) NSString* StartTime;
@property(nonatomic,strong) NSString* EndTime;
@property NSInteger Repeat;
@property NSInteger IntervalMinute;
@property NSInteger RemindCount;


@end
