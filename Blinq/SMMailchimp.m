//
//  SMMailchimp.m
//  Blinq
//
//  Created by zsk on 2016/12/26.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "SMMailchimp.h"
#import<CommonCrypto/CommonDigest.h>

@implementation SMMailchimp

+ (void)registerUserInfo:(NSString*)firstName lastName:(NSString*)lastName emailAddress:(NSString*)emailAddress{

    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *string = [NSString stringWithFormat:@"https://us14.api.mailchimp.com/3.0/lists/253aa1a78a/members/%@",[self md5:emailAddress]];
    
    NSURL *url = [[NSURL alloc]initWithString:string];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"PUT";
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSData *basicAuthCredentials = [[NSString stringWithFormat:@"%@:%@", @"s", @"fe50a539753c8f05c5bf899a3304e672-us14"] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64AuthCredentials = [basicAuthCredentials base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)0];
    [request setValue:[NSString stringWithFormat:@"Basic %@", base64AuthCredentials] forHTTPHeaderField:@"Authorization"];
    
    NSDictionary *ppp = @{@"email_address":emailAddress,
                          @"status_if_new":@"subscribed",
                          @"merge_fields":@{@"FNAME":firstName,
                                            @"LNAME":lastName}};
    
    [request setHTTPBody:[[self dictionaryToJson:ppp] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"data--%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        
        if (error) {
            NSLog(@"%@",error);
        }
    }];
    
    [task resume];
    
}

+ (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr,(CC_LONG)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

// NSData转dictonary
+(NSDictionary*)returnDictionaryWithDataPath:(NSData*)data
{
    //  NSData* data = [[NSMutableData alloc]initWithContentsOfFile:path]; 拿路径文件
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    NSDictionary* myDictionary = [unarchiver decodeObjectForKey:@"talkData"];
    [unarchiver finishDecoding];
    return myDictionary;
}

// 字典转字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
