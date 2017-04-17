//
//  SmartRemindData.h
//  cjj
//
//  Created by 聂晶 on 15/11/25.
//  Copyright © 2015年 cjj. All rights reserved.
//

#import "ModuleClass.h"


@interface SmartRemindData:ModuleClass

@property NSInteger cmdId;
@property NSInteger tag;
@property NSInteger errcode;
@property(nonatomic,strong)NSData* payload;



+(SmartRemindData *) build:(NSInteger)cmdId tag:(NSInteger)tag data:(NSData*)payload;

+(SmartRemindData *) build:(NSInteger)errcode cmdId:(NSInteger)cmdId tag:(NSInteger)tag data:(NSData*)payload;

+(SmartRemindData *)parse:(NSData*)data;


-(NSData *)toBytes;


@end
