//
//  RemindNoticeManager.m
//  cjj
//
//  Created by 聂晶 on 16/4/2.
//  Copyright © 2016年 cjj. All rights reserved.
//

#import "RemindNoticeManager.h"
#import "AppConstant.h"

#import "SmartRemindManager.h"
#import "NotificationInfo.h"
#import "NotificationConfig.h"
#import "RemindNoticeInfo.h"
#import "AntilostConfig.h"
#import "APPSManager.h"
#import "APPSInfo.h"
#import "NSUserDefaultsHelper.h"
#import <UIKit/UIKit.h>

@implementation RemindNoticeManager


-(void)readInfo{
    [self updateArray];

    
    
    // 开关
    SmartRemindData *reqData = [SmartRemindModule getConfig:TYPE_TAG_SMARTREMIND];
    SmartRemindManager *manager = [[SmartRemindManager alloc]init];
    [manager writerPowerData:ModID_Remind reqData:reqData];
    
    
}

-(void)updateArray{
    [_selected removeAllObjects];
    [_unselected removeAllObjects];
    _alls = [self getLocationCurrentApps];
    NSArray *array = nil;
    BOOL flag = [NSUserDefaultsHelper getBoolForKey:NSUserDefaults_VIPCONTACT_POWER];
    if(flag) {
        array = [NSUserDefaultsHelper getArrayForKey:NSUserDefaults_VIPCONTACT_NAME_TEL];
    }
    for(int i = 0; i < _alls.count; i++) {
        RemindNoticeInfo *info = [_alls objectAtIndex:i];
        if(info.flag) {
            [_selected addObject:info];
        } else {
            [_unselected addObject:info];
        }
        if(array != nil) {
            if((info.catId == 1 && info.appId == 0)
               || (info.catId == 4 && info.appId == 1)) {
                info.title = [info.title stringByAppendingFormat:@"%s", "(Only VIP)"];
            }
        }
    }
}


-(NSArray *)getLocationCurrentApps{
    APPSManager *appManager = [[APPSManager alloc]init];
    NSMutableArray *appsList=[NSMutableArray  array];
    NSArray * array = [appManager getApps];
    for (int i = 0; i< array.count; i++) {
        //判断本地是否存在该应用
        APPSInfo *info = [APPSInfo appWithDict:array[i]];
        NSString *astring = [[NSString alloc] initWithString:[NSString stringWithFormat:@"####%@://",info.schemeName]];
        
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:astring]]){
            [appsList addObject:[self buildEntry:info.icon name:info.title catId:info.catId appId:info.appId]];
        }
    }
    NSLog(@"appslist.count:%ld",appsList.count);
    return appsList;
    
}

-(RemindNoticeInfo *) findEntry:(NSString *)icon {
    return [RemindNoticeInfo find:icon];
}

-(RemindNoticeInfo *) buildEntry:(NSString *)icon
                            name:(NSString *)name
                           catId:(NSInteger)catId
                           appId:(NSInteger)appId{
    
    RemindNoticeInfo *info = [self findEntry:icon];
    if(info == nil) {
        info = [[RemindNoticeInfo alloc]init];
        info.flag = false;
        info.title = name;
        info.icon = icon;
        info.catId = catId;
        info.appId = appId;
        info.colorId = 0;
        info.methodId = 0;
    }
    NSLog(@">>>>>>>>>>title=%s,catId=%d,appId=%d", info.title, info.catId, info.appId);
    return info;
}

-(void)updateInfo:(NSNotification*) notification{

}


    
-(void)change:(RemindNoticeInfo *)info {
        UInt64 mask = 0;
        NotificationConfig *noticeConfig = [NotificationConfig buid:info.config];
//        noticeConfig.CatID = info.catId;
//        mask |= Notification_MASK_CATID;
//        noticeConfig.AppID = info.appId;
//        mask |= Notification_MASK_APPID;
    
        noticeConfig.Vib = true;
        mask |= Notification_MASK_VIB;
        switch (info.colorId) {
            case 0:
            case 1:
            case 2:
                noticeConfig.Color = info.colorId;
                break;
            case 3:
            case 4:
                noticeConfig.Color = info.colorId + 1;
                break;
            default:
                break;
        }
        
        mask |= Notification_MASK_COLOR;
        noticeConfig.Power = info.flag;
        mask |= Notification_MASK_POWER;
    
//    
//    noticeConfig.Count = info.Count;
//    mask |= Notification_MASK_COUNT;
//    
//    noticeConfig.Interval = info.Interval;
//    mask |= Notification_MASK_Interval;
//    
//    noticeConfig.RemindCount = info.RemindCount;
//    mask |= Notification_MASK_REMINDCOUNT;
    
        SmartRemindData *std = [SmartRemindModule setConfigs:TYPE_TAG_NOTIFICATIONS config:[noticeConfig convert] mask:mask reqAck:false];
        SmartRemindManager *antilostManager2 = [[SmartRemindManager alloc]init];
        [antilostManager2 writerPowerData:ModID_Remind reqData:std];
    
//    std = [SmartRemindModule getConfig:TYPE_TAG_NOTIFICATIONS catId:info.catId appId:info.appId];
//        [antilostManager2 writerPowerData:ModID_Remind reqData:std];
    
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:info];
        [ud setObject:data forKey:info.icon];
    }
    
    


@end
