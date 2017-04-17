//
//  SMSosContactTool.m
//  Blinq
//
//  Created by zsk on 16/9/28.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "SMSosContactTool.h"
#import <FMDB.h>

static FMDatabase *_db;

@implementation SMSosContactTool

+(void)initialize{
    
    // 打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"SosContactInfo"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
    // 创建表
    // executeQuery:查询数据
    //[self.db executeQuery:<#(NSString *), ...#>];
    
    // executeUpdate:除查询数据以外的其他操作（增，删，改）
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_sosContact (id integer PRIMARY KEY,name text NOT NULL UNIQUE,phoneNum text,photo blob,countryCode text,countriesName text)"];
}

// 增加
+ (void)addContact:(SMContactModel *)contact{
    
    [_db executeUpdate:@"INSERT INTO t_sosContact(name, phoneNum, photo, countryCode, countriesName) VALUES (?,?,?,?,?)",contact.name,contact.phoneNum,contact.photo,contact.countryCode,contact.countriesName];
}

+ (void)deleteContactData{
    NSLog(@"删除保存的VIP联系人信息");
    [_db executeUpdate:@"delete from t_sosContact"];
}

// 删除
+ (void)deleteContact:(NSString *)name{
    [_db executeUpdate:@"DELETE FROM t_sosContact WHERE name = ? ",name];
    
    NSLog(@"即将要删除的名字%@",name);
}

// 修改
+ (void)updataContact:(SMContactModel *)contact{
    [_db executeUpdate:@"update t_sosContact set countryCode = ? , countriesName = ? WHERE name = ? ",contact.countryCode,contact.countriesName,contact.name];
}

// 查看
+ (NSArray *)contacts{
    
    // 得到结果集
    FMResultSet *set = [_db executeQuery:@"SELECT * FROM t_sosContact"];
    
    NSMutableArray *contacts = [NSMutableArray array];
    int i = 0;
    // 不断往下取数据
    while (set.next) {
        i++;
        SMContactModel *contact = [[SMContactModel alloc]init];
        
        // 获得当前所指向的数据
        contact.name = [set stringForColumn:@"name"];
        contact.phoneNum = [set stringForColumn:@"phoneNum"];
        contact.photo = [set dataForColumn:@"photo"];
        contact.countryCode = [set stringForColumn:@"countryCode"];
        contact.countriesName = [set stringForColumn:@"countriesName"];
        NSLog(@"%d:%@",i,[set stringForColumn:@"name"]);
        NSLog(@"%d:%@",i,[set stringForColumn:@"phoneNum"]);
        NSLog(@"%d:%@",i,[set stringForColumn:@"countryCode"]);
        [contacts addObject:contact];
        
    }
    return contacts;
}


@end
