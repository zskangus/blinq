//
//  AntilostConfig.m
//  cjj
//
//  Created by 聂晶 on 15/11/25.
//  Copyright © 2015年 cjj. All rights reserved.
//

#import "AntilostConfig.h"

 

@implementation AntilostConfig


+(AntilostConfig *)buid:(int)config{
    AntilostConfig *Config = [[AntilostConfig alloc]init];
    Config.Power = ((config & Antilost_MASK_POWER) == Antilost_MASK_POWER);
    
    Config.Vib = ((config & Antilost_MASK_VIB) == Antilost_MASK_VIB);
    Config.Color = (NSInteger) ((config & Antilost_MASK_COLOR) >> 27);
    Config.Distance = (NSInteger) ((config & Antilost_MASK_DISTANCE) >> 22);
    Config.RemindCount = (NSInteger) (config & Antilost_MASK_REMINDCOUNT);
    return Config;
}

-(int)convert {
    int res = 0;
    if (self.Power)
        res |= 1 << 31;
    if (self.Vib)
        res |= 1 << 30;
    
    res |= ((self.Color & 0x07L) << 27);
    res |= ((self.Distance & 0x1FL) << 22);
    res |= (self.RemindCount & 0xFFFFL);
    
    printf("res:%x",res);
    
    return res;
}



@end
