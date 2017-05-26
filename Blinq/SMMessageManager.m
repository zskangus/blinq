//
//  SMMessageManager.m
//  Blinq
//
//  Created by zsk on 16/5/20.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "SMMessageManager.h"
#import "SMAppTool.h"
#import "SMAppModel.h"

#import "SmartRemindData.h"
#import "SmartRemindManager.h"
#import "SmartRemindConfig.h"
#import "NotificationInfo.h"
#import "NotificationConfig.h"

#import "AntiLostData.h"
#import "AntiLostModule.h"
#import "AntilostConfig.h"

#import "SOSModule.h"
#import "SOSData.h"

#import "SOSConfig.h"

#import "logMessage.h"

#import "SKConst.h"

@implementation SMMessageManager

+ (void)setupNotificationInfo{
    
    // 手机已安装的APP列表
    NSArray *apps = [SMAppTool getApps];
    
    BOOL isFirstTime = [SKUserDefaults boolForKey:@"isFirstTime"];
    
    // 第一次绑定-电话-短信-及部分应用设置开关为开启状态
    if (isFirstTime) {
        
        for (SMAppModel *app in apps) {
            
            app.flag = NO;
            app.colorId = 1;
            
            if ([app.title isEqualToString:@"PHONE CALLS"]) {
                app.flag = YES;
                app.colorId = 2;
                [self openNotificationPower:app];
            };
            
            if ([app.title isEqualToString:@"TEXT MESSAGES"]) {
                app.flag = YES;
                app.colorId = 4;
                [self openNotificationPower:app];
            }
            
            if ([app.title isEqualToString:@"EMAILS"]) {
                app.flag = YES;
                app.colorId = 1;
            }
            
            [SMAppTool addApp:app];
        }
        
    }

}

// 重新配置数据
+ (void)againSetupNotificationInfo{
    
    // 手机已安装的APP列表
    NSArray *apps = [SMAppTool getApps];
    
    for (SMAppModel *app in apps) {
        
        app.flag = NO;
        app.colorId = 1;
        
        if ([app.title isEqualToString:@"PHONE CALLS"]) {
            app.flag = YES;
            app.colorId = 2;
            [self openNotificationPower:app];
        };
        
        if ([app.title isEqualToString:@"TEXT MESSAGES"]) {
            app.flag = YES;
            app.colorId = 4;
            [self openNotificationPower:app];
        }
        
        if ([app.title isEqualToString:@"EMAILS"]) {
            app.flag = YES;
            app.colorId = 1;
        }
        
        [SMAppTool addApp:app];
    }
    
}

+ (void)openNotificationPower:(SMAppModel*)appModel{
    
    SMAppModel *app = appModel;
    
    // 获取对应APP在戒指中的保存的设置
    SmartRemindData *data = [SmartRemindModule getConfig:TYPE_TAG_NOTIFICATIONS catId:app.catId appId:app.appId];
    SmartRemindManager *antilostManager2 = [[SmartRemindManager alloc]init];
    [antilostManager2 writerPowerData:ModID_Remind reqData:data];
    [NSThread sleepForTimeInterval:0.3];

}

+(void)appInfo:(SMAppModel *)info isOn:(BOOL)isOn{
    
    //RemindNoticeInfo *info = infop[@"appInfo"];
    if (info!=nil) {
        
        NSLog(@"要改变的应用的信息%@,appid:%ld,catid:%ld,color=%ld,power:%@,count:%ld,interval:%ld,remindCount:%ld", info.title,info.appId,info.catId,info.colorId,info.flag?@"YES":@"NO",info.Count,info.Interval,info.RemindCount);
        
        UInt64 mask = 0;
        UInt64 config = info.config;
        NotificationConfig *noticeConfig = [NotificationConfig buid:config];
        
        if (config) {
            
            noticeConfig.CatID = info.catId;
            mask |= Notification_MASK_CATID;
            
            noticeConfig.AppID = info.appId;
            mask |= Notification_MASK_APPID;
            
            noticeConfig.Vib = true;
            mask |= Notification_MASK_VIB;
            
            //    noticeConfig.Color = Color_RED;
            //    mask |= Notification_MASK_COLOR;
            
            noticeConfig.Color = Color_RED;
            mask |= Notification_MASK_COLOR;
            
            noticeConfig.Power = isOn;
            mask |= Notification_MASK_POWER;
            
            SmartRemindData *std = [SmartRemindModule setConfigs:TYPE_TAG_NOTIFICATIONS config:[noticeConfig convert] mask:mask reqAck:false];
            SmartRemindManager *antilostManager2 = [[SmartRemindManager alloc]init];
            [antilostManager2 writerPowerData:ModID_Remind reqData:std];
            
            NSLog(@"info.config的数据%llu",config);
            NSLog(@"更新--改变的app应用信息-appid:%ld catid:%ld  count:%ld color:%ld power:%@ interval:%ld data %@  mask%llu",noticeConfig.AppID,noticeConfig.CatID,noticeConfig.Count,noticeConfig.Color,noticeConfig.Power?@"YES":@"NO",noticeConfig.Interval,std,mask);
            
            
        }
//        else{
//            
//            noticeConfig.CatID = info.catId;
//            noticeConfig.AppID = info.appId;
//            noticeConfig.Color = Color_RED;
//            noticeConfig.Vib = true;
//            noticeConfig.Interval = 10;
//            noticeConfig.Count = 2;
//            noticeConfig.Power = true;
//            SmartRemindData *data = [SmartRemindModule addConfigs:TYPE_TAG_NOTIFICATIONS cmdId:COMMAND_ID_NTF_SETTING_ADD config:[noticeConfig convert]];
//            SmartRemindManager *antilostManager = [[SmartRemindManager alloc]init];
//            [antilostManager writerPowerData:ModID_Remind reqData:data];
//            
//            NSLog(@"info.config的数据%llu",config);
//            NSLog(@"增加的app应用信息-appid:%ld catid:%ld  count:%ld color:%ld power:%@ interval:%ld data %@  mask%llu",noticeConfig.AppID,noticeConfig.CatID,noticeConfig.Count,noticeConfig.Color,noticeConfig.Power?@"YES":@"NO",noticeConfig.Interval,data,mask);
//            
//            
//        }
    }
}


+ (void)obtainNotificationInfo{
    
    // 手机已安装的APP列表
    NSArray *apps = [SMAppTool getApps];
    
    // 手机已保存的APP数据
    NSArray *appsInfo = [SMAppTool Apps];

    // 如果数据库没保存有值，就全部发送一次获取请求
    if (appsInfo.count == 0) {
        for (SMAppModel *app in apps) {
            
            [SMAppTool addApp:app];
        }
        
    }else{
        
        [self increaseApp:apps appList:appsInfo];
        [self deleteApp:apps appList:appsInfo];
    }
 }

+ (void)GetAllNotificationInfo{
    
    // 手机已安装的APP列表
    NSArray *apps = [SMAppTool getApps];
    
    for (SMAppModel *app in apps) {
        
        [SMAppTool addApp:app];
        
        // 获取对应APP在戒指中的保存的设置
        SmartRemindData *data = [SmartRemindModule getConfig:TYPE_TAG_NOTIFICATIONS catId:app.catId appId:app.appId];
        SmartRemindManager *antilostManager2 = [[SmartRemindManager alloc]init];
        [antilostManager2 writerPowerData:ModID_Remind reqData:data];
        [NSThread sleepForTimeInterval:0.3];
    }
}

+ (void)saveAppInfo:(NotificationInfo*)appInfo{
    
    NotificationInfo *info = appInfo;
    
    UInt64 _configs = info.config;
    NSLog(@"从蓝牙类传过来的configs%llu",_configs);
    
    NotificationConfig *config = [NotificationConfig buid:_configs];
    
    for (SMAppModel *app in [SMAppTool Apps]) {
        if (app.appId == config.AppID && app.catId == config.CatID) {
            
            if (app.flag != config.Power || app.colorId != config.Color || app.config != _configs || app.RemindCount != config.RemindCount || app.Interval != config.Interval || app.Count != config.Count) {
                
                app.flag = config.Power;
                //app.colorId = config.Color;
                app.config = _configs;
                app.RemindCount = config.RemindCount;
                app.Interval = config.Interval;
                app.Count = config.Count;
                
                if (config.Power == NO) {
                    [self appInfo:app isOn:YES];
                }
                
                NSLog(@"MessageManaer类更新保存--appName=%@,appid:%ld,catid:%ld,color=%ld,vib=%d,power:%@,count:%ld,interval:%ld,remindCount:%ld", app.title,app.appId,app.catId,config.Color, config.Vib,config.Power?@"YES":@"NO",app.Count,app.Interval,app.RemindCount);
                
                [SMAppTool updataApp:app];
                
            }
    
        }
        
    }
}

+ (void)increaseApp:(NSArray*)apps appList:(NSArray*)appList{

    NSMutableArray *appNameArray = [NSMutableArray array];
    
    for (SMAppModel *info in appList) {
        [appNameArray addObject:info.title];
    }
    
    for (SMAppModel *app in apps) {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",app.title];
        NSString *string = [[appNameArray filteredArrayUsingPredicate:pred]lastObject];
        
        if (!string) {
            NSLog(@"数据库应用列表不包含%@-将添加新数据",app.title);
            
            app.flag = NO;
            app.colorId = 1;
            
            [SMAppTool addApp:app];
            
//            // 获取对应APP在戒指中的保存的设置
//            SmartRemindData *data = [SmartRemindModule getConfig:TYPE_TAG_NOTIFICATIONS catId:app.catId appId:app.appId];
//            SmartRemindManager *antilostManager2 = [[SmartRemindManager alloc]init];
//            [antilostManager2 writerPowerData:ModID_Remind reqData:data];
//            [NSThread sleepForTimeInterval:0.3];
            
        }
    }
}

+ (void)deleteApp:(NSArray*)apps appList:(NSArray*)appList{
    
    NSMutableArray *appNameArrayTwo = [NSMutableArray array];
    
    for (SMAppModel *app in apps) {
        [appNameArrayTwo addObject:app.title];
    }
    
    for (SMAppModel *info in appList) {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",info.title];
        NSString *string = [[appNameArrayTwo filteredArrayUsingPredicate:pred]lastObject];
        
        if (!string) {
            NSLog(@"本机应用列表不包含%@-将删除数据库中的相应数据",info.title);
            [SMAppTool deleteApp:info];
        }
    }
}


+ (void)requestAllData{
    
    //1.紧急求救开关
    [NSThread sleepForTimeInterval:0.3];
    [self requestGetData4SOSPower];
    //2.远离提醒开关
    [NSThread sleepForTimeInterval:0.3f];
    [self requestGetData4AntilostPower];
    //3.智能提醒信息
    [NSThread sleepForTimeInterval:0.3f];
    [self requestGetData4SmartRemindPower];
    [NSThread sleepForTimeInterval:0.3f];
    
}

+(void)requestGetData4SOSPower{
    SOSData *reqData = [SOSModule getConfig:TYPE_TAG_EMERGENCY];
    SmartRemindManager *manager = [[SmartRemindManager alloc]init];
    [manager writerPowerData:ModID_Remind reqData:reqData];
    
}
+(void)requestGetData4AntilostPower{
    AntiLostData *reqData = [AntiLostModule getConfig:TYPE_TAG_ANTILOST];
    SmartRemindManager *manager = [[SmartRemindManager alloc]init];
    [manager writerPowerData:ModID_Remind reqData:reqData];
    
}
+(void)requestGetData4SmartRemindPower{
    // 开关
    SmartRemindData *reqData = [SmartRemindModule getConfig:TYPE_TAG_SMARTREMIND];
    SmartRemindManager *manager = [[SmartRemindManager alloc]init];
    [manager writerPowerData:ModID_Remind reqData:reqData];
}

+ (void)saveSwitchInfo:(NotificationInfo *)switchInfo{
    
    NotificationInfo *info = switchInfo;
    
    
    if(info.srd.tag == TYPE_TAG_SMARTREMIND) {
        UInt64 _configs = info.config;
        SmartRemindConfig *powerConfig = [SmartRemindConfig build:_configs];
        
        NSLog(@"远离开关是否开启:%@",powerConfig.AntilostPower?@"YES":@"NO");
        NSLog(@"震动开关是否开启:%@",!powerConfig.DisVib?@"YES":@"NO");
        NSLog(@"闪烁开关是否开启:%@",!powerConfig.DisFlash?@"YES":@"NO");
        NSLog(@"智能提醒开关是否开启:%@",powerConfig.NotificationPower?@"YES":@"NO");
        NSLog(@"紧急求救开关是否开启:%@",powerConfig.EmergencyPower?@"YES":@"NO");
        
        NSUserDefaults *smartRemind = [NSUserDefaults standardUserDefaults];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:powerConfig];
        [smartRemind setObject:data forKey:@"smartRemind_power_config"];
        [smartRemind setBool:powerConfig.NotificationPower forKey:@"smartRemindPower"];
        [smartRemind setBool:powerConfig.AntilostPower forKey:@"antilostPower"];
        [smartRemind setBool:!powerConfig.DisVib forKey:@"vib"];
        [smartRemind setBool:!powerConfig.DisFlash forKey:@"flash"];
        //[smartRemind setBool:powerConfig.EmergencyPower forKey:@"emergencyPower"];
        
        
        if (powerConfig.AntilostPower == YES) {
            NSLog(@"当前远离提醒功能为开启，设置为关闭状态");
            [self antilostPower:NO];
        }

    }
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ReloadSettingView" object:nil];
    });
}

+ (void)antilostPower:(BOOL)setOn{
    
    UInt64 mask = 0;
    
    NSData *configData = [[NSUserDefaults standardUserDefaults]objectForKey:@"smartRemind_power_config"];
    
    SmartRemindConfig *config = (SmartRemindConfig *)[NSKeyedUnarchiver unarchiveObjectWithData:configData];
    
    config.AntilostPower = setOn;
    mask |= SmartRemind_MASK_ANTILOSTPOWER;
    SmartRemindData *data = [SmartRemindModule setConfigs:TYPE_TAG_SMARTREMIND config:[config convert] mask:mask reqAck:false];
    SmartRemindManager *antilostManager2 = [[SmartRemindManager alloc]init];
    [antilostManager2 writerPowerData:ModID_Remind reqData:data];
    
    NSUserDefaults *antilost = [NSUserDefaults standardUserDefaults];
    NSData *savedata = [NSKeyedArchiver archivedDataWithRootObject:config];
    [antilost setObject:savedata forKey:@"antilost_power_config"];
    [antilost setBool:config.AntilostPower forKey:@"antilostPower"];
    [antilost synchronize];
}

+ (void)emergencyPower:(BOOL)setOn{
    
    UInt64 mask = 0;
    
    NSData *configData = [[NSUserDefaults standardUserDefaults]objectForKey:@"smartRemind_power_config"];
    
    SmartRemindConfig *config = (SmartRemindConfig *)[NSKeyedUnarchiver unarchiveObjectWithData:configData];
    
    config.EmergencyPower = setOn;

    mask |= SmartRemind_MASK_EMERGENCYPOWER;
    SOSData *data = [SOSModule setConfigs:TYPE_TAG_SMARTREMIND config:[config convert] mask:mask reqAck:false];
    SmartRemindManager *antilostManager2 = [[SmartRemindManager alloc]init];
    [antilostManager2 writerPowerData:ModID_Remind reqData:data];
    
    NSUserDefaults *sos = [NSUserDefaults standardUserDefaults];
    NSData *savedata = [NSKeyedArchiver archivedDataWithRootObject:config];
    [sos setObject:savedata forKey:@"emergency_power_config"];
    [sos setBool:setOn forKey:@"emergencyPower"];
    [sos synchronize];
}

+ (void)vibratePower:(BOOL)setOn{
    NSLog(@"震动开关");
    UInt64 mask = 0;
    SmartRemindConfig *conf = [SmartRemindConfig build:0];
    conf.DisVib = !setOn;
    
    mask |= SmartRemind_MASK_DISVIB;
    SmartRemindData *data = [SmartRemindModule setConfigs:TYPE_TAG_SMARTREMIND config:[conf convert] mask:mask reqAck:false];
    
    NSLog(@"提醒发送的数据%@",data);
    
    SmartRemindManager *antilostManager2 = [[SmartRemindManager alloc]init];
    [antilostManager2 writerPowerData:ModID_Remind reqData:data];
    
    [SKUserDefaults setBool:setOn forKey:@"vib"];
}

+ (void)flashPower:(BOOL)setOn{
    
    NSLog(@"闪烁开关");
    UInt64 mask = 0;
    SmartRemindConfig *conf = [SmartRemindConfig build:0];
    conf.DisFlash = !setOn;
    
    mask |= SmartRemind_MASK_DISFLASH;
    SmartRemindData *data = [SmartRemindModule setConfigs:TYPE_TAG_SMARTREMIND config:[conf convert] mask:mask reqAck:false];
    
    NSLog(@"提醒发送的数据%@",data);
    
    SmartRemindManager *antilostManager2 = [[SmartRemindManager alloc]init];
    [antilostManager2 writerPowerData:ModID_Remind reqData:data];
    
    [SKUserDefaults setBool:setOn forKey:@"flash"];

}
@end
