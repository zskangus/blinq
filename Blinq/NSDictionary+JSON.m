//
//  NSDictionary+JSON.m
//  Pods
//
//  Created by John Jones on 11/29/15.
//
//

#import "NSDictionary+JSON.h"
#import "NSArray+JSON.h"

@implementation NSDictionary (JSON)

- (NSDictionary*)validJSONDictionary {
    NSMutableDictionary* cleaned = [[NSMutableDictionary alloc] initWithCapacity:self.count];
    for(NSString* key in self.allKeys) {
        id object = self[key];
        if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]] || [object isKindOfClass:[NSNull class]]) {
            cleaned[key] = object;
        } else if ([object isKindOfClass:[NSDictionary class]]) {
            cleaned[key] = [object validJSONDictionary];
        } else if ([object isKindOfClass:[NSArray class]]) {
            cleaned[key] = [object validJSONArray];
        } else {
            cleaned[key] = [object description];
        }
    }
    return [[NSDictionary alloc] initWithDictionary:cleaned];
}

@end
