//
//  SOSModule.h
//  cjj
//
//  Created by 聂晶 on 16/1/20.
//  Copyright © 2016年 cjj. All rights reserved.
//
#import "SOSData.h"
#import "ModuleClass.h"
@interface SOSModule : ModuleClass
+(SOSData *)setConfigs:(NSInteger)type config:(UInt64)cofing mask:(UInt64)mask reqAck:(BOOL)reqAck;

+(SOSData *)getConfig:(NSInteger)type;
@end
