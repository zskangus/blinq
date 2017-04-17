//
//  Utils.h
//  cjj
//
//  Created by 聂晶 on 15/11/8.
//  Copyright © 2015年 cjj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonCrypto/CommonDigest.h"


@interface Utils : NSObject

+ (void)setToKenNSData:(NSData *)token;
+ (NSData *)getToKenNSData;

/**
 *  MD5散列 16位
 *
 *  @param str <#str description#>
 *
 *  @return NSData
 */
+ (NSData *)md5_16:(NSString *)str;
/**
 *  将NSData解析成Bytes并打印
 *
 *  @param data <#data description#>
 */
+(void)printfData2Byte:(NSData*)data;
/**
 *  十字制转16进制
 *
 *  @param tmpid <#tmpid description#>
 *
 *  @return <#return value description#>
 */
+(NSString *)hexStringFromInt:(uint16_t)tmpid;
/**
 *  16进制转二进制
 *
 *  @param hex <#hex description#>
 *
 *  @return <#return value description#>
 */
+(NSString *)getBinaryByhex:(NSString *)hex;

//普通字符串转换为十六进制的
+ (NSString *)hexStringFromString:(NSString *)string;

/**
 *  十六进制数 转十进制数
 *
 */
+(int)TotexHex1:(NSString*)tmpid;

+(void)printfData2Byte:(NSData*)data and:(NSString *)head;


+(NSData *) int2NSData:(int)value andB:(int)len;

+(NSData *) int2HEX:(int)value andB:(int)len;

+(NSData *) copyOf:(NSData *)src and:(int)index and:(int)length;

+(int) hex2Int:(Byte[])buf and:(int)idx and:(int)len;

+(int) hex2Int2:(Byte[])buf and:(int)idx and:(int)len;

+(long) revHex2Long:(NSData *)buf;

+ (NSString*)md532BitUpper:(NSString *)aSourceStr;
//检测是否是手机号码
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
@end
