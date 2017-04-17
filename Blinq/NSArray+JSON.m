//
//  NSArray+JSON.m
//  Pods
//
//  Created by John Jones on 11/29/15.
//
//

#import "NSArray+JSON.h"
#import "NSDictionary+JSON.h"

@implementation NSArray (JSON)

- (NSArray*)validJSONArray {
    NSMutableArray* cleaned = [[NSMutableArray alloc] initWithCapacity:self.count];
    for(id object in self) {
        if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]] || [object isKindOfClass:[NSNull class]]) {
            [cleaned addObject:object];
        } else if ([object isKindOfClass:[NSDictionary class]]) {
            [cleaned addObject:[object validJSONDictionary]];
        } else if ([object isKindOfClass:[NSArray class]]) {
            [cleaned addObject:[object validJSONArray]];
        } else {
            [cleaned addObject:[object description]];
        }
    }
    return [[NSArray alloc] initWithArray:cleaned];
}

@end
