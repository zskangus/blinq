//
//  SMHeadDataModel.h
//  Blinq
//
//  Created by zsk on 2016/12/1.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMHeadDataModel : NSObject

@property(nonatomic,assign)NSInteger version;

@property(nonatomic,assign)NSInteger service_type;

@property(nonatomic,assign)NSInteger length;

@property(nonatomic,assign)NSInteger identification;

@property(nonatomic,assign)NSInteger flag_and_offset;

@property(nonatomic,assign)NSInteger modId;

@property(nonatomic,assign)NSInteger check_sum;

-(NSData *)getHeadData;

@end
