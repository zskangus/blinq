//
//  SMHeadDataModel.m
//  Blinq
//
//  Created by zsk on 2016/12/1.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "SMHeadDataModel.h"
#import "MessageMacro.h"

@implementation SMHeadDataModel

- (NSData *)getHeadData{
    return [self headBytesToNSDataFromVersion:self.version
                                  serviceType:self.service_type
                                       length:self.length identification:self.identification
                              flag_and_offset:self.flag_and_offset
                                     moduleId:self.modId
                                    check_sum:self.check_sum];
}

- (NSData*)headBytesToNSDataFromVersion:(NSInteger)version serviceType:(NSInteger)serviceType length:(NSInteger)length identification:(NSInteger)identification flag_and_offset:(NSInteger)flag_and_offset moduleId:(NSInteger)moduleId check_sum:(NSInteger)check_sum{
    
    Byte buff[HEADLENGTH];
    memset(buff, 0x00, HEADLENGTH);
    Byte * tmp = &buff[0];
    buff[0] = version;
    buff[1] = serviceType;
    
    tmp+=2;
    NSInteger tt = length;
    memcpy(tmp, &tt, 2);
    tmp+=2;
    tt = identification;
    memcpy(tmp, &tt, 2);
    tmp+=2;
    tt = flag_and_offset;
    memcpy(tmp, &tt, 2);
    tmp+=2;
    tt = moduleId;
    memcpy(tmp, &tt, 2);
    tmp+=2;
    tt = check_sum;
    memcpy(tmp, &tt, 2);
#if 0
    int offset = 2;
    
    NSData *dl = [self copyOf:[self int2Hex:self.length andB:2] and:0 and:2];
    Byte *dlb = (Byte *)[dl bytes];
    for(int i = 0; i < 2; i++) {
        buff[i + offset] = dlb[i];
    }
    offset += 2;
    
    NSData *di = [self copyOf:[self int2Hex:self.identification andB:2] and:0 and:2];
    Byte *dib = (Byte *)[di bytes];
    for(int i = 0; i < 2; i++) {
        buff[i + offset] = dib[i];
    }
    offset += 2;
    
    NSData *df = [self copyOf:[self int2Hex:self.flag_and_offset andB:2] and:0 and:2];
    Byte *dfb = (Byte *)[df bytes];
    for(int i = 0; i < 2; i++) {
        buff[i + offset] = dfb[i];
    }
    offset += 2;
    
    NSData *dm = [self copyOf:[self int2Hex:self.mod_id andB:2] and:0 and:2];
    Byte *dmb = (Byte *)[dm bytes];
    for(int i = 0; i < 2; i++) {
        buff[i + offset] = dmb[i];
    }
    offset += 2;
    
    NSData *dc = [self copyOf:[self int2Hex:self.check_sum andB:2] and:0 and:2];
    Byte *dcb = (Byte *)[dm bytes];
    for(int i = 0; i < 2; i++) {
        buff[i + offset] = dcb[i];
    }
    offset += 2;
#endif
    //head
    
    return [[NSData alloc] initWithBytes:buff length:HEADLENGTH];
}

@end
