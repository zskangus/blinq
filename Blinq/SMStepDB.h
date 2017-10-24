//
//  SMStepDB.h
//  Blinq
//
//  Created by zsk on 2017/8/1.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMStepModel.h"

@interface SMStepDB : NSObject

+(void)addStepsInfo:(SMStepModel *)info;

+ (void)updataStepsInfo:(SMStepModel *)info;

+(void)deleteAllData;

// 查看
+ (NSArray *)stepInfos;

+ (BOOL)checkInfoWith:(SMStepModel*)stepInfo;

@end
