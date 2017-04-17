//
//  SOSConfig.h
//  cjj
//
//  Created by 聂晶 on 16/1/20.
//  Copyright © 2016年 cjj. All rights reserved.
//


#import "ModuleClass.h"

#define SOS_MASK_POWER ( 1 << 31)
#define SOS_MASK_OPERATE (0x0F << 27)
#define SOS_MASK_COLOR (0x07 << 24)
#define SOS_MASK_REMINDCOUNT (0xFFFF)

@interface SOSConfig : ModuleClass

@property BOOL Power;
@property NSInteger Operate;
@property NSInteger Color;
@property NSInteger RemindCount;


+(SOSConfig *)sosBuild:(int)config;




-(int)convert;
@end
