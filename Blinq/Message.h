//
//  Message.h
//  cjj
//  Copyright © 2015年 cjj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonCrypto/CommonDigest.h"
#import "AppConstant.h"
#import "MessageHead.h"
#import "Utils.h"

@interface Message : NSObject

@property MessageHead *head;

@property(nonatomic, strong) NSData *body;

@property int crc;

-(NSData *)build:(NSInteger)modId and:(NSData *)body;

-(NSData *)bytes2NSData;

-(NSData *)md5_16:(NSString *)str;

-(Message *)parseMessage:(NSData *)data;

@end
