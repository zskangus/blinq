//
//  NSArray+decription.m
//  cjj
//
//  Created by zsk on 16/7/29.
//  Copyright © 2016年 cjj. All rights reserved.
//

#import "NSArray+decription.h"

@implementation NSArray (decription)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *str = [NSMutableString stringWithFormat:@"%lu (\n", (unsigned long)self.count];
    
    for (id obj in self) {
        [str appendFormat:@"\t%@, \n", obj];
    }
    
    [str appendString:@")"];
    
    return str;
}

@end
