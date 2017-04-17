//
//  MessageHead.m
//  cjj
//
//  Copyright © 2015年 cjj. All rights reserved.
//

#import "MessageHead.h"

@implementation MessageHead


- (NSString *)description
{
    return [NSString stringWithFormat:@"version:%02X,serviceType:%d,length:%d", _version,_service_type,_length];
}
-(NSData *) headBytes2NSData {
    Byte buff[HEADLENGTH];
    memset(buff, 0x00, HEADLENGTH);
    Byte * tmp = &buff[0];
    buff[0] = self.version;
    buff[1] = self.service_type;
    
    tmp+=2;
    int tt = self.length;
    memcpy(tmp, &tt, 2);
    tmp+=2;
    tt = self.identification;
    memcpy(tmp, &tt, 2);
    tmp+=2;
    tt = self.flag_and_offset;
    memcpy(tmp, &tt, 2);
    tmp+=2;
    tt = self.mod_id;
    memcpy(tmp, &tt, 2);
    tmp+=2;
    tt = self.check_sum;
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
    printf("MessageHead:");
    for (int i = 0; i< HEADLENGTH ; i++) {
        printf(" %2x",buff[i]);
    }
    printf("\r\n");

    
    return [[NSData alloc] initWithBytes:buff length:HEADLENGTH];
}





@end
