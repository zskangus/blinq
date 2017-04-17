//
//  SmartRemindModule.h
//  cjj
//
//  Created by 聂晶 on 15/11/25.
//  Copyright © 2015年 cjj. All rights reserved.
//

#import "ModuleClass.h"
#import "SmartRemindData.h"


@interface SmartRemindModule : ModuleClass
+(SmartRemindData *)setConfigs:(NSInteger)type config:(UInt64)cofing mask:(UInt64)mask reqAck:(BOOL)reqAck;

+(SmartRemindData *)addConfigs:(NSInteger)type cmdId:(int)cmdId config:(UInt64)cofing;

+(SmartRemindData *)removeConfigs:(NSInteger)type config:(UInt64)cofing;

+(SmartRemindData *)getConfig:(NSInteger)type catId:(NSInteger)catId appId:(NSInteger)appId;

+(SmartRemindData *)getConfig:(NSInteger)type;
@end
