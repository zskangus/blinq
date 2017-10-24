//
//  NSDate+Tool.m
//  demo
//
//  Created by zsk on 2017/8/14.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import "NSDate+Tool.h"

@implementation NSDate (Tool)

+ (NSDate *)getEarlyMorningTime{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    return [calendar dateFromComponents:components];
}

+ (NSDate *)getStartTimeWithDate:(NSDate*)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    return [calendar dateFromComponents:components];
}

+ (NSString*)stringFormDate:(NSDate*)date withDateFormat:(NSString*)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:date];
}

+ (NSDate*)dateFormString:(NSString*)dateString withDateFormat:(NSString*)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter dateFromString:dateString];
}

@end
