//
//  SMDateUtil.m
//  cjj
//
//  Created by 聂晶 on 15/11/1.
//  Copyright © 2015年 cjj. All rights reserved.
//

#import "SMDateUtil.h"

@implementation SMDateUtil

+ (NSString *)dateToString:(NSDate *)date{
    if (date == nil) {
        return nil;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter stringFromDate:date];
}

+ (NSString *)dateTimeToString:(NSDate *)dateTime{
    if (dateTime == nil) {
        return nil;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [formatter stringFromDate:dateTime];
}

@end
