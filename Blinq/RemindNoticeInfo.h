//
//  RemindNotice.h
//  cjj
//
//  Created by 聂晶 on 15/12/4.
//  Copyright © 2015年 cjj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemindNoticeInfo : NSObject <NSCoding>

@property NSString* icon;
@property BOOL flag;
@property(nonatomic,strong) NSString* title;
@property NSInteger colorId;
@property NSInteger methodId;
@property NSInteger appId;
@property NSInteger catId;

@property NSInteger Interval;
@property NSInteger Count;
@property NSInteger RemindCount;
@property UInt64 config;


//-(BOOL) getMethod;
//-(Byte) getColor;

+(RemindNoticeInfo *) find:(NSString *)icon;

@end
