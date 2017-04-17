//
//  SMPlayViewController.h
//  Blinq
//
//  Created by zsk on 16/3/29.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMBaseViewController.h"

//typedef NS_ENUM(NSUInteger, Indication) {
//    INDICATION_TYPE_ANTILOST,
//    INDICATION_TYPE_NORMAL_CALL,
//    INDICATION_TYPE_SOS_WARMING,
//    INDICATION_TYPE_SOS_CONFIRM,
//    INDICATION_TYPE_NORMAL_SOCIAL,
//    INDICATION_TYPE_SPECIAL_CALL,
//    INDICATION_TYPE_SPECIAL_SOCIAL,
//    INDICATION_TYPE_NORMAL_VF_ALL,
//    INDICATION_TYPE_NORMAL_V_HALF_SEC,
//    INDICATION_TYPE_NORMAL_F_HALF_SEC,
//    INDICATION_TYPE_NORMAL_V_ONE_SEC,
//    INDICATION_TYPE_NORMAL_F_ONE_SEC,
//    INDICATION_TYPE_NORMAL_V_TWO_SEC,
//    INDICATION_TYPE_NORMAL_F_TWO_SEC,
//    INDICATION_NONE
//};

@interface SMPlayViewController : SMBaseViewController

//+ (void)notificationAlertInstruction:(Indication)indication;

- (void)sendBreathingLamp:(NSNumber*)color time:(NSInteger)time;

- (void)stopFlashAndVib;

@end
