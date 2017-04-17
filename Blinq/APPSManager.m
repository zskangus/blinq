//
//  APPSManager.m
//  cjj
//
//  Created by 聂晶 on 16/3/28.
//  Copyright © 2016年 cjj. All rights reserved.
//

#import "APPSManager.h"
#import "APPSInfo.h"
#import <UIKit/UIKit.h>

@implementation APPSManager


/**
 *  从处理plist中的数据 并返回模型对象的数组
 *
 *  @return  NSArray *apps;
 
 */
-(NSArray *)getApps{
    if (self.apps==nil) {
        // 获得plist的全路径
        NSString *path=[[NSBundle mainBundle]pathForResource:@"app.plist" ofType:nil];
        //加载数组
        NSArray *dicArray=[NSArray arrayWithContentsOfFile:path];
        //将dicArray里面的所有字典转成模型对象，放到新的数组中。
        NSMutableArray *appArray=[NSMutableArray  array];
        for (NSDictionary *dict in dicArray) {
            //创建模型对象
            APPSInfo *app=[APPSInfo appWithDict:dict];
            //添加到对象到数组中
            [appArray addObject:app];
        }
        //赋值
        self.apps=dicArray;
        
    }
    return self.apps;
}

//获取应用（app.plist和本机都存在的应用）
-(NSArray *)getLocationCurrentApps{
    NSMutableArray *appsList=[NSMutableArray  array];
    NSArray * array = [self getApps];
    for (int i = 0; i< array.count; i++) {
        APPSInfo *info = [APPSInfo appWithDict:array[i]];
        NSString *astring = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@://",info.schemeName]];
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:astring]]){
            
            [appsList addObject:info];
        }
    }
    return appsList;
    
}


//根据包名获得列表的appId
-(NSInteger*)getAppIdByPackageName:(NSString *)packageName{
    NSArray *appsList=[self getLocationCurrentApps];
    for (int i = 0; i< appsList.count; i++) {
        APPSInfo *info = [appsList objectAtIndex:i];
        if ([info.identifiers isEqualToString: packageName]) {
            return info.appId;
        }
    }
    return nil;
}


//根据包名获得列表的catId
-(NSInteger*)getCatIdByPackageName:(NSString *)packageName{
    NSArray *appsList=[self getLocationCurrentApps];
    for (int i = 0; i< appsList.count; i++) {
        APPSInfo *info = [appsList objectAtIndex:i];
        NSString *packageNSString = (NSString *)info.identifiers;
        if ([info.identifiers isEqualToString: packageName]) {
            return info.catId;
        }
    }
    return nil;
}



@end
