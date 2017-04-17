//
//  Message.m
//  cjj
//  Copyright © 2015年 cjj. All rights reserved.
//

#import "Message.h"



@implementation Message

- (NSString *)description
{
    return [NSString stringWithFormat:@"head:%@,body:%@,crc:%d", _head,_body.description,_crc];
}

-(NSData *)build:(NSInteger)modId and:(NSData *)body{
    self.body = body;
    self.head = [[MessageHead alloc]init];
    self.head.version = VERSON;
    self.head.service_type = SERVICE_TYPE;
    self.head.length = HEADLENGTH + body.length;
    self.head.identification = [self randomBetween:0 And:100];
    self.head.flag_and_offset = 0;
    self.head.mod_id = modId;
    self.head.check_sum = 0;//
    NSData *headData = [self.head headBytes2NSData];
    
    
    
    self.head.check_sum = [self checksum16Build:headData];
    self.crc = 0;
    NSData *data = [self bytes2NSData];
    self.crc = [self crc16:data];
    
   return [self bytes2NSData];
    
}
-(Message *)parseMessage:(NSData *)msgData{
    if(!msgData)return nil;
    [Utils printfData2Byte:msgData];
    Byte *buff = (Byte *)[msgData bytes];
    if (msgData.length >= HEADLENGTH) {
        Message *msg = [[Message alloc]init];
        msg->_head = [[MessageHead alloc]init];
        msg->_head.version = buff[0];
        msg->_head.service_type = buff[1];
        Byte lens[2];
        lens[0] = buff[3];
        lens[1] = buff[2];
        msg->_head.length = [Utils hex2Int:lens and:0 and:2];
        
        Byte identificationLens[2];
        identificationLens[0] = buff[5];
        identificationLens[1] = buff[4];
        msg->_head.identification = [Utils hex2Int:identificationLens and:0 and:2];
        
        Byte flag_and_offsetLens[2];
        flag_and_offsetLens[0] = buff[7];
        flag_and_offsetLens[1] = buff[6];
        msg->_head.flag_and_offset = [Utils hex2Int:flag_and_offsetLens and:0 and:2];
        
        Byte mod_idLens[2];
        mod_idLens[0] = buff[9];
        mod_idLens[1] = buff[8];
        msg->_head.mod_id = [Utils hex2Int:mod_idLens and:0 and:2];
        
        Byte check_sumLens[2];
        check_sumLens[0] = buff[11];
        check_sumLens[1] = buff[10];
        msg->_head.check_sum = [Utils hex2Int:check_sumLens and:0 and:2];
        
        int bodyLen = msg.head.length - HEADLENGTH;
        msg.body = [msgData subdataWithRange:NSMakeRange(HEADLENGTH, bodyLen)];
        msg.crc = [Utils hex2Int:buff and:msgData.length - 2 and:2];
        @try{
            NSData *headData = [msg.head headBytes2NSData];
            [Utils printfData2Byte:headData];
            //判断CRC是否正确
            if (![self crc16Valid:msgData]) {
                 NSLog(@"CheckSum ERROR. %@",[self crc16Valid:msgData]);
                
            }
            //判断CRC是否正确
            if([self checksum16Parse:headData]!= 0){
                NSLog(@"CheckSum ERROR. %@",[self checksum16Parse:headData]);
                
            }
        
        } @catch (NSException* ex) {
            NSLog(@"ex:%@",ex);
        }
        @finally {
            NSLog(@"finally");
        }
        
        return msg;
    }
    return nil;
    
}




-(NSData *)bytes2NSData{
    NSData *head = [self.head headBytes2NSData];
    int body_len = self.body.length;
    Byte buff[HEADLENGTH + body_len + 2];
    
    int offset = 0;
    
    Byte *hb = (Byte *)[head bytes];
    for(int i = 0; i < HEADLENGTH; i++) {
        buff[i + offset] = hb[i];
    }
    offset += HEADLENGTH;
    
    
    Byte *bb = (Byte *)[self.body bytes];
    for(int i = 0; i < body_len; i++) {
        buff[i + offset] = bb[i];
    }
    offset += body_len;
    
    NSData *dc = [Utils int2NSData:self.crc andB:2];
    Byte *dcb = (Byte *)[dc bytes];
    for(int i = 0; i < 2; i++) {
        buff[i + offset] = dcb[i];
    }
    offset += 2;
    printf("Message:");
    for (int i = 0; i< HEADLENGTH + body_len + 2; i++) {
        printf(" %02X",buff[i]);
    }
    printf("\r\n");
    printf("Message sizeof:%d",sizeof(buff));
    return [NSData dataWithBytes:buff length:sizeof(buff)];
}


/**
 *  校验CRC 16位
 *
 *  @return return value description
 */
- (unsigned short)crc16:(NSData *)data
{
    const uint8_t *bytes = (const uint8_t *)[data bytes];
    return (unsigned short)gen_crc16(bytes,data.length-2);
}
/**
 *  校验和 16位
 *
 *  @param data <#data description#>
 *  @param len  <#len description#>
 *
 *  @return <#return value description#>
 */
-(uint16_t)checksum16Build:(NSData *)headData{
    const uint16_t *bytes = (uint16_t *)[headData bytes];
    return checksum(bytes, headData.length - 2);
}

-(uint16_t)checksum16Parse:(NSData *)headData{
    Byte *buff = (Byte *)[headData bytes];
    printf("checksum16Parse: \r\n");
    for (auto i = 0; i<headData.length; i++) {
        printf(" %02X", buff[i]);
    }
    printf("\r\n");
    uint8_t larr[12] = {0x00};
    const uint16_t *bytes = (uint16_t *)[headData bytes];
    
//    memcpy(larr, (uint8_t *)bytes, 12);
    return checksum((uint16_t *)&bytes[0], 12);
}

//验证CRC
-(BOOL)crc16Valid:(NSData *)data
{
    
    [Utils printfData2Byte:data];
    
    const uint8_t *bytes = (const uint8_t *)[data bytes];
    return crc16_valid(bytes, data.length);
}

/**
 *  <#Description#>
 *
 *  @param str <#str description#>
 *
 *  @return <#return value description#>
 */
+(NSString*) md5:(NSString*) str
{
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result );
    
    NSMutableString *hash = [NSMutableString string];
    for(int i=0;i<CC_MD5_DIGEST_LENGTH;i++)
    {
        [hash appendFormat:@"%02X",result[i]];
    }
    return [hash lowercaseString];
}





//检查校验
uint16_t checksum (uint16_t *buffer,uint16_t size)
{
    printf("%s, %d\r\n", __FILE__,__LINE__);
    printf("size %d\r\n", size);
    
    
    printf("checksum: \r\n");
    for (int i = 0; i<size; i++) {
        printf(" %04X", buffer[i]);
    }
    printf("\r\n");
    
    

    uint32_t cksum=0;
    while (size>1)
    {
        cksum +=*buffer++;
        size -=sizeof(uint16_t);
    }
    if (size)
    {
        cksum +=*(uint8_t *) buffer;
    }
    //
    while (cksum>>16)
        cksum = (cksum>>16) + (cksum & 0xffff);
    uint16_t res =(~cksum);

    printf("res: %4x\r\n", res);
    
    
    
    return (uint16_t) (~cksum);
}

void crc16_insert_crc_a( uint8_t* msg, uint16_t len )
{
    uint16_t crc;
    
    crc = gen_crc16(msg, len);
    msg[len] = crc & 0xFF;
    msg[len + 1] = (crc >> 8) & 0xFF;
}

void crc16_get_crc_a( uint8_t* msg, uint16_t len, uint8_t* byte1, uint8_t* byte2)
{
    uint16_t crc;
    
    crc = gen_crc16(msg, len);
    *byte1 = crc & 0xFF;
    *byte2 = (crc >> 8) & 0xFF;
}
//校验CRC
bool crc16_valid(uint8_t* msg, uint16_t len)
{
    uint8_t crcByte1, crcByte2;
    
    crc16_get_crc_a(msg,
                    len - 2, &crcByte1, &crcByte2);
    
    if (msg[len - 2] == crcByte1 &&
        msg[len - 1] == crcByte2) {
        return true;
    }
    else {
        return false;
    }
    
}


#define CRC16 0x8005
static uint16_t gen_crc16(const uint8_t *msg, uint16_t size)
{
    uint16_t out = 0;
    int bits_read = 0, bit_flag;
    printf("%s, %d\r\n",__FILE__, __LINE__);
    printf("Size : %d\r\n",size);
    while(size > 0)
    {
        bit_flag = out >> 15;
        /* Get next bit: */
        out <<= 1;
        out |= (*msg >> (7 - bits_read)) & 1;
        
        /* Increment bit counter: */
        bits_read++;
        if(bits_read > 7)
        {
            bits_read = 0;
            msg++;
            size--;
        }
        /* Cycle check: */
        if(bit_flag)
            out ^= CRC16;
    }
    printf("OUT: %04X\r\n",out);
    return out;
}

//随机返回某个区间范围内的值
- (NSInteger) randomBetween:(NSInteger )smallerNumber And:(NSInteger )largerNumber{
    NSInteger startVal = smallerNumber;
    NSInteger endVal = largerNumber;
    int randomValue = startVal + (arc4random()%(endVal - startVal));
    //返回结果
    return (randomValue/10000);
}

@end
