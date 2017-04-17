//
//  AntiLostModule.m
//  cjj
//
//  Created by 聂晶 on 15/11/19.
//  Copyright © 2015年 cjj. All rights reserved.
//

#import "AntiLostModule.h"
#import "Message.h"

@interface AntiLostModule(){
    
}
@end
@implementation AntiLostModule

-(instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}



-(void)build:(int)cmdId andData:(NSData *)antilostData{
    self.cmdId = cmdId;
    if(antilostData != nil) {
        self.antiLostData = antilostData;
    }
}

-(NSData *) toBytes{
    NSMutableData *buff = [[NSMutableData alloc]init];
    Byte *fixed[1];
    fixed[0] = self.cmdId;
    [buff appendBytes:fixed length:(1)];
    if(self.antiLostData != nil) {
        [buff appendData:self.antiLostData];
    }
    return buff;
}

+(AntiLostData *)setConfigs:(NSInteger)type config:(UInt64)cofing mask:(UInt64)mask reqAck:(BOOL)reqAck{
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
    return [AntiLostData build:cmdid tag:type data:data];
}




+(AntiLostData *)getConfig:(NSInteger)type{
    return [AntiLostData build:COMMAND_ID_CONFIG_GET_REQ tag:type data:nil];
}



@end
