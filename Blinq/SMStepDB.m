//
//  SMStepDB.m
//  Blinq
//
//  Created by zsk on 2017/8/1.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import "SMStepDB.h"
#import <FMDB.h>

static FMDatabase *_stepsDb;

@implementation SMStepDB

+(void)initialize{
    
    // 打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"stepsInfo"];
    _stepsDb = [FMDatabase databaseWithPath:path];
    
    [_stepsDb open];
    
    // 创建表
    // executeQuery:查询数据
    //[self.db executeQuery:<#(NSString *), ...#>];
    
    
    [_stepsDb executeUpdate:@"CREATE TABLE IF NOT EXISTS t_steps (id integer PRIMARY KEY,date text NOT NULL UNIQUE,year integer,month integer,day integer,steps integer,targetSteps integer,calories text,distance text,writeDate text,spare text,spare1 text)"];
}

+(void)addStepsInfo:(SMStepModel *)info{
    
    [_stepsDb executeUpdate:@"INSERT INTO t_steps(date,year,month,day,steps,targetSteps,calories,distance,writeDate,spare,spare1) VALUES (?,?,?,?,?,?,?,?,?,?,?)",
     info.date,
     [NSNumber numberWithInteger:info.year],
     [NSNumber numberWithInteger:info.month],
     [NSNumber numberWithInteger:info.day],
     [NSNumber numberWithInteger:info.steps],
     [NSNumber numberWithInteger:info.targetSteps],
     info.calories,
     info.distance,
     info.writeDate,
     info.spare,
     info.spare1
     ];
    

}

// 更新
+ (void)updataStepsInfo:(SMStepModel *)info{
    [_stepsDb executeUpdate:@"update t_steps set steps = ? WHERE date = ? ",[NSNumber numberWithInteger:info.steps],info.date];
    [_stepsDb executeUpdate:@"update t_steps set targetSteps = ? WHERE date = ? ",[NSNumber numberWithInteger:info.targetSteps],info.date];

}


+(void)deleteAllData{
    NSLog(@"删除保存的应用通知的配置信息");
    [_stepsDb executeUpdate:@"delete from t_steps"];
}

// 查看
+ (NSArray *)stepInfos{
    
    // 得到结果集
    FMResultSet *set = [_stepsDb executeQuery:@"SELECT * FROM t_steps"];
    
    NSMutableArray *infos = [NSMutableArray array];
    
    
    int i = 0;
    // 不断往下取数据
    while (set.next) {
        i++;
        SMStepModel *info = [[SMStepModel alloc]init];
        
        info.date = [set stringForColumn:@"date"];
        info.year = [set intForColumn:@"year"];
        info.month = [set intForColumn:@"month"];
        info.day = [set intForColumn:@"day"];
        info.steps = [set intForColumn:@"steps"];
        info.targetSteps = [set intForColumn:@"targetSteps"];
        info.calories = [set stringForColumn:@"calories"];
        info.distance = [set stringForColumn:@"distance"];
        info.writeDate = [set stringForColumn:@"writeDate"];
        info.spare = [set stringForColumn:@"spare"];
        info.spare1 = [set stringForColumn:@"spare1"];
        [infos addObject:info];
        
        
        //NSLog(@"--%@--%ld--%ld--%ld--%ld--",info.date,info.year,info.month,info.day,info.steps);
    }
    
    NSArray *sortedArray = [infos sortedArrayUsingComparator:^NSComparisonResult(SMStepModel *p1, SMStepModel *p2){
        return [p1.date compare:p2.date];
    }];
    
    return sortedArray;
}

+ (BOOL)checkInfoWith:(SMStepModel*)stepInfo{
    
    BOOL boolValue = NO;
    
    FMResultSet *rs =[_stepsDb executeQuery:@"SELECT COUNT(date) AS date FROM t_steps WHERE date = ?",stepInfo.date];
    while ([rs next]) {
        NSInteger count = [rs intForColumn:@"date"];
        if (count > 0) {
            //存在
            NSLog(@"纯在");
            boolValue = YES;
        }
        else
        {
            //不存在
            NSLog(@"bu chunzai ");
            boolValue = NO;
        }
    }
    
    return boolValue;
}

@end

