//
//  SMMailchimp.h
//  Blinq
//
//  Created by zsk on 2016/12/26.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMMailchimp : NSObject

+ (void)registerUserInfo:(NSString*)firstName lastName:(NSString*)lastName emailAddress:(NSString*)emailAddress;

@end
