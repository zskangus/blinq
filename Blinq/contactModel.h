//
//  contactModel.h
//  Blinq
//
//  Created by zsk on 16/4/10.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface contactModel : NSObject

// 名字
@property(nonatomic,copy)NSString *givenName;

// 姓
@property(nonatomic,copy)NSString *TfamilyName;

// 手机号码
@property(nonatomic,copy)NSString *phomeNumber;

// 图片数据
@property(nonatomic,strong)NSData *imageData;

@end
