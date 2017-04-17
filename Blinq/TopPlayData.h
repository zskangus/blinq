//
//  TopPlayModule.h
//  cjj
//
//  Created by 聂晶 on 15/11/18.
//  Copyright © 2015年 cjj. All rights reserved.
//

#import "ModuleClass.h"


@interface TopPlayData : ModuleClass
@property int cmdId;
@property int errcode;
@property NSData *payload;

+(TopPlayData *)build:(int)cmdId andPlay:(NSData *)playData;
+(TopPlayData *)build:(int)cmdId andErrcode:(int)errcode;
+(TopPlayData *)build:(int)cmdId andErrcode:(int)errcode andPlay: (NSData *)playData;

+(TopPlayData *)parse:(NSData*)data;


-(NSData *) toBytes;

@end
