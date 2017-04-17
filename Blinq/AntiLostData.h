//
//  AntiLostData.h
//  cjj
//
//  Created by 聂晶 on 16/5/28.
//  Copyright © 2016年 cjj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AntiLostData : NSObject
@property NSInteger cmdId;
@property NSInteger tag;
@property NSInteger errcode;
@property(nonatomic,strong)NSData* payload;

+(AntiLostData *) build:(NSInteger)cmdId tag:(NSInteger)tag data:(NSData*)payload;

+(AntiLostData *) build:(NSInteger)errcode cmdId:(NSInteger)cmdId tag:(NSInteger)tag data:(NSData*)payload;

+(AntiLostData *)parse:(NSData*)data;


-(NSData *)toBytes;


@end

