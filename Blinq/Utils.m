//
//  Utils.m
//  cjj
//
//  Created by 聂晶 on 15/11/8.
//  Copyright © 2015年 cjj. All rights reserved.
//

#import "Utils.h"
#import "AppMacroDefinition.h"
#import "SMPlayViewController.h"

static NSData *nsdata = nil;
static NSInteger timelimit;
@implementation Utils

+ (void)setToKenNSData:(NSData *)token{
    nsdata = token;
}
+ (NSData *)getToKenNSData{
    return nsdata;
}

/**
 *  MD5散列 16位
 *
 *  @param str <#str description#>
 *
 *  @return <#return value description#>
 */
+ (NSData *)md5_16:(NSString *)str{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    NSData *data = [NSData dataWithBytes:result length:16];
    return data;
    
}

+(void)printfData2Byte:(NSData*)data{
    Byte *buff = (Byte *)[data bytes];
    printf("printfData2Byte: \r\n");
    for (auto i = 0; i<data.length; i++) {
        printf(" %02X", buff[i]);
    }
    printf("\r\n");
}

/**
 * 将int数值转换为占四个字节的byte数组，
   本方法适用于(低位在前，高位在后)的顺序。
 */
+(Byte *) intToBytes: (int) value
{
    Byte src[4];
    src[3] =  (Byte) ((value>>24) & 0xFF);
    src[2] =  (Byte) ((value>>16) & 0xFF);
    src[1] =  (Byte) ((value>>8) & 0xFF);
    src[0] =  (Byte) (value & 0xFF);
    return src;
}
/**
 * 将int数值转换为占四个字节的byte数组，
   本方法适用于(高位在前，低位在后)的顺序。
 */
+(Byte*)intToBytes2:(int) value
{
    Byte src[4];
    src[0] = (Byte) ((value>>24) & 0xFF);
    src[1] = (Byte) ((value>>16)& 0xFF);
    src[2] = (Byte) ((value>>8)&0xFF);
    src[3] = (Byte) (value & 0xFF);
    return src;
}


+(void)printfData2Byte:(NSData*)data and:(NSString *)head{
    Byte *buff = (Byte *)[data bytes];
    NSLog(@"------------%@",head);
    //printf("printfData2Byte---->>>>> %@:",head);
    for (auto i = 0; i<data.length; i++) {
        printf(" %02X", buff[i]);
    }
    printf("\r\n");
    
    NSLog(@"%hhu",buff[2]);
    
}

// 十六进制转换为普通字符串的。
+ (NSString *)stringFromHexString:(NSString *)hexString { //
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    NSLog(@"------字符串=======%@",unicodeString);
    return unicodeString;
    
    
}

//普通字符串转换为十六进制的
+ (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1){
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        }
        else{
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
        }
    }
    return hexStr; 
}
//将十进制转化为二进制,设置返回NSString 长度
+ (NSString *)decimalTOBinary:(uint16_t)tmpid backLength:(int)length
{
    NSString *a = @"";
    while (tmpid)
    {
        a = [[NSString stringWithFormat:@"%d",tmpid%2] stringByAppendingString:a];
        if (tmpid/2 < 1)
        {
            break;
        }
        tmpid = tmpid/2 ;
    }
    
    if (a.length <= length)
    {
        NSMutableString *b = [[NSMutableString alloc]init];;
        for (int i = 0; i < length - a.length; i++)
        {
            [b appendString:@"0"];
        }
        
        a = [b stringByAppendingString:a];
        
    }
    
    return a;
}
/**
 *  十字制转16进制
 *
 *  @param tmpid <#tmpid description#>
 *
 *  @return <#return value description#>
 */
+(NSString *)hexStringFromInt:(uint16_t)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    uint16_t ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break; 
            default: 
                nLetterValue = [NSString stringWithFormat:@"%u",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
        
    }
    return str;
}

//将16进制转化为二进制
+(NSString *)getBinaryByhex:(NSString *)hex
{
    NSMutableDictionary *hexDic = [[NSMutableDictionary alloc] init];
    
    hexDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    
    [hexDic setObject:@"0000" forKey:@"0"];
    
    [hexDic setObject:@"0001" forKey:@"1"];
    
    [hexDic setObject:@"0010" forKey:@"2"];
    
    [hexDic setObject:@"0011" forKey:@"3"];
    
    [hexDic setObject:@"0100" forKey:@"4"];
    
    [hexDic setObject:@"0101" forKey:@"5"];
    
    [hexDic setObject:@"0110" forKey:@"6"];
    
    [hexDic setObject:@"0111" forKey:@"7"];
    
    [hexDic setObject:@"1000" forKey:@"8"];
    
    [hexDic setObject:@"1001" forKey:@"9"];
    
    [hexDic setObject:@"1010" forKey:@"A"];
    
    [hexDic setObject:@"1011" forKey:@"B"];
    
    [hexDic setObject:@"1100" forKey:@"C"];
    
    [hexDic setObject:@"1101" forKey:@"D"];
    
    [hexDic setObject:@"1110" forKey:@"E"];
    
    [hexDic setObject:@"1111" forKey:@"F"];
    
    NSMutableString *binaryString=[[NSMutableString alloc] init];
    
    for (int i=0; i<[hex length]; i++) {
        
        NSRange rage;
        
        rage.length = 1;
        
        rage.location = i;
        
        NSString *key = [hex substringWithRange:rage];
        
        //NSLog(@"%@",[NSString stringWithFormat:@"%@",[hexDic objectForKey:key]]);
        
        binaryString = [NSString stringWithFormat:@"%@%@",binaryString,[NSString stringWithFormat:@"%@",[hexDic objectForKey:key]]];
        
    }
    
    NSLog(@"转化后的二进制为:%@",binaryString);
    
    return binaryString;
}
//十六进制数 转十进制数
+(int)TotexHex1:(NSString*)tmpid
{
    int int_ch;  ///两位16进制数转化后的10进制数
    unichar hex_char1 = [tmpid characterAtIndex:0]; ////两位16进制数中的第一位(高位*16)
    int int_ch1;
    if(hex_char1 >= '0' && hex_char1 <='9')
        int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
    else if(hex_char1 >= 'A' && hex_char1 <='F')
        int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
    else
        int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
    unichar hex_char2 = [tmpid characterAtIndex:1]; ///两位16进制数中的第二位(低位)
    int int_ch2;
    if(hex_char2 >= '0' && hex_char2 <='9')
        int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
    else if(hex_char2 >= 'A' && hex_char2 <='F')
        int_ch2 = (hex_char2-55); //// A 的Ascll - 65
    else
        int_ch2 = (hex_char2-87); //// a 的Ascll - 97
    int_ch = int_ch1+int_ch2;
    
    return int_ch;
}


+(NSData *) int2NSData:(int)value andB:(int)len {
    Byte ret[len];
    for(int i = 0; i < len; i++) {
        ret[i] = ((value >> 8 * i) & 0xff);
    }
    return [[NSData alloc] initWithBytes:ret length:len];
}
+(NSData *) int2HEX:(int)value andB:(int)len {
    Byte ret[len];
    for(int i = 0; i < len; i++) {
        ret[len-i-1] = ((value >> 8 * i) & 0xff);
    }
    return [[NSData alloc] initWithBytes:ret length:len];
}

+(NSData *) copyOf:(NSData *)buff and:(int)index and:(int)length{
    Byte *src = (Byte *)[buff bytes];
    Byte ret[length];
    for(int i = 0; i < length; i++) {
        ret[i] = src[i + index];
    }
    return [[NSData alloc] initWithBytes:ret length:length];
}

+(int) hex2Int:(Byte[])buf and:(int)idx and:(int)len{
    int ret = 0;
    
    int e = idx + len;
    for (int i = idx; i < e; ++i) {
        ret <<= 8;
        ret |= buf[i] & 0xFF;
    }
    return ret;
}

+(int) hex2Int2:(Byte[])buf and:(int)idx and:(int)len{
//    Byte *buff = buf;
//    printf("..........: \r\n");
//    for (auto i = 0; i<len; i++) {
//        printf(" %02X", buff[i]);
//    }
//    printf("\r\n");
    
    
    Byte tmp[len];
    for(int i = 0; i < len; i++) {
        tmp[i] = buf[idx + len - 1 - i];
        printf(" %02X", tmp[i]);
    }
    return [self hex2Int:tmp and:0 and:len];
}

+(long) revHex2Long:(NSData *)data{
    int len = data.length;
    Byte tmp[len];
    Byte *buf = (Byte *)[data bytes];
    for(int i = 0; i < len; i++) {
        tmp[i] = buf[len - 1 - i];
        printf(" %02X", tmp[i]);
    }
    long ret = 0;
    for(int i = 0; i < len; i++) {
        ret |= ((tmp[i] & 0xff) << (8 * i));
    }
    return ret;
}

//32位MD5加密大写
+ (NSString*)md532BitUpper:(NSString *)aSourceStr
{
    const char* cStr = [aSourceStr UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr,strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02X", digest[i]];
    return [result uppercaseString];
}

///// 手机号码的有效性判断

//检测是否是手机号码
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
              * 中国移动：China Mobile
              * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
    */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
              * 中国联通：China Unicom
              * 130,131,132,152,155,156,185,186
              */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
              * 中国电信：China Telecom
              * 133,1349,153,180,189
              */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
              * 大陆地区固话及小灵通
              * 区号：010,020,021,022,023,024,025,027,028,029
              * 号码：七位或八位
              */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}





@end
