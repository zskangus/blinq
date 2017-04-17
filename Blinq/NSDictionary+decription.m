//
//  NSDictionary+decription.m
//  CoreLocation
//
//  Created by zsk on 16/7/29.
//  Copyright © 2016年 Kenshin Cui. All rights reserved.
//

#import "NSDictionary+decription.h"

@implementation NSDictionary (decription)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSArray *allKeys = [self allKeys];
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"{\t\n "];
    for (NSString *key in allKeys) {
        id value= self[key];
        [str appendFormat:@"\t \"%@\" = %@,\n",key, value];
    }
    [str appendString:@"}"];
    
    return str;
}

@end
