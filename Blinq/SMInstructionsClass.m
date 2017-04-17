//
//  SMInstructionsClass.m
//  Blinq
//
//  Created by zsk on 2016/12/12.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "SMInstructionsClass.h"
#import "MessageMacro.h"
#import "SmartRemindManager.h"

@implementation SMInstructionsClass

+ (void)notificationAlertModType:(ModType)modType indication:(Indication)indication{
    

    Byte ModType = [self returnModTyoe:modType];
    Byte Delay = 0;
    Byte Color = 0xff;
    Byte Count = 1;
    Byte Type = [self returnIndicationByte:indication];
    
    Byte Configs[]= {COMMAND_ID_NTF_ADDED,ModType, CONFIG_ERR_CODE_OK, Delay,Type,Color,Count};
    
    //发送一条通知
    SmartRemindManager *manager = [[SmartRemindManager alloc]init];
    [manager writerData:ModID_Remind reqData:Configs length:7];
}

+ (void)notificationChangeColor:(Byte)color{
    
    
    Byte ModType = MOD_TAG_INDICATIONS;
    Byte Delay = 0;
    Byte Color = color;
    Byte Count = 1;
    Byte Type = 0x82;
    
    Byte Configs[]= {COMMAND_ID_NTF_ADDED,ModType, CONFIG_ERR_CODE_OK, Delay,Type,Color,Count};
    
    //发送一条通知
    SmartRemindManager *manager = [[SmartRemindManager alloc]init];
    [manager writerData:ModID_Remind reqData:Configs length:7];
}

+ (Byte)returnModTyoe:(ModType)modtype{
    Byte ModType = 0;
    
    switch (modtype) {
        case MODTYPE_TAG_NOTIFICATIONS:
            ModType = MOD_TAG_NOTIFICATIONS;
            break;
        case MODTYPE_TAG_INDICATIONS:
            ModType = MOD_TAG_INDICATIONS;
            break;
        default:
            break;
    }
    
    return ModType;
}

+ (Byte)returnIndicationByte:(Indication)indication{
    
    Byte type = 0;
    
    switch (indication) {
        case INDICATION_TYPE_ANTILOST:          type = 0;       break;
        case INDICATION_TYPE_NORMAL_CALL:       type = 1;       break;
        case INDICATION_TYPE_SOS_WARMING:       type = 2;       break;
        case INDICATION_TYPE_SOS_CONFIRM:       type = 3;       break;
        case INDICATION_TYPE_NORMAL_SOCIAL:     type = 4;       break;
        case INDICATION_TYPE_SPECIAL_CALL:      type = 0x21;    break;
        case INDICATION_TYPE_SPECIAL_SOCIAL:    type = 0x24;    break;
        case INDICATION_TYPE_NORMAL_VF_ALL:     type = 0x80;    break;
        case INDICATION_TYPE_NORMAL_V_HALF_SEC: type = 0x81;    break;
        case INDICATION_TYPE_NORMAL_F_HALF_SEC: type = 0x82;    break;
        case INDICATION_TYPE_NORMAL_V_ONE_SEC:  type = 0x83;    break;
        case INDICATION_TYPE_NORMAL_F_ONE_SEC:  type = 0x84;    break;
        case INDICATION_TYPE_NORMAL_V_TWO_SEC:  type = 0x85;    break;
        case INDICATION_TYPE_NORMAL_F_TWO_SEC:  type = 0x86;    break;
        case INDICATION_NONE:                   type = 0xff;    break;
        default:
            break;
    }
    
    return type;
}

@end
