//
//  SmartRemindData.m
//  cjj
//
//  Created by 聂晶 on 15/11/25.
//  Copyright © 2015年 cjj. All rights reserved.
//

#import "SmartRemindData.h"

#define Remind_DATA_MIN_LENGTH 0x03

@implementation SmartRemindData

+(SmartRemindData *) build:(NSInteger)cmdId tag:(NSInteger)tag data:(NSData*)payload{
    SmartRemindData *remind = [[SmartRemindData alloc]init];
    remind.cmdId = cmdId;
    remind.tag = tag;
    remind.payload = payload;
    return remind;
}

+(SmartRemindData *) build:(NSInteger)errcode cmdId:(NSInteger)cmdId tag:(NSInteger)tag data:(NSData*)payload{
    SmartRemindData *remind = [[SmartRemindData alloc]init];
    remind.errcode = errcode;
    remind.cmdId = cmdId;
    remind.tag = tag;
    remind.payload = payload;
    return remind;
}

+(SmartRemindData *)parse:(NSData*)data{
    if (data==nil || data.length<Remind_DATA_MIN_LENGTH) {
        return nil;
    }
    Byte *reqBytes = (Byte *)[data bytes];
    SmartRemindData *remind = [[SmartRemindData alloc]init];
    remind.cmdId = reqBytes[0];
    remind.tag = reqBytes[1];
    remind.errcode = reqBytes[2];
    
    if (data.length > Remind_DATA_MIN_LENGTH) {
        remind.payload = [data subdataWithRange:NSMakeRange(Remind_DATA_MIN_LENGTH, data.length - Remind_DATA_MIN_LENGTH)];
    }
    return remind;
    
}

-(NSData *)toBytes{
    NSMutableData *data = [[NSMutableData alloc]init];
    Byte buf[] = {self.cmdId, self.tag, self.errcode};
    [data appendBytes:buf length:3];
    if(self.payload!=nil) {
        [data appendData:self.payload];
    }
    return data;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@,%p>{cmdId:%d,tag:%d,errcode:%d,payload:%@}",[self class], self, self.cmdId,self.tag,self.errcode,self.payload];
}
@end
