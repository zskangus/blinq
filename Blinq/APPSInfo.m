//
//  APPSInFo.m
//  cjj
//
//  Created by 聂晶 on 16/3/28.
//  Copyright © 2016年 cjj. All rights reserved.
//

#import "APPSInfo.h"

@implementation APPSInfo
-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self=[super init]) {
        self.title = dict[@"Title"];
        self.icon = dict[@"Icon"];
        self.analytics=dict[@"Analytics"];
        self.identifiers=dict[@"Identifiers"];
        self.name=dict[@"Name"];
        self.schemeName=dict[@"SchemeName"];
        NSString *appIdStr = dict[@"appId"];
        self.appId = [appIdStr intValue];
        NSString *catIdStr = dict[@"catId"];
        self.catId = [catIdStr intValue];
        
    }
    return self;
}
+(instancetype) appWithDict:(NSDictionary *)dict{
    
    // 为何使用self，谁调用self方法 self就会指向谁！！
    return [[self alloc] initWithDict:dict];
    
}
@end
