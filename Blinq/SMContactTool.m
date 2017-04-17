//
//  SMContactTool.m
//  Blinq
//
//  Created by zsk on 16/5/17.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "SMContactTool.h"
#import <FMDB.h>

static FMDatabase *_db;

@implementation SMContactTool

+(void)initialize{
    
    // 打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"contactInfo1.0"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
    // 创建表
    // executeQuery:查询数据
    //[self.db executeQuery:<#(NSString *), ...#>];
    
    // executeUpdate:除查询数据以外的其他操作（增，删，改）
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_contact (id integer PRIMARY KEY,name text NOT NULL UNIQUE,phoneNum text,photo blob,circleColor text,familyName text,givenName text,organizationName text)"];
}

// 增加
+ (void)addContact:(SMContactModel *)contact{
    
    [_db executeUpdate:@"INSERT INTO t_contact(name, phoneNum, photo, circleColor,familyName,givenName,organizationName) VALUES (?,?,?,?,?,?,?)",contact.name,contact.phoneNum,contact.photo,contact.circleColor,contact.familyName,contact.givenName,contact.organizationName];
}

+ (void)deleteContactData{
    NSLog(@"删除保存的VIP联系人信息");
    [_db executeUpdate:@"delete from t_contact"];
}

// 删除
+ (void)deleteContact:(NSString *)name{
    [_db executeUpdate:@"DELETE FROM t_contact WHERE name = ? ",name];
    
    NSLog(@"即将要删除的名字%@",name);
}

// 修改
+ (void)updataContact:(NSString*)name color:(NSString*)color{
    [_db executeUpdate:@"update t_contact set circleColor = ? WHERE name = ? ",color,name];
}

// 查看
+ (NSArray *)contacts{
    
    // 得到结果集
    FMResultSet *set = [_db executeQuery:@"SELECT * FROM t_contact"];
    
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
        contact.circleColor = [set stringForColumn:@"circleColor"];
        contact.familyName = [set stringForColumn:@"familyName"];
        contact.givenName = [set stringForColumn:@"givenName"];
        contact.organizationName = [set stringForColumn:@"organizationName"];
        NSLog(@"%d:%@",i,[set stringForColumn:@"name"]);
        [contacts addObject:contact];
        
    }
    return contacts;
}




@end
