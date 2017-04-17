//
//  SmartRemindManager.m
//  cjj
//
//  Created by 聂晶 on 15/11/26.
//  Copyright © 2015年 cjj. All rights reserved.
//

#import "SmartRemindManager.h"
#import "SmartRemindModule.h"
#import "SmartRemindConfig.h"
#import "SmartRemindData.h"
#import "Message.h"
#import "BTServer.h"
#import "NotificationInfo.h"
#import "NSUserDefaultsHelper.h"

#import "SMContactTool.h"
#import "SMContactModel.h"
#import "SMMessageManager.h"
#import "SMDataPackageManager.h"
#import "logMessage.h"

#import "APPSManager.h"
#import "SMAppTool.h"

#import "SMInstructionModel.h"

//#import "SMDataPackageManager.h"

#define Remind_DATA_ERRCODE_OK  0x00
#define Remind_DATA_MIN_LENGTH  0x03

@interface SmartRemindManager()

@property (strong,nonatomic)BTServer *defaultBTServer;

@property(nonatomic,strong)APPSManager *appManager;

//@property(nonatomic,assign)Byte category;

@end

static Byte category;

@implementation SmartRemindManager

- (APPSManager *)appManager{
    if (!_appManager) {
        _appManager = [[APPSManager alloc]init];
    }
    return _appManager;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.defaultBTServer = [BTServer sharedBluetooth];

    }
    return self;
}
/**
 **/
-(void)writerMsgData:(NSInteger)modId type:(NSInteger)tagType{
    NSData *msgdata = [self buildMsgDataForSmartRemind:modId type:tagType];
    [self.defaultBTServer writedidWriteData:msgdata];
}



-(void)writerPowerData:(NSInteger)modId reqData:(SmartRemindData *)reqdata{
    Message *msg = [[Message alloc]init];
    [msg build:modId and:[reqdata toBytes]];
    NSData *msgData = [msg bytes2NSData];
    [Utils printfData2Byte:msgData and:@"写数据。。。。。。"];
    [self.defaultBTServer writedidWriteData:msgData];
   
}

-(void)writerData:(NSInteger)modId reqData:(Byte *)reqdata length: (Byte)len{
    Message *msg = [[Message alloc]init];
    NSMutableData *buff = [[NSMutableData alloc] initWithBytes:reqdata length:len];
    NSData *msgData = [msg build:modId and:buff];
    [Utils printfData2Byte:msgData and:@"写数据。。。。。。"];
    [self.defaultBTServer writedidWriteData:msgData];
    
//    SMDataPackageManager *dataManager = [[SMDataPackageManager alloc]init];
//    
//     NSData *messageData = [dataManager buildDataFrom:modId and:buff];
//    
//    [self.defaultBTServer writedidWriteData:messageData];
}



/**
 智能提醒总开关【TYPE_TAG_SMARTREMIND】、
 久座提醒【TYPE_TAG_SEDENTARY】、
 紧急求救【TYPE_TAG_EMERGENCY】、
 防丢报警【TYPE_TAG_ANTILOST】、
 智能通知【TYPE_TAG_NOTIFICATIONS】
 **/
-(NSData *)buildMsgDataForSmartRemind:(NSInteger)modId type:(NSInteger)tagType{
    SmartRemindConfig *config = [[SmartRemindConfig alloc]init];
    config.NotificationPower = true;

    int mask = 0;
    mask |= SmartRemind_MASK_NOTIFICATIONPOWER;

    SmartRemindData *data = [SmartRemindModule setConfigs:tagType config:[config convert] mask:mask reqAck:false];
    Message *msg = [[Message alloc]init];
    [msg build:modId and:[data toBytes]];
    NSData *msgData = [msg bytes2NSData];
    return msgData;
    
}


-(void)parseMsgDataForSmartRemind:(NSData *)reqBytes{
    SmartRemindData* data = [SmartRemindData parse:reqBytes];
    if (data!= nil) {
        if(data.cmdId == COMMAND_ID_CONFIG_SET_ACK){
            int config = 0;
            switch (data.tag) {
                case TYPE_TAG_SMARTREMIND:
                case TYPE_TAG_SEDENTARY:
                case TYPE_TAG_NOTIFICATIONS:
                    
                    break;
                case TYPE_TAG_EMERGENCY:
                    
                case TYPE_TAG_ANTILOST:
                    if(data.errcode==CONFIG_ERR_CODE_OK) {
                    }
                    break;
            }
            
            
        } else if(data.cmdId == COMMAND_ID_NTF_ADDED) {
            
        }else if (data.cmdId == COMMAND_ID_NTF_SETTING_ADD_ACK){
            
            NotificationInfo *info = [[NotificationInfo alloc]init];
            info.srd = data;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SETTING_ADD_ACK object:info];
            
        } else if(data.cmdId == COMMAND_ID_EVENT_ADDED) { // 只要有消息都走这里
            if (data.errcode == ERR_CODE_OK) {
                NotificationInfo *info = [[NotificationInfo alloc]init];
                printf("COMMAND_ID_EVENT_ADDED TAG: %ld\r\n", (long)data.tag);
                
                if(data.tag == TYPE_TAG_EMERGENCY){
                    // 紧急求救通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SOS object:nil];
                    return;

                }
                if(data.payload != nil){
                    int lenght = data.payload.length;
                    Byte * values = (Byte *)[data.payload bytes];
                    printf("VALUES: ");
                    for (int i = 0; i<lenght; i++) {
                        printf("%02X ", values[i]);
                        
                        
                    }
                    printf("\r\n");
                    NSMutableArray *appinfoArray = [[NSMutableArray alloc] init];
                    
                    
                    if (lenght < 9) {
                        NSLog(@"戒指返回的通知信息数据错误:信息长度错误(%d)",lenght);
                        return;
                        
                    }
                    
                    Byte ind = values[0];
                    Byte catId = values[3];
                    
                    
                    info.srd = data;
                    
                    
                    if(ind == INDICATE_ID_6){
                        
                        
                        Byte eventId = values[1];
                        Byte catId = values[3];
                        UInt64 uid;
                        memcpy(&uid, &values[5], 4);
                        printf("INDICATE_ID_6: %d, CMD: %02X, UID: %llu\r\n", ind, values[1], uid);
                        category = catId;
                        
                        
                        //系统来电
                        if (catId == CategoryIDIncomingCall) {
                            
                            Byte cmd;
                            if(eventId == EventIDNotificationRemoved){
                                cmd = COMMAND_ID_NTF_REMOVED;
                                
                                Byte dely = 0;
                                Byte catId = 1;
                                Byte color = 0xff;
                                Byte appId = 0;
                                Byte configs[]= {cmd, TYPE_TAG_NOTIFICATIONS, CONFIG_ERR_CODE_OK, dely,catId,color,appId};
                                
                                
                                //发送一条通知
                                SmartRemindManager *manager = [[SmartRemindManager alloc]init];
                                [manager writerData:ModID_Remind reqData:configs length:7];
                            }
                        }
                        }
                    else if(ind == INDICATE_ID_8){
                        int idx = 2;
                        //UInt64 uid;
                        
                        //memcpy(&uid, &values[2], 4);
                        
                        //printf("Indicate: %d, CMD: %02X, UID: %llu\r\n", ind, values[1], uid);
                        idx = 1 + 5;
                        while (idx < lenght-3) {
                            Byte aid = values[idx];
                            idx ++;
                            uint16_t len;
                            
                            memcpy(&len, &values[idx], 2);
                            idx += 2;
                            
                            int ss = lenght - idx;
                            if(len <= ss){
                                //printf("ID: %d, LEN: %d\r\n", aid, len);
                                NSData *newData = [[NSData alloc] initWithBytes:values+idx length:len];
                                NSString *str = [[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding];
                                
                                
                                //NSLog(@"电话信息=====>>>>>>>>>>>>>> %@", str);
                                
                                if (str == nil || str.length == 0) {
                                    
                                    NSLog(@"%s-%d-字符串%@", __FUNCTION__,__LINE__,str);
                                    break;
                                }
                                [appinfoArray addObject:str];
                                idx += len;

                            }else{
                                NSLog(@"戒指返回的通知信息数据错误:无法解析");
                                break;
                            
                            }
                            
                        }
                        
                        if (info == nil) {
                            NSLog(@"通知的信息为空");
                            return;
                        }
                        
                        if ([appinfoArray count] > 0 ) {
                            int index = 0;
                            
                            info.sendPackageName = [appinfoArray objectAtIndex:index++];
                            if (index < appinfoArray.count) {
                                info.sendAppName = [appinfoArray objectAtIndex:index++];
                            }
                            if (index < appinfoArray.count) {
                                info.sendAppContext = [appinfoArray objectAtIndex:index++];
                            }
                        }
                        
                        NSLog(@"信息类型:%@---发送者%@+++++++++++++++++++内容%@",info.sendPackageName,info.sendAppName,info.sendAppContext);
                        
                        
                        [self identifyNotificationTypeFormPackName:info.sendPackageName
                                                           appName:info.sendAppName
                                                          category:category
                                                 phoneNotification:^{
                                                     
                                                     // 电话 通知
                                                     [self sendPhoneAndSMSNotification:category];
                                                     
                                                 } vipNotification:^(SMContactModel *contact) {
                                                     
                                                     // VIP 通知
                                                     [self sendVIPPhoneAndSMSNotification:contact];
                                                     
                                                 } appNotification:^(SMAppModel *app) {
                                                     
                                                     // APP 通知
                                                     [self sendAppNotification:app];
                                                     
                                                 }];
                        
                    }
                }
            }else{
                NotificationInfo *info = [[NotificationInfo alloc]init];
                info.srd = data;
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REMIND_ERROR object:info];
            }
        }else if (data.cmdId == COMMAND_ID_CONFIG_GET_ACK) {
            UInt64 configss = 0;
            switch (data.tag) {
                case TYPE_TAG_SMARTREMIND:
                case TYPE_TAG_SEDENTARY:
                case TYPE_TAG_NOTIFICATIONS:{
                    if(data.errcode==CONFIG_ERR_CODE_OK) {
                        
                        configss = *(UInt64 *)[data.payload bytes];
//                        memcpy(&config, data.payload.bytes, 8);
                        printf("config:%16llx\r\n",configss);
                        
                        NotificationInfo *info = [[NotificationInfo alloc]init];
                        info.srd = data;
                        info.config = configss;
                        
                        NSLog(@"蓝牙类读取到的应用通知模块的config%llu",configss);
                        [SMMessageManager saveAppInfo:info];

                    }
                   
                    break;
                }
                case TYPE_TAG_EMERGENCY:{
                    if (data.errcode == CONFIG_ERR_CODE_OK) {
                        memcpy(&configss, data.payload.bytes, 4);
                        //configss = [Utils hex2Int2:(Byte *)[data.payload bytes] and:0 and:4];
                        printf("EMERGENCYconfig:%16llx\r\n",configss);
                        NSLog(@"蓝牙类紧急求救的config：%llu",configss);
                        
                        NotificationInfo *info = [[NotificationInfo alloc]init];
                        info.srd = data;
                        info.config = configss;
                        
                        //[[NSNotificationCenter defaultCenter] postNotificationName:@"Emergency" object:info];
                        
                    }
                   
                    
                    break;
                }
                case TYPE_TAG_ANTILOST:{
                    if (data.errcode == CONFIG_ERR_CODE_OK) {
//                        config = [Utils hex2Int2:(Byte *)[data.payload bytes] and:0 and:4];
                        Byte *payload = (Byte *)[data.payload bytes];
                        configss = *(int *)payload;
                        printf("config:%16llx\r\n",configss);
                        
                        
                        NotificationInfo *info = [[NotificationInfo alloc]init];
                        info.srd = data;
                        info.config = configss;
                        
                    }
                    //NSLog(<#NSString * _Nonnull format, ...#>)
//                    nameNotification = AntilostNotification;
                    
                    break;
                }
            }
            NotificationInfo *info = [[NotificationInfo alloc]init];
            info.srd = data;
            info.config = configss;
            
            [SMMessageManager saveSwitchInfo:info];
            
            
        } else if (data.cmdId == COMMAND_ID_EVENT_ADDED) {
            int num = 0;
            switch (data.tag) {
                case TYPE_TAG_SMARTREMIND:
                case TYPE_TAG_SEDENTARY:
                case TYPE_TAG_NOTIFICATIONS:
                case TYPE_TAG_EMERGENCY:{
                    
                    
                    // 紧急求救通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SOS object:nil];
                    
                    break;
                }
                case TYPE_TAG_ANTILOST:
                    break;
                default:
                    break;
            }
        }
        
    }
}


#pragma mark - 判断通知类型
- (void)identifyNotificationTypeFormPackName:(NSString*)packName appName:(NSString*)appName category:(Byte)category phoneNotification:(void(^)(void))phone vipNotification:(void(^)(SMContactModel *contact))vip appNotification:(void(^)(SMAppModel *app))app{
    
    // vip开关
    BOOL VipPower = [[NSUserDefaults standardUserDefaults]boolForKey:@"contactPower"];
    
    if (([packName isEqualToString:@"com.apple.mobilephone"] && category == CategoryIDIncomingCall ) ||
        [packName isEqualToString:@"com.apple.MobileSMS"]) {
        
        if (VipPower == YES) {
            [self matchingVipContact:appName vipContact:^(SMContactModel *contact) {
                vip(contact);
            } nonVipContact:^{

            }];
        }else{
            [self matchingVipContact:appName vipContact:^(SMContactModel *contact) {
                vip(contact);
            } nonVipContact:^{
                phone();
            }];
        }
    }else{
        
        if ([packName isEqualToString:@"com.apple.mobilephone"] || VipPower == YES) {
            return;
        }
        
        NSArray *apps = [SMAppTool Apps];
        for (SMAppModel *appInfo in apps) {
            if ([appInfo.identifiers isEqualToString:packName]) {
                
                if (appInfo.flag == YES) {
                    NSLog(@"匹配到一条%@通知信息，发送指令给戒指",packName);
                    app(appInfo);
                }else{
                    NSLog(@"匹配到一条%@通知信息，开关为关闭状态不发送",packName);
                }
                
            }
        }
        
    }
}

#pragma mark - 判断VIP联系人
- (void)matchingVipContact:(NSString *)sendAppName vipContact:(void(^)(SMContactModel *contact))vip nonVipContact:(void(^)(void))nonVip
{

    NSArray *array = [SMContactTool contacts];
    NSLog(@"获取VIP联系人列表%@",array);
    
    for (SMContactModel *contact in array) {
        
        if ([self checkContactName:contact callName:sendAppName]) {
            vip(contact);
        }
    }
    
    nonVip();
}

- (BOOL)checkContactName:(SMContactModel*)contact callName:(NSString*)callName{
    if ([[NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName] isEqualToString:callName]) {
        return YES;
    }
    if ([[NSString stringWithFormat:@"%@%@",contact.givenName,contact.familyName] isEqualToString:callName]) {
        return YES;
    }
    
    if ([[NSString stringWithFormat:@"%@ %@",contact.familyName,contact.givenName] isEqualToString:callName]) {
        return YES;
    }
    
    if ([[NSString stringWithFormat:@"%@ %@",contact.givenName,contact.familyName] isEqualToString:callName]) {
        return YES;
    }
    return NO;
}


- (void)matchingVipContact:(NSString *)sendAppName :(void(^)(SMContactModel *contact,bool isVip))isVip{
    
    NSArray *array = [SMContactTool contacts];
    NSLog(@"获取VIP联系人列表%@",array);
    
    BOOL isVipContact = NO;
    
    SMContactModel *contactInfo = [[SMContactModel alloc]init];
    
    for (SMContactModel *contact in array) {
        
        
        
        NSString *sortOrderFamilyName = [[NSString alloc]init];
        
        
        NSString *sortOrderGivenName = [[NSString alloc]init];
        
        
        if ([self isBlankString:contact.familyName] || [self isBlankString:contact.givenName]) {
            sortOrderFamilyName = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
            sortOrderGivenName  = [NSString stringWithFormat:@"%@%@",contact.givenName,contact.familyName];
        }else{
            sortOrderFamilyName = [NSString stringWithFormat:@"%@ %@",contact.familyName,contact.givenName];
            sortOrderGivenName  = [NSString stringWithFormat:@"%@ %@",contact.givenName,contact.familyName];
        }
        
        if ([sortOrderFamilyName isEqualToString:sendAppName] || [sortOrderGivenName isEqualToString:sendAppName]) {
            NSLog(@"匹配到VIP联系人-%@",sendAppName);
            contactInfo = contact;
            isVipContact = YES;
            break;
        }else{
            isVipContact = NO;
        }

        
        
    }
    
    isVip(contactInfo,isVipContact);

}

- (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
    
}

#pragma mark - 发送数据
- (void)sendAppNotification:(SMAppModel*)app{
    
    NSLog(@"发送");
    
    SMInstructionModel *model = [[SMInstructionModel alloc]init];
    model.commandId = COMMAND_ID_NTF_ADDED;
    model.modId = TYPE_TAG_NOTIFICATIONS;
    model.errorCode = CONFIG_ERR_CODE_OK;
    model.dely = 0;
    model.type = 4;
    model.color = app.colorId;
    model.count = 1;
    
    [self buildinstruction:model];
}

- (void)sendVIPPhoneAndSMSNotification:(SMContactModel*)contact{
    
    Byte colorByte = 0;
    
    NSArray *colorArray = @[@"circleChingBig",@"circleBlueBig",@"circlePurpleBig",@"circleRedBig"];
    
    NSUInteger typeNO = [colorArray indexOfObject:contact.circleColor];
    
    switch (typeNO) {
        case 0:
            colorByte = Color_GREEN;
            NSLog(@"VIP联系人颜色配置为绿色");
            break;
        case 1:
            colorByte = Color_BLUE;
            NSLog(@"VIP联系人颜色配置为蓝色");
            break;
        case 2:
            colorByte = Color_PURPLE;
            NSLog(@"VIP联系人颜色配置为紫色");
            break;
        case 3:
            colorByte = Color_RED;
            NSLog(@"VIP联系人颜色配置为红色");
            break;
        default:
            break;
    }
    
    NSLog(@"进来的Category值：%hhu",category);
    
    SMInstructionModel *model = [[SMInstructionModel alloc]init];
    model.commandId = COMMAND_ID_NTF_ADDED;
    model.modId = TYPE_TAG_NOTIFICATIONS;
    model.errorCode = CONFIG_ERR_CODE_OK;
    model.dely = 0;
    model.color = colorByte;
    
    switch (category) {
        case 1:{
            SMAppModel *app = [[SMAppTool Apps]objectAtIndex:0];
            if (app.flag) {
                model.type = 0x21;
                model.count = 20;
            }else{
                return;
            }
        }
            break;
        case 4:{
            SMAppModel *app = [[SMAppTool Apps]objectAtIndex:1];
            if (app.flag) {
                model.type = 0x24;
                model.count = 1;
            }else{
                return;
            }
        }
            break;
        default:
            break;
    }
    [self buildinstruction:model];
}

- (void)sendPhoneAndSMSNotification:(Byte)category{
    
    SMInstructionModel *model = [[SMInstructionModel alloc]init];
    model.commandId = COMMAND_ID_NTF_ADDED;
    model.modId = TYPE_TAG_NOTIFICATIONS;
    model.errorCode = CONFIG_ERR_CODE_OK;
    model.dely = 0;

    switch (category) {
        case 1:{
            SMAppModel *app = [[SMAppTool Apps]objectAtIndex:0];
            if (app.flag) {
                model.type = category;
                model.color = app.colorId;
                model.count = 20;
                NSLog(@"%hhu",model.count);
            }else{
                NSLog(@"%@为关闭状态不执行",app.title);
                return;
            }
        }
            break;
        case 4:{
            SMAppModel *app = [[SMAppTool Apps]objectAtIndex:1];
            if (app.flag) {
                model.type = category;
                model.color = app.colorId;
                model.count = 1;
                NSLog(@"%hhu",model.count);
                NSLog(@"%@为开启状态---执行,颜色%d",app.title,app.colorId);
            }else{
                NSLog(@"%@为关闭状态不执行,颜色%d",app.title,app.colorId);
                return;
            }
        }
            break;
            
        default:
            break;
    }

    [self buildinstruction:model];
}

- (void)buildinstruction:(SMInstructionModel*)model{
    
    BOOL smartRemindPower = [[NSUserDefaults standardUserDefaults]boolForKey:@"smartRemindPower"];
    BOOL vibPower = [[NSUserDefaults standardUserDefaults]boolForKey:@"vib"];
    BOOL flashPower = [[NSUserDefaults standardUserDefaults]boolForKey:@"flash"];
    
    if (smartRemindPower == NO) {
        // 如果只能提醒总开关是关闭的就不往下执行发送命令
        return;
    }
    
    if (flashPower) {
        
    }else{
        model.color = 0x00;
    }
    
    if(vibPower){
        model.color |= 0x80;//=+128
    }else{
        model.color &= 0x7F;//-128
    }

    Byte config[] = {model.commandId,model.modId,model.errorCode,model.dely,model.type,model.color,model.count};
    
    SmartRemindManager *manager = [[SmartRemindManager alloc]init];
    [manager writerData:ModID_Remind reqData:config length:7];
    
}


-(BOOL)isERRCode:(int)error data:(NSData*)mdata{
    BOOL falg = false;
    switch (error) {
        case ERR_CODE_OK:
            NSLog(@"ERROR--->无错误");
            falg = true;
            break;
        case ERR_CODE_INVALID_DATA_LENGTH:
            NSLog(@"ERR_CODE_INVALID_DATA_LENGTH--->验证数据长度错误");
            break;
        case ERR_CODE_READ_MEM_FAILED:
            NSLog(@"ERR_CODE_READ_MEM_FAILED--->错误");
            break;
        case ERR_CODE_WRITE_MEM_FAILED:
            NSLog(@"ERR_CODE_WRITE_MEM_FAILED--->错误");
            break;
        case ERR_CODE_MALLOC_MEM_FAILED:
            NSLog(@"ERR_CODE_MALLOC_MEM_FAILED--->错误");
            break;
        case ERR_CODE_NO_NTF_SETTINGS:
            NSLog(@"ERR_CODE_NO_NTF_SETTINGS--->错误");
            break;
        case ERR_CODE_INVALID_MOD_TAG:
            NSLog(@"ERR_CODE_INVALID_MOD_TAG--->错误");
            break;
        case ERR_CODE_INVALID_MOD_DATA:
            NSLog(@"ERR_CODE_INVALID_MOD_DATA--->错误");
            break;
        case ERR_CODE_INVALID_CMD:
            NSLog(@"ERR_CODE_INVALID_CMD--->错误");
            break;
        case ERR_CODE_NO_SPACE_AVAILABLE:
            NSLog(@"--->错误!");
            break;
        case ERR_CODE_NTF_SETTINGS_ALREADY_EXIST:
            NSLog(@"数据已存在!");
            
            break;
        case ERR_CODE_COMMAND_DISALLOWED:
            NSLog(@"ERR_CODE_COMMAND_DISALLOWED--->错误");
            break;
        
        case ERR_CODE_DEVICE_NOT_BONDED:
            NSLog(@"ERR_CODE_DEVICE_NOT_BONDED--->错误");
            break;
        case ERR_CODE_CURR_STATE_DISALLOWED:
            NSLog(@"ERR_CODE_CURR_STATE_DISALLOWED--->错误");
            break;
            
        default:
            break;
    }
    return falg;
}




@end
