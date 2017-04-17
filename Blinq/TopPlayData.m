//
//  TopPlayModule.m
//  cjj
//
//  Created by 聂晶 on 15/11/18.
//  Copyright © 2015年 cjj. All rights reserved.
//

#import "TopPlayData.h"
#import "Message.h"
#import "BTServer.h"
@interface TopPlayData()
@property (strong,nonatomic)BTServer *defaultBTServer;
@end

@implementation TopPlayData

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.defaultBTServer = [BTServer sharedBluetooth];

    }
    return self;
}

+(TopPlayData *)build:(int)cmdId andErrcode:(int)errcode{
    TopPlayData *play = [[TopPlayData alloc]init];
    play.cmdId = cmdId;
    play.errcode = errcode;
    return play;
}

+(TopPlayData *)build:(int)cmdId andPlay:(NSData *)playData{
    TopPlayData *play = [[TopPlayData alloc]init];
    play.cmdId = cmdId;
    if(playData != nil) {
        play.payload = playData;
    }
    return play;
}

+(TopPlayData *)build:(int)cmdId andErrcode:(int)errcode andPlay: (NSData *)playData{
    TopPlayData *play = [[TopPlayData alloc]init];
    play.cmdId = cmdId;
    play.errcode = errcode;
    if(playData != nil) {
        play.payload = playData;
    }
    return play;
}

-(NSData *) toBytes{
    NSMutableData *buff = [[NSMutableData alloc]init];
    Byte *fixed[2];
    fixed[0] = self.cmdId;
    fixed[1] = self.errcode;
    [buff appendBytes:fixed length:(2)];
    if(self.payload != nil) {
        [buff appendData:self.payload];
    }
    return buff;
}

+(TopPlayData *)parse:(NSData*)data{
    if (data==nil || data.length<PLAY_DATA_MIN_LENGTH) {
        return nil;
    }
    Byte *reqBytes = (Byte *)[data bytes];
    TopPlayData *play = [[TopPlayData alloc]init];
    play.cmdId = reqBytes[0];
    play.errcode = reqBytes[1];
    if (data.length > PLAY_DATA_MIN_LENGTH) {
        play.payload = [data subdataWithRange:NSMakeRange(PLAY_DATA_MIN_LENGTH, data.length - PLAY_DATA_MIN_LENGTH)];
        switch (play.cmdId) {
            case COMMAND_ID_COLOR_SET_REQ:
                
                break;
                
            default:
                break;
        }
    }
    return play;
    
}



@end
