//
//  APPSManager.h
//  cjj
//
//  Created by 聂晶 on 16/3/28.
//  Copyright © 2016年 cjj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPSManager : NSObject

@property (strong,nonatomic)NSArray * apps;

-(NSArray *)getApps;

-(NSArray *)getLocationCurrentApps;

-(NSInteger*)getAppIdByPackageName:(NSString *)packageName;

-(NSInteger*)getCatIdByPackageName:(NSString *)packageName;

@end
