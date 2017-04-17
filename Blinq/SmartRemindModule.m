//
//  SmartRemindModule.m
//  cjj
//
//  Created by 聂晶 on 15/11/25.
//  Copyright © 2015年 cjj. All rights reserved.
//

#import "SmartRemindModule.h"

@implementation SmartRemindModule


+(SmartRemindData *)setConfigs:(NSInteger)type config:(UInt64)cofing mask:(UInt64)mask reqAck:(BOOL)reqAck{
    NSInteger cmdid = reqAck ? COMMAND_ID_CONFIG_SET_REQ
				: COMMAND_ID_CONFIG_SET_NACK;
    NSLog(@"远离提醒的cofing为%llu",cofing);
    NSLog(@"config=%16llx,mask=%16llx", cofing, mask);
    NSMutableData *data = [[NSMutableData alloc]init];
    switch (type) {
        // 智能提醒
        case TYPE_TAG_SMARTREMIND:
        // 久坐提醒
        case TYPE_TAG_SEDENTARY:
        // 智能通知
        case TYPE_TAG_NOTIFICATIONS:
//            [data appendData:[Utils int2HEX:cofing andB:8]];
//            [data appendData:[Utils int2HEX:mask andB:8]];
            [data appendBytes: &cofing length:8];
            [data appendBytes: &mask length:8];
            [Utils printfData2Byte:data and:@"智能通知"];
            break;
        // 紧急报警
        case TYPE_TAG_EMERGENCY:
        // 远离
        case TYPE_TAG_ANTILOST:{
            [data appendBytes: &cofing length:sizeof(int)];
            [data appendBytes: &mask length:sizeof(int)];
            //[data appendData:[Utils int2NSData:cofing andB:4]];
            //[data appendData:[Utils int2NSData:mask andB:4]];
            [Utils printfData2Byte:data and:@"远离"];
            break;
        }
    }
    [Utils printfData2Byte:data and:@"设置数据："];
    return [SmartRemindData build:cmdid tag:type data:data];
}

+(SmartRemindData *)addConfigs:(NSInteger)type cmdId:(int)cmdId config:(UInt64)cofing{
    if (type == TYPE_TAG_NOTIFICATIONS) {
        NSMutableData *data = [[NSMutableData alloc]init];
        switch (cmdId) {
            //增加设置
            case COMMAND_ID_NTF_SETTING_ADD:
                NSLog(@"========config=  %16llx", cofing);
                
                [data appendBytes: &cofing length:8];
                [Utils printfData2Byte:data and:@"addConfig："];
                return [SmartRemindData build:cmdId tag:type data:data];
                break;
            //增加通知
            case COMMAND_ID_NTF_ADDED:
                [data appendBytes: &cofing length:4];
                return [SmartRemindData build:cmdId tag:type data:data];

                break;
            case COMMAND_ID_NTF_REMOVED:
                break;
                
            default:
                break;
        }
        
        
    }
    return nil;
    
}


+(SmartRemindData *)removeConfigs:(NSInteger)type config:(UInt64)cofing{
    if (type == TYPE_TAG_NOTIFICATIONS) {
        NSInteger cmdid = COMMAND_ID_NTF_SETTING_REMOVE;
        NSLog(@"========config=  %16llx", cofing);
        NSMutableData *data = [[NSMutableData alloc]init];
        [data appendBytes: &cofing length:8];
        [Utils printfData2Byte:data and:@"removeConfigs："];
        return [SmartRemindData build:cmdid tag:type data:data];
    }
    
    return nil;
}

+(SmartRemindData *)getConfig:(NSInteger)type catId:(NSInteger *)catId appId:(NSInteger *)appId{
    Byte buff[] = {catId,appId};
    
    NSData *data = [[NSData alloc] initWithBytes:buff length:2];
    return [SmartRemindData build:COMMAND_ID_CONFIG_GET_REQ tag:type data:data];
}

+(SmartRemindData *)getConfig:(NSInteger)type{
     return [SmartRemindData build:COMMAND_ID_CONFIG_GET_REQ tag:type data:nil];
}


//+(SmartRemindData *)addNTFConfig:(NSInteger)type config:(UInt64)cofing cmdId(NSInteger *)cmdId{
//    if (type == TYPE_TAG_NOTIFICATIONS) {
//        NSInteger cmdId = COMMAND_ID_NTF_ADDED;
//        NSLog(@"========config=  %16llx", cofing);
//        NSMutableData *data = [[NSMutableData alloc]init];
//        [data appendBytes: &cofing length:8];
//        [Utils printfData2Byte:data and:@"addConfig："];
//        return [SmartRemindData build:cmdId tag:type data:data];
//    }
//    return nil;
    
//}
@end
