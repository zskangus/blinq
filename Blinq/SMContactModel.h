//
//  SMContactModel.h
//  Blinq
//
//  Created by zsk on 16/5/17.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMContactModel : NSObject

// 名字
@property(nonatomic,strong)NSString *name;

// 姓
@property(nonatomic,strong)NSString *familyName;

// 名
@property(nonatomic,strong)NSString *givenName;

// 公司名
@property(nonatomic,strong)NSString *organizationName;

// 电话
@property(nonatomic,strong)NSString *phoneNum;

// 头像
@property(nonatomic,strong)NSData *photo;

// 区号
@property(nonatomic,strong)NSString *countryCode;

// 国家名
@property(nonatomic,strong)NSString *countriesName;

// 圈颜色
@property(nonatomic,strong)NSString *circleColor;

@end
