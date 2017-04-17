//
//  SMAppTool.h
//  Blinq
//
//  Created by zsk on 16/5/18.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMAppModel.h"

@interface SMAppTool : NSObject

+ (void)addApp:(SMAppModel*)app;

// 更新APP参数
+ (void)updataApp:(SMAppModel*)app;

+ (void)deleteApp:(SMAppModel*)app;

// 删除数据
+(void)deleteTableData;

// 修改颜色
+ (void)updataApp:(NSString*)name color:(NSInteger)color;

// 修改开关
+ (void)updataApp:(NSString*)name power:(BOOL)power;

+ (NSArray*)Apps;


// 这个类方法是获取本地已安装的APP
+(NSArray *)getApps;

@end
