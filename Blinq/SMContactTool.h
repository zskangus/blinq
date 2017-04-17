//
//  SMContactTool.h
//  Blinq
//
//  Created by zsk on 16/5/17.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMContactModel.h"

@interface SMContactTool : NSObject

+ (void)addContact:(SMContactModel*)contact;

// 删除数据
+ (void)deleteContactData;

+ (void)deleteContact:(NSString*)name;

+ (void)updataContact:(NSString*)name color:(NSString*)color;

+ (NSArray*)contacts;

@end
