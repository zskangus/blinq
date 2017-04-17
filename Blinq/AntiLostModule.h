//
//  AntiLostModule.h
//  cjj
//
//  Created by 聂晶 on 15/11/19.
//  Copyright © 2015年 cjj. All rights reserved.
//

#import "ModuleClass.h"
#import "AntiLostData.h"

@interface AntiLostModule : ModuleClass
@property int cmdId;
@property int errcode;
@property NSData *antiLostData;

-(void)build:(int)cmdId andAntiLostData: (NSData *)antiLostData;

-(NSData *) toBytes;

-(void)parse:(NSData *)reqBytes;

+(AntiLostData *)setConfigs:(NSInteger)type config:(UInt64)cofing mask:(UInt64)mask reqAck:(BOOL)reqAck;

+(AntiLostData *)getConfig:(NSInteger)type;

@end
