//
//  NSDate+Tool.h
//  demo
//
//  Created by zsk on 2017/8/14.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Tool)

+ (NSDate*)getEarlyMorningTime;
+ (NSDate *)getStartTimeWithDate:(NSDate*)date;

// @"yyyy-MM-dd HH:mm:ss"
+ (NSString*)stringFormDate:(NSDate*)date withDateFormat:(NSString*)format;
+ (NSDate*)dateFormString:(NSString*)dateString withDateFormat:(NSString*)format;

@end
