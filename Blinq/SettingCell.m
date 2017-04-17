//
//  SettingCell.m
//  Blinq
//
//  Created by zsk on 16/4/22.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "SettingCell.h"
#import "customSwitch.h"
#import "SmartRemindConfig.h"
#import "SmartRemindData.h"
#import "SmartRemindModule.h"
#import "SmartRemindManager.h"
#import "SMMessageManager.h"

@interface SettingCell()<customSwitchDelegate>

@end

@implementation SettingCell

- (void)awakeFromNib {
    self.customSwitch.delegate = self;
}


- (void)clickSwitch:(customSwitch *)Switch withBOOL:(BOOL)isOn{
    
    NSUserDefaults *userPower = [NSUserDefaults standardUserDefaults];
    
    switch (self.tag) {
        case 0:{
            [SMMessageManager vibratePower:isOn];
        }
            break;
        case 1:{
            [SMMessageManager flashPower:isOn];
        }
            break;
        default:
            break;
    }

    [userPower synchronize];



}

@end
