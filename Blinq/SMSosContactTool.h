//
//  SMSosContactTool.h
//  Blinq
//
//  Created by zsk on 16/9/28.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMContactModel.h"

@interface SMSosContactTool : NSObject

+ (void)addContact:(SMContactModel*)contact;

// 删除数据
+ (void)deleteContactData;

+ (void)deleteContact:(NSString*)name;

// 修改
+ (void)updataContact:(SMContactModel *)contact;

+ (NSArray*)contacts;

@end
