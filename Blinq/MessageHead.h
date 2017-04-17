//
//  MessageHead.h
//  cjj
//
//  Copyright © 2015年 cjj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageMacro.h"


@interface MessageHead : NSObject

@property(nonatomic,assign)NSInteger version;

@property(nonatomic,assign)NSInteger service_type;

@property(nonatomic,assign)NSInteger length;

@property(nonatomic,assign)NSInteger identification;

@property(nonatomic,assign)NSInteger flag_and_offset;

@property(nonatomic,assign)NSInteger mod_id;

@property(nonatomic,assign)NSInteger check_sum;

-(NSData *) headBytes2NSData;

@end
