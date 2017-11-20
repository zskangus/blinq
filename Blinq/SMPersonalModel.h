//
//  SMPersonalModel.h
//  SmartRing
//
//  Created by zsk on 2017/7/5.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMPersonalModel : NSObject

// 名字
@property(nonatomic,strong)NSString *name;

// 姓
@property(nonatomic,strong)NSString *familyName;

// 名
@property(nonatomic,strong)NSString *givenName;

// 性别
@property(nonatomic,assign)BOOL sex;

@property(nonatomic,strong)NSString *birthday;

// 年龄
@property(nonatomic,assign)NSInteger age;

//@property(nonatomic,copy)NSString *heightString;
@property(nonatomic,strong)NSDictionary *heightDic;

@property(nonatomic,assign)NSInteger heightRow;

@property(nonatomic,assign)NSInteger heightComponent;

@property(nonatomic,assign)double weight;

//@property(nonatomic,copy)NSString *weightString;
@property(nonatomic,copy)NSDictionary *weightDic;

@property(nonatomic,assign)NSInteger weightRow;

@property(nonatomic,assign)NSInteger weightComponent;

// 公司名
@property(nonatomic,strong)NSString *organizationName;

// 电话
@property(nonatomic,strong)NSString *phoneNumber;

// 相片
@property(nonatomic,strong)NSData *photo;

// 区号
@property(nonatomic,strong)NSString *countryCode;

// 国家名
@property(nonatomic,strong)NSString *countryName;

// 颜色
@property(nonatomic,assign)NSInteger colorId;

@end
