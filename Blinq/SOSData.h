//
//  SOSData.h
//  cjj
//
//  Created by 聂晶 on 16/1/20.
//  Copyright © 2016年 cjj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SOSData : NSObject
@property NSInteger cmdId;
@property NSInteger tag;
@property NSInteger errcode;
@property(nonatomic,strong)NSData* payload;

+(SOSData *) build:(NSInteger)cmdId tag:(NSInteger)tag data:(NSData*)payload;

+(SOSData *) build:(NSInteger)errcode cmdId:(NSInteger)cmdId tag:(NSInteger)tag data:(NSData*)payload;

+(SOSData *)parse:(NSData*)data;


-(NSData *)toBytes;


@end
