//
//  AntilostConfig.h
//  cjj
//
//  Created by 聂晶 on 15/11/25.
//  Copyright © 2015年 cjj. All rights reserved.
//

#import "ModuleClass.h"

#define Antilost_MASK_POWER ( 1 << 31)
#define Antilost_MASK_VIB (1 << 30)
#define Antilost_MASK_COLOR (0x07 << 27)
#define Antilost_MASK_DISTANCE (0x1F << 22)
#define Antilost_MASK_REMINDCOUNT (0xFFFF)

@interface AntilostConfig : ModuleClass
@property BOOL Power;
@property BOOL Vib;
@property NSInteger Color;
@property NSInteger Distance;
@property NSInteger RemindCount;

+(AntilostConfig *)buid:(int)config;

-(int)convert;

@end
