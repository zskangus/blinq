//
//  RemindNotice.m
//  cjj
//
//  Created by 聂晶 on 15/12/4.
//  Copyright © 2015年 cjj. All rights reserved.
//

#import "RemindNoticeInfo.h"


@implementation RemindNoticeInfo

+(RemindNoticeInfo *) find:(NSString *)icon {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:icon];
    RemindNoticeInfo *info = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return info;
}

//-(BOOL) getMethod{
//    return _methodId != 3;
//}
//-(Byte) getColor{
//    return _colorId + 1;
//}

-(void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeBool:self.flag forKey:@"flag"];
    [aCoder encodeObject:self.icon forKey:@"icon"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeInteger:self.colorId forKey:@"colorId"];
    [aCoder encodeInteger:self.methodId forKey:@"methodId"];
    [aCoder encodeInteger:self.appId forKey:@"appId"];
    [aCoder encodeInteger:self.catId forKey:@"catId"];
    [aCoder encodeInteger:self.RemindCount forKey:@"remindCount"];
    [aCoder encodeInteger:self.Interval forKey:@"Interval"];
    [aCoder encodeInteger:self.Count forKey:@"Count"];
    [aCoder encodeInt64:self.config forKey:@"config"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]) {
        self.flag = [aDecoder decodeBoolForKey:@"flag"];
        self.icon = [aDecoder decodeObjectForKey:@"icon"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.colorId = [aDecoder decodeIntegerForKey:@"colorId"];
        self.methodId = [aDecoder decodeIntegerForKey:@"methodId"];
        self.appId = [aDecoder decodeIntegerForKey:@"appId"];
        self.catId = [aDecoder decodeIntegerForKey:@"catId"];
        self.RemindCount = [aDecoder decodeIntegerForKey:@"remindCount"];
        self.Interval = [aDecoder decodeIntegerForKey:@"remindCount"];
        self.Count = [aDecoder decodeIntegerForKey:@"remindCount"];
        self.config = [aDecoder decodeInt64ForKey:@"config"];
    }
    return self;
}


@end
