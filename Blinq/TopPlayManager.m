//
//  TopPlayManager.m
//  cjj
//
//  Created by 聂晶 on 15/11/26.
//  Copyright © 2015年 cjj. All rights reserved.
//

#import "TopPlayManager.h"
#import "TopPlayModule.h"
#import "TopPlayData.h"


@interface TopPlayManager()
@property (strong,nonatomic)BTServer *defaultBTServer;
@end
@implementation TopPlayManager


-(instancetype)init
{
    self = [super init];
    if (self) {
        self.defaultBTServer = [BTServer sharedBluetooth];
    }
    return self;
}

-(void)writerMsgDataTopPlayColor:(NSInteger)modId data:(NSData *)color{
    NSData *msgdata = [self buildMsgDataForTopPlayCOLOR:modId data:color];
    [self.defaultBTServer writedidWriteData:msgdata];
}
-(void)writerMsgDataTopPlayVibrate:(NSInteger)modId data:(NSData *)level{
    NSData *msgdata = [self buildMsgDataForTopPlayVIB:modId data:level];
    [self.defaultBTServer writedidWriteData:msgdata];
}

-(NSData *)buildMsgDataForTopPlayCOLOR:(NSInteger)modId data:(NSData *)reqdata{
    TopPlayData *data = [TopPlayModule setConfigsCOLOR:reqdata reqAck:true];
    Message *msg = [[Message alloc]init];
    [msg build:modId and:[data toBytes]];
    NSData *msgData = [msg bytes2NSData];
    return msgData;
    
}
-(NSData *)buildMsgDataForTopPlayVIB:(NSInteger)modId data:(NSData *)reqdata{
    TopPlayData *data = [TopPlayModule setConfigsVIB:reqdata reqAck:true];
    Message *msg = [[Message alloc]init];
    [msg build:modId and:[data toBytes]];
    NSData *msgData = [msg bytes2NSData];
    return msgData;
    
}

-(void)parseMsgDataForTopPlay:(NSData *)reqBytes{
    TopPlayData* data = [TopPlayData parse:reqBytes];
    [Utils printfData2Byte:reqBytes and:@"paly:"];
    if (data!=nil) {
            switch (data.cmdId) {
                case COMMAND_ID_COLOR_SET_REQ:
                    
                    break;
                default:
                    break;
            }
    }
    
    
}

@end
