//
//  bulidMessage.m
//  Blinq
//
//  Created by zsk on 16/4/12.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "bulidMessage.h"

#import "NotificationConfig.h"

#import "SmartRemindData.h"

#import "Message.h"

#import "SmartRemindModule.h"

#import "RemindNoticeInfo.h"

#import "BTServer.h"

#import "SmartRemindManager.h"



@interface bulidMessage()

@property(nonatomic,strong)BTServer *defaultBTServer;

@end

@implementation bulidMessage

-(BTServer *)defaultBTServer{
    if (!_defaultBTServer) {
        _defaultBTServer = [[BTServer alloc]init];
    }
    return _defaultBTServer;

}

-(void)appInfo:(SMAppModel *)info SetupColor:(Byte)color{
    
    UInt64 mask = 0;
    UInt64 config = info.config;
    NotificationConfig *noticeConfig = [NotificationConfig buid:config];
    
    noticeConfig.Color = color; 
    mask |= Notification_MASK_COLOR;
    
    SmartRemindData *std = [SmartRemindModule setConfigs:TYPE_TAG_NOTIFICATIONS config:[noticeConfig convert] mask:mask reqAck:false];
    SmartRemindManager *antilostManager2 = [[SmartRemindManager alloc]init];
    [antilostManager2 writerPowerData:ModID_Remind reqData:std];

}

-(void)appInfo:(SMAppModel *)info isOn:(BOOL)isOn{
    
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
            
            noticeConfig.Power = isOn;
            mask |= Notification_MASK_POWER;
            
            SmartRemindData *std = [SmartRemindModule setConfigs:TYPE_TAG_NOTIFICATIONS config:[noticeConfig convert] mask:mask reqAck:false];
            SmartRemindManager *antilostManager2 = [[SmartRemindManager alloc]init];
            [antilostManager2 writerPowerData:ModID_Remind reqData:std];
            
            NSLog(@"info.config的数据%llu",config);
            NSLog(@"更新--改变的app应用信息-appid:%ld catid:%ld  count:%ld color:%ld power:%@ interval:%ld data %@  mask%llu",noticeConfig.AppID,noticeConfig.CatID,noticeConfig.Count,noticeConfig.Color,noticeConfig.Power?@"YES":@"NO",noticeConfig.Interval,std,mask);
            
            
        }else{
            
            noticeConfig.CatID = info.catId;
            noticeConfig.AppID = info.appId;
            noticeConfig.Color = Color_CLOSE;
            noticeConfig.Vib = true;
            noticeConfig.Interval = 10;
            noticeConfig.Count = 2;
            noticeConfig.Power = true;
            SmartRemindData *data = [SmartRemindModule addConfigs:TYPE_TAG_NOTIFICATIONS cmdId:COMMAND_ID_NTF_SETTING_ADD config:[noticeConfig convert]];
            SmartRemindManager *antilostManager = [[SmartRemindManager alloc]init];
            [antilostManager writerPowerData:ModID_Remind reqData:data];
            
            NSLog(@"info.config的数据%llu",config);
            NSLog(@"增加的app应用信息-appid:%ld catid:%ld  count:%ld color:%ld power:%@ interval:%ld data %@  mask%llu",noticeConfig.AppID,noticeConfig.CatID,noticeConfig.Count,noticeConfig.Color,noticeConfig.Power?@"YES":@"NO",noticeConfig.Interval,data,mask);
            
        
        }
    }
}

@end
