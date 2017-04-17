//
//  PeriperalInfo.m
//  DarkBlue
//
//  Created by chenee on 14-3-26.
//  Copyright (c) 2014年 chenee. All rights reserved.
//

#import "PeriperalInfo.h"

@implementation PeriperalInfo



- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", _uuid];
}
-(void)addPeripheralInfo{
    
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    //[aCoder encodeObject:self.peripheral forKey:@"peripheral"];
    [aCoder encodeObject:self.uuid forKey:@"uuid"];
    [aCoder encodeObject:self.serviceUUIDS forKey:@"serviceUUIDS"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self)
    {
        //self.peripheral = [aDecoder decodeObjectForKey:@"peripheral"];
        self.uuid = [aDecoder decodeObjectForKey:@"uuid"];
        self.serviceUUIDS = [aDecoder decodeObjectForKey:@"serviceUUIDS"];
    }
    return self;
}



@end
