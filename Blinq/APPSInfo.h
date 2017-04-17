//
//  APPSInfo.h
//  cjj
//
//  Created by 聂晶 on 16/3/28.
//  Copyright © 2016年 cjj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPSInfo : NSObject

@property BOOL flag;
/**
 *  标题
 */
@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *icon;

@property (nonatomic,copy) NSString *analytics;
/**
 *  包名
 */
@property(nonatomic,copy) NSString *identifiers;

/**
 *  name
 */
@property(nonatomic,copy) NSString *name;

/**
 *  scheme
 */
@property(nonatomic,copy) NSString *schemeName;

@property  NSInteger appId;

@property  NSInteger catId;




/**
 *  通过字典来初始化模型对象
 *
 *  @param dic  字典对象
 *
 *  @return 已经初始化完毕的模型对象
 */
/*
 instancetype的作用，就是使那些非关联返回类型的方法返回所在类的类型！
 好处能够确定对象的类型，能够帮助编译器更好的为我们定位代码书写问题
 instanchetype和id的对比
 1、相同点
 都可以作为方法的返回类型
 
 2、不同点
 ①instancetype可以返回和方法所在类相同类型的对象，id只能返回未知类型的对象；
 
 ②instancetype只能作为返回值，不能像id那样作为参数，比如下面的写法：
 */
-(instancetype)initWithDict:(NSDictionary *)dict;

+(instancetype) appWithDict:(NSDictionary *)dict;
@end
