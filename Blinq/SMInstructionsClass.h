//
//  SMInstructionsClass.h
//  Blinq
//
//  Created by zsk on 2016/12/12.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,ModType){
    MODTYPE_TAG_NOTIFICATIONS,
    MODTYPE_TAG_INDICATIONS
};

typedef NS_ENUM(NSUInteger, Indication) {
    INDICATION_TYPE_ANTILOST,
    INDICATION_TYPE_NORMAL_CALL,
    INDICATION_TYPE_SOS_WARMING,
    INDICATION_TYPE_SOS_CONFIRM,
    INDICATION_TYPE_NORMAL_SOCIAL,
    INDICATION_TYPE_SPECIAL_CALL,
    INDICATION_TYPE_SPECIAL_SOCIAL,
    INDICATION_TYPE_NORMAL_VF_ALL,
    INDICATION_TYPE_NORMAL_V_HALF_SEC,
    INDICATION_TYPE_NORMAL_F_HALF_SEC,
    INDICATION_TYPE_NORMAL_V_ONE_SEC,
    INDICATION_TYPE_NORMAL_F_ONE_SEC,
    INDICATION_TYPE_NORMAL_V_TWO_SEC,
    INDICATION_TYPE_NORMAL_F_TWO_SEC,
    INDICATION_NONE
};

typedef NS_ENUM(NSInteger,ColorType){
    COLOR_TYPE_CLOSE,
    COLOR_TYPE_RED,
    COLOR_TYPE_GREEN,
    COLOR_TYPE_BLUE,
    //COLOR_TYPE_YELLOW,
    COLOR_TYPE_PURPLE,
    //COLOR_TYPE_INDIGO,
    //COLOR_TYPE_WHITE
};

@interface SMInstructionsClass : NSObject

+ (void)notificationChangeColor:(Byte)color;

+ (void)notificationAlertModType:(ModType)modType indication:(Indication)indication;

@end
