//
//  SMDataPackageManager.m
//  Blinq
//
//  Created by zsk on 2016/12/1.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "SMDataPackageManager.h"
#import "SMHeadDataModel.h"
#import "Utils.h"
#import "MessageMacro.h"

@interface SMDataPackageManager()

@property(nonatomic,assign)NSInteger crc;

@property(nonatomic,strong)SMHeadDataModel *headDataClass;

@end

@implementation SMDataPackageManager

// 通过模块ID和数据体构建完整数据
- (NSData*)buildDataFrom:(NSInteger)moduleId and:(NSData *)bodyData{
    
    // 初始化头部数据
    self.headDataClass.version = VERSON;
    self.headDataClass.service_type = SERVICE_TYPE;
    self.headDataClass.length = HEADLENGTH + bodyData.length;
    self.headDataClass.identification = arc4random() % 100;//获取一个随机整数范围在：[0,100)包括0，不包括100
    self.headDataClass.flag_and_offset = 0;
    self.headDataClass.modId = moduleId;
    self.headDataClass.check_sum = 0;
    
    // 校验和
    NSData *headData = [self.headDataClass getHeadData];
    self.headDataClass.check_sum = [self checksum16BuildFunc:headData];
    
    NSData *selfData = [self getSelfDataFromHeadData:[self.headDataClass getHeadData] andBodyData:bodyData];
    
    self.crc = [self crc16:selfData];
    
    return [self getSelfDataFromHeadData:[self.headDataClass getHeadData] andBodyData:bodyData];
}


-(NSData *)getSelfDataFromHeadData:(NSData*)headData andBodyData:(NSData*)bodyData{

    NSInteger body_len = bodyData.length;
    Byte buff[HEADLENGTH + body_len + 2];
    
    int offset = 0;
    
    Byte *hb = (Byte *)[headData bytes];
    for(int i = 0; i < HEADLENGTH; i++) {
        buff[i + offset] = hb[i];
    }
    offset += HEADLENGTH;
    
    
    Byte *bb = (Byte *)[bodyData bytes];
    for(int i = 0; i < body_len; i++) {
        buff[i + offset] = bb[i];
    }
    offset += body_len;
    
    NSData *dc = [Utils int2NSData:(int)self.crc andB:2];
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
    printf("Message sizeof:%lu",sizeof(buff));
    return [NSData dataWithBytes:buff length:sizeof(buff)];
}



-(uint16_t)checksum16BuildFunc:(NSData *)headData{
    const uint16_t *bytes = (uint16_t *)[headData bytes];
    return checksumFunc(bytes, headData.length - 2);
}

//检查校验
uint16_t checksumFunc (uint16_t *buffer,uint16_t size)
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

//#define CRC16 0x8005
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
            //out ^= CRC16;
            out ^= 0x8005;
    }
    printf("OUT: %04X\r\n",out);
    return out;
}


@end
