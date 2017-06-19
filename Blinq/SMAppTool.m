//
//  SMAppTool.m
//  Blinq
//
//  Created by zsk on 16/5/18.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "SMAppTool.h"
#import <FMDB.h>
#import <UIKit/UIKit.h>


static FMDatabase *_appDb;

@implementation SMAppTool

+(void)initialize{
    
    // 打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"appConfigInfo"];
    _appDb = [FMDatabase databaseWithPath:path];
    [_appDb open];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    
    // 创建表
    // executeQuery:查询数据
    //[self.db executeQuery:<#(NSString *), ...#>];
    
    [_appDb executeUpdate:@"CREATE TABLE IF NOT EXISTS t_app (id integer PRIMARY KEY,title text NOT NULL UNIQUE,identifiers text,colorId integer,methodId integer,appId integer,catId integer,Interval integer,Count integer,RemindCount integer,config blob,flag integer)"];
}

+(void)addApp:(SMAppModel *)app{
    
    UInt64 config = app.config;
    
    [_appDb executeUpdate:@"INSERT INTO t_app(title,identifiers,colorId,methodId,appId,catId,Interval,Count,RemindCount,config,flag) VALUES (?,?,?,?,?,?,?,?,?,?,?)",
     app.title,app.identifiers,
     [NSNumber numberWithInteger:app.colorId],
     [NSNumber numberWithInteger:app.methodId],
     [NSNumber numberWithInteger:app.appId],
     [NSNumber numberWithInteger:app.catId],
     [NSNumber numberWithInteger:app.Interval],
     [NSNumber numberWithInteger:app.Count],
     [NSNumber numberWithInteger:app.RemindCount],
     [NSData dataWithBytes:&config length:sizeof(config)],
     [NSNumber numberWithInteger:app.flag]
     ];
}

+(void)deleteApp:(SMAppModel *)app{
    
    [_appDb executeUpdate:@"delete from t_app WHERE title = ? ",app.title];
}

+(void)deleteTableData{
    NSLog(@"删除保存的应用通知的配置信息");
    [_appDb executeUpdate:@"delete from t_app"];
}

// 更新APP参数
+ (void)updataApp:(SMAppModel*)app{
    
    UInt64 config = app.config;

    [_appDb executeUpdate:@"update t_app set colorId = ? , methodId = ? , Interval = ? , Count = ? , RemindCount = ? , config = ? , flag = ? WHERE title = ? ",
    [NSNumber numberWithInteger:app.colorId],
    [NSNumber numberWithInteger:app.methodId],
    [NSNumber numberWithInteger:app.Interval],
    [NSNumber numberWithInteger:app.Count],
    [NSNumber numberWithInteger:app.RemindCount],
    [NSData dataWithBytes:&config length:sizeof(config)],
    [NSNumber numberWithInteger:app.flag],
     app.title
     ];
}

// 修改颜色
+ (void)updataApp:(NSString*)name color:(NSInteger)color{
    [_appDb executeUpdate:@"update t_app set colorId = ? WHERE title = ? ",[NSNumber numberWithInteger:color],name];
}

// 修改开关
+ (void)updataApp:(NSString *)name power:(BOOL)power{
    [_appDb executeUpdate:@"update t_app set flag = ? WHERE title = ? ",[NSNumber numberWithInteger:power],name];
}

// 查看
+ (NSArray *)Apps{
    
    // 得到结果集
    FMResultSet *set = [_appDb executeQuery:@"SELECT * FROM t_app"];
    
    NSMutableArray *apps = [NSMutableArray array];
                           
    NSLog(@"开始获取保存的应用数据");
    int i = 0;
    // 不断往下取数据
    while (set.next) {
        i++;
        SMAppModel *app = [[SMAppModel alloc]init];
        
        app.title = [set stringForColumn:@"title"];
        app.identifiers =[set stringForColumn:@"identifiers"];
        app.colorId = [set intForColumn:@"colorId"];
        app.methodId = [set intForColumn:@"methodId"];
        app.appId = [set intForColumn:@"appId"];
        app.catId = [set intForColumn:@"catId"];
        app.Interval = [set intForColumn:@"Interval"];
        app.Count = [set intForColumn:@"Count"];
        app.RemindCount = [set intForColumn:@"RemindCount"];
        
        NSData *configData = [set dataForColumn:@"config"];
        app.config = *(UInt64 *)[configData bytes];;
        app.flag = [set boolForColumn:@"flag"];
        
        
        [apps addObject:app];
    }
    return apps;
}

+(NSArray *)getApps{
    
    // 获得plist的全路径
    NSString *path=[[NSBundle mainBundle]pathForResource:@"app.plist" ofType:nil];
    
    //加载数组
    NSArray *dicArray=[NSArray arrayWithContentsOfFile:path];
    
    //将dicArray里面的所有字典转成模型对象，放到新的数组中。
    NSMutableArray *appArray=[NSMutableArray array];
    for (NSDictionary *dict in dicArray) {
        
        NSString *string = [NSString stringWithFormat:@"%@://",dict[@"SchemeName"]];
        
        // 判断查找已安装的应用
        if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:string]]){
            SMAppModel *app = [[SMAppModel alloc]init];
            
            app.title = dict[@"Title"];
            app.identifiers = dict[@"Identifiers"];
            app.flag = false;
            app.appId = [dict[@"appId"]intValue];
            app.catId = [dict[@"catId"]intValue];
            app.colorId = 0;
            app.methodId = 0;
            
            [appArray addObject:app];
            
            NSLog(@"检测到本机安装的应用:%@",app.title);
        }
    }
    return appArray;
}


@end
