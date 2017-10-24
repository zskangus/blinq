//
//  SMStepModel.h
//  Blinq
//
//  Created by zsk on 2017/8/1.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMStepModel : NSObject

@property(nonatomic,copy)NSString *date;

@property(nonatomic,assign)NSInteger steps;

@property(nonatomic,assign)NSInteger targetSteps;

@property(nonatomic,copy)NSString *calories;

@property(nonatomic,copy)NSString *distance;

@property(nonatomic,copy)NSString *writeDate;

@property(nonatomic,copy)NSString *spare;

@property(nonatomic,copy)NSString *spare1;

@property(nonatomic,assign)NSInteger year;

@property(nonatomic,assign)NSInteger month;

@property(nonatomic,assign)NSInteger day;


@end
