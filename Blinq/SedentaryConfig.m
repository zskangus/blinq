//
//  SedentaryConfig.m
//  cjj
//
//  Created by 聂晶 on 15/11/25.
//  Copyright © 2015年 cjj. All rights reserved.
//

#import "SedentaryConfig.h"



@implementation SedentaryConfig


+(SedentaryConfig*) buid:(NSInteger)config {
    SedentaryConfig *Config = [[SedentaryConfig alloc]init];
    Config.Power = ((config & Sendentary_MASK_POWER) == Sendentary_MASK_POWER);
    
    Config.Vib = ((config & Sendentary_MASK_VIB) == Sendentary_MASK_VIB);
    Config.Color = (NSInteger) ((config & Sendentary_MASK_COLOR) >> 59);
    
   
    int st_h = ((config & Sendentary_MASK_SH) >> 54);
    int st_s = ((config & Sendentary_MASK_SM) >> 48);
    Config.StartTime = [NSString stringWithFormat:@"ST[%d:%d]",st_h,st_s];
    

    int et_h = ((config & Sendentary_MASK_EH) >> 43);
    int et_s = ((config & Sendentary_MASK_EM) >> 37);
    Config.EndTime = [NSString stringWithFormat:@"ET[%d:%d]",et_h,et_s];
    
    
    Config.Repeat = (NSInteger) ((config & Sendentary_MASK_REPEAT) >> 30);
    Config.IntervalMinute = (NSInteger) ((config & Sendentary_MASK_INTERVAL_MINUTE) >> 22);
    Config.RemindCount = (short) (config & Sendentary_MASK_REMINDCOUNT);
    
    return Config;
}

-(NSInteger)convert {
    long res = 0;
    if (self.Power)
        res |= 1L << 63;
    if (self.Vib)
        res |= 1L << 62;
    
//    res |= ((self.Color & 0x07L) << 59);
//    res |= ((0x1FL & Long.parseLong(StartTime.substring(
//                                                        StartTime.indexOf("[") + 1, StartTime.indexOf(":")))) << 54);
//    res |= (0x3FL & Long.parseLong(StartTime.substring(
//                                                       StartTime.indexOf(":") + 1, StartTime.indexOf("]")))) << 48;
//    res |= ((0x1FL & Long.parseLong(EndTime.substring(
//                                                      EndTime.indexOf("[") + 1, EndTime.indexOf(":")))) << 43);
//    res |= (0x3FL & Long.parseLong(EndTime.substring(
//                                                     EndTime.indexOf(":") + 1, EndTime.indexOf("]")))) << 37;
//    
//    res |= ((Repeat & 0x7FL) << 30);
//    res |= ((IntervalMinute & 0xFFL) << 22);
//    res |= (RemindCount & 0xFFFFL);
    
    return res;
}
@end
