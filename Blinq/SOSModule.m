//
//  SOSModule.m
//  cjj
//
//  Created by 聂晶 on 16/1/20.
//  Copyright © 2016年 cjj. All rights reserved.
//

#import "SOSModule.h"
@implementation SOSModule
+(SOSData *)setConfigs:(NSInteger)type config:(UInt64)cofing mask:(UInt64)mask reqAck:(BOOL)reqAck{
    NSInteger cmdid = reqAck ? COMMAND_ID_CONFIG_SET_REQ
				: COMMAND_ID_CONFIG_SET_NACK;
    NSMutableData *data = [[NSMutableData alloc]init];
    switch (type) {
            // 智能提醒
        case TYPE_TAG_SMARTREMIND:
            // 久坐提醒
        case TYPE_TAG_SEDENTARY:
            // 智能通知
        case TYPE_TAG_NOTIFICATIONS:
            [data appendBytes: &cofing length:8];
            [data appendBytes: &mask length:8];
            [Utils printfData2Byte:data and:@"remind=====>:"];
            break;
            // 紧急报警
        case TYPE_TAG_EMERGENCY:
            [data appendBytes: &cofing length:4];
            [data appendBytes: &mask length:4];
            [Utils printfData2Byte:data and:@"sos=====>:"];
            break;
            // 远离
        case TYPE_TAG_ANTILOST:{
            [data appendBytes: &cofing length:sizeof(int)];
            [data appendBytes: &mask length:sizeof(int)];
            [Utils printfData2Byte:data and:@"antilost=====>:"];
            break;
        }
    }
    return [SOSData build:cmdid tag:type data:data];
}




+(SOSData *)getConfig:(NSInteger)type{
    return [SOSData build:COMMAND_ID_CONFIG_GET_REQ tag:type data:nil];
}


@end
