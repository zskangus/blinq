//
//  SMAppModel.h
//  Blinq
//
//  Created by zsk on 16/5/18.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMAppModel : NSObject

@property(nonatomic,strong)NSString *icon;
@property(nonatomic,assign)BOOL flag;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,assign)NSInteger colorId;
@property(nonatomic,assign)NSInteger methodId;
@property(nonatomic,assign)NSInteger appId;
@property(nonatomic,assign)NSInteger catId;
@property(nonatomic,copy) NSString *identifiers;
@property(nonatomic,assign)NSInteger Interval;
@property(nonatomic,assign)NSInteger Count;
@property(nonatomic,assign)NSInteger RemindCount;
@property(nonatomic,assign)UInt64 config;

@end
