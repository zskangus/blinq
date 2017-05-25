//
//  AlidayuManager.m
//  ssss
//
//  Created by zsk on 16/5/3.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "AlidayuManager.h"
#import "AFNetworking/AFHTTPSessionManager.h"
#import <CommonCrypto/CommonDigest.h>
#import "logMessage.h"
#import "SKConst.h"

typedef NS_ENUM(NSInteger,sendState){
    
    MessageDidNotSend,
    MessageSending
    
};

sendState messageSendState = MessageDidNotSend;

@implementation AlidayuManager

+ (void)sendMessageToContact:(NSString *)Tel andAreaCode:(NSString *)areaCode message:(NSString *)message address:(NSMutableDictionary *)address isSendSuccessful:(smsState)isSendSuccessful{
    
    __block BOOL sendState;
    
    NSString *latitude = address[@"latitude"];
    NSString *longtitude = address[@"longtitude"];
    NSString *FormattedAddressLines = address[@"FormattedAddressLines"];
    NSString *sms = [[NSString alloc]init];
    
    NSString *sos_location = NSLocalizedString(@"sos_sms_location", nil);
    
    NSString *language = NSLocalizedString(@"language", nil);
    
    NSString *type = [[NSString alloc]init];
    


    // 信息发送开关
    BOOL sendMessagePower = [SKUserDefaults boolForKey:@"sendMessagePower"];
    if (sendMessagePower == NO) {
        NSLog(@"不发送信息");
        return;
    }
    
    // 定位信息的开关，如果未关闭，则短信内容不附带地址
    BOOL locationPower = [SKUserDefaults boolForKey:@"locationPower"];
    
    locationPower = YES;
    
    // 用户的姓名
    NSString *name = [[NSString alloc]init];
    NSString *firstName = [SKUserDefaults objectForKey:@"firstName"];
    NSString *lastName = [SKUserDefaults objectForKey:@"lastName"];
    
    if (![self isBlankString:firstName] && ![self isBlankString:lastName]) {
        name = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
    }
    
    
    // 紧急求救的信息
    NSString *sosTextMessage = [SKUserDefaults objectForKey:@"sosTextMessage"];
//
//    if ([self isBlankString:sosTextMessage]) {
//
//        if ([self isBlankString:name]) {
//            // 如果没有内容则并且名字为空，默认如下
//            sosTextMessage = NSLocalizedString(@"sos_sms", nil);
//            sosTextMessage = [NSString stringWithFormat:@"%@,",NSLocalizedString(@"sos_sms", nil)];
//        }else{
//            sosTextMessage = [NSString stringWithFormat:@"%@ %@,",name,NSLocalizedString(@"sos_sms_have_name", nil)];
//        }
//        
//    }else{
//        if ([self isBlankString:name]) {
//            sosTextMessage = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"sos_sms", nil),sosTextMessage];
//        }else{
//            sosTextMessage = [NSString stringWithFormat:@"%@ %@:%@",name,NSLocalizedString(@"sos_sms_have_name", nil),sosTextMessage];
//        }
//    }
    
    
    sosTextMessage = [NSString stringWithFormat:@"You are %@'s emergency contact and they need your help or are in trouble. Please call them immediately to make sure this isn't a false alarm. If no one answers send help to the following location right away. This message was sent from Blinq's Smart Ring.",name];
    
    if ([self isChinese:sosTextMessage]) {//如果信息内容是中文
        type = @"unicode";
    }else{
        type = nil;
    }
    
    
    Tel = [NSString stringWithFormat:@"%@%@",areaCode,Tel];
    
    if ([language isEqualToString:@"中文"]) {
        NSLog(@"发送文字超链接");
        
        if (locationPower) {
            sms = [NSString stringWithFormat:@"【智能戒指】%@\n位置:(%@,%@)%@",sosTextMessage,latitude,longtitude,FormattedAddressLines];
        }else{
            sms = [NSString stringWithFormat:@"【智能戒指】%@",sosTextMessage];
        }

    }
    
    if ([language isEqualToString:@"English"] && [areaCode isEqualToString:@"86"]) {
        
        NSString *url = [NSString stringWithFormat:@"https://maps.google.cn/maps?q=%@,%@",latitude,longtitude];
        
        if (locationPower) {
            sms = [NSString stringWithFormat:@"[Ring]%@\nlocation:%@",sosTextMessage,url];
        }else{
            sms = [NSString stringWithFormat:@"[Ring]%@",sosTextMessage];
        }
        
        NSLog(@"-----生成的信息内容%@",sms);
    }
    
    if ([language isEqualToString:@"English"] && ![areaCode isEqualToString:@"86"]) {
        
        NSString *url = [NSString stringWithFormat:@"https://maps.google.com/maps?q=%@,%@",latitude,longtitude];
        
        if (locationPower) {
            sms = [NSString stringWithFormat:@"[SMART RING]%@\n%@",sosTextMessage,url];
        }else{
            sms = [NSString stringWithFormat:@"[SMART RING]%@",sosTextMessage];
        }
        
        NSLog(@"发送谷歌连接地图");
    }
    
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"api_key"] = @"07965ca5";
    parameters[@"api_secret"] = @"24d5cb6fadab3b9a";
    parameters[@"to"] = Tel;
    parameters[@"from"] = @"12016057142";
    parameters[@"text"] = sms;
    parameters[@"type"] = type;
    
    NSString *url = @"https://rest.nexmo.com/sms/json?";

    
    if (messageSendState == MessageDidNotSend) {
        
        messageSendState = MessageSending;
        
        AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc]init];
        [sessionManager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"JSON: %@", responseObject);
            
            messageSendState = MessageDidNotSend;
            
            NSDictionary *dic =[[responseObject objectForKey:@"messages"]lastObject];
            NSLog(@"status:%@+++++",dic[@"status"]);
                    
            if ([dic[@"status"]intValue]==0) {
                
                sendState = YES;
                
            }else{
                sendState = NO;
            }
            
            NSLog(@"短信是否发送成功值：%@",sendState?@"YES":@"NO");
            
            isSendSuccessful(sendState);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error%@",error);
            
            sendState = NO;
            
            isSendSuccessful(sendState);
            
            messageSendState = MessageDidNotSend;
            
        }];
        
        NSLog(@"parameters:$$$$$$$$$$======%@", parameters);
        
    }
    


}


+ (NSString *)md5HexDigest:(NSString*)input
{
    const char* cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr,strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02X", digest[i]];
    
    return [result uppercaseString];
}

+ (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

+ (BOOL)isChinese:(NSString *)phoneNum
{
    // 只需要不是中文即可
    NSString *regex = @".{0,}[\u4E00-\u9FA5].{0,}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self matches %@",regex];
    BOOL res = [predicate evaluateWithObject:phoneNum];
    if (res == TRUE) {
        //NSLog(@"中文");
        return YES;
    }
    else
    {
        //NSLog(@"英文");
        return NO;
    }
}


//阿里大鱼的发送方法-带地址
+ (void)alidayMessageToContact:(NSString *)Tel address:(NSMutableDictionary *)address isSendSuccessful:(smsState)isSendSuccessful{
    
    __block BOOL sendState;
    
    NSString *latitude = address[@"latitude"];
    NSString *longtitude = address[@"longtitude"];
    NSString *FormattedAddressLines = address[@"FormattedAddressLines"];
    FormattedAddressLines = [FormattedAddressLines stringByReplacingOccurrencesOfString:@"'" withString:@""];
    
    NSString *language = NSLocalizedString(@"language", nil);
    
    
    // 信息发送开关
    BOOL sendMessagePower = [SKUserDefaults boolForKey:@"sendMessagePower"];
    if (sendMessagePower == NO) {
        NSLog(@"不发送信息");
        return;
    }
    
    // 定位信息的开关，如果未关闭，则短信内容不附带地址
    BOOL locationPower = [SKUserDefaults boolForKey:@"locationPower"];
    
    locationPower = YES;
    
    // 紧急求救的信息
    NSString *sosTextMessage = [SKUserDefaults objectForKey:@"sosTextMessage"];
    
    if ([self isBlankString:sosTextMessage]) {
        // 如果没有内容则默认如下
        sosTextMessage = @"";
    }else{
        sosTextMessage = [NSString stringWithFormat:@":%@",sosTextMessage];
    }
    
    
    if (messageSendState == MessageDidNotSend) {
        
        messageSendState = MessageSending;
        
        NSDateFormatter *formatters =[[NSDateFormatter alloc] init];
        [formatters setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSString *currentTime = [formatters stringFromDate:[NSDate date]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        parameters[@"app_key"] = @"23384526";
        parameters[@"format"] = @"json";
        parameters[@"method"] = @"alibaba.aliqin.fc.sms.num.send";
        parameters[@"partner_id"] = @"top-apitools";
        parameters[@"rec_num"] = Tel;
        parameters[@"sign_method"] = @"md5";
        parameters[@"sms_free_sign_name"] = @"智能戒指";
        
        
        // 用户的姓名
        NSString *name = [[NSString alloc]init];
        NSString *firstName = [SKUserDefaults objectForKey:@"firstName"];
        NSString *lastName = [SKUserDefaults objectForKey:@"lastName"];
        
        if (![self isBlankString:firstName] && ![self isBlankString:lastName]) {
            name = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
        }
        
        NSString *address = [NSString stringWithFormat:@":(%@,%@)%@",latitude,longtitude,FormattedAddressLines];
        
        
        if ([language isEqualToString:@"中文"]) {

            if (locationPower) {
                parameters[@"sms_param"] = [NSString stringWithFormat:@"{name:'%@',message:'%@,位置%@'}",name,sosTextMessage,address];

                parameters[@"sms_template_code"] = @"SMS_18020027";
            }else{
                parameters[@"sms_param"] = [NSString stringWithFormat:@"{name:'%@',message:'%@'}",name,sosTextMessage];
                parameters[@"sms_template_code"] = @"SMS_18020027";
            }
            
        }else{
            
            if (locationPower) {
                parameters[@"sms_param"] = [NSString stringWithFormat:@"{name:'%@ ',message:'%@,location%@'}",name,sosTextMessage,address];
                parameters[@"sms_template_code"] = @"SMS_20185017";
            }else{
                parameters[@"sms_param"] = [NSString stringWithFormat:@"{name:'%@ ',message:'%@'}",name,sosTextMessage];
                parameters[@"sms_template_code"] = @"SMS_20185017";
            }
            
        }
        
    

        parameters[@"sms_type"] = @"normal";
        parameters[@"timestamp"] = currentTime;
        parameters[@"v"] = @"2.0";
        
        // 1.排序
        NSArray *keys = [[parameters allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
            return [obj1 compare:obj2 options:NSNumericSearch];
        }];
        NSLog(@"keys:%@,values:%@",keys,parameters);
        
        // 2.拼接参数名与参数值
        NSMutableString *string = [NSMutableString string];
        
        [string appendString:@"9fcffc5fb645bb7a7bd463588f3a6113"];
        
        for (int i = 0 ; i<keys.count ; i++ ) {
            [string appendString:keys[i]];
            [string appendString:parameters[keys[i]]];
        }
        
        [string appendString:@"9fcffc5fb645bb7a7bd463588f3a6113"];
        
        NSLog(@"-------%@",string);
        NSString *sign = [self md5HexDigest:string];
        NSLog(@"+++++++%@",sign);
        
        parameters[@"sign"] = sign;
        
        NSString *url = @"http://gw.api.taobao.com/router/rest";
        AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc]init];
        [sessionManager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"JSON: %@", responseObject);
            messageSendState = MessageDidNotSend;
            NSDictionary *dic =[[responseObject objectForKey:@"result"]lastObject];
            NSLog(@"status:%@+++++",dic[@"status"]);
            
            if ([dic[@"err_code"]intValue]==0) {
                
                sendState = YES;
                
            }else{
                sendState = NO;
            }

            isSendSuccessful(sendState);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error%@",error);
            messageSendState = MessageDidNotSend;
            sendState = NO;
            isSendSuccessful(sendState);
            
        }];
        
        
        
        NSLog(@"parameters:$$$$$$$$$$======%@", parameters);

        
        
    }
    


}

@end
