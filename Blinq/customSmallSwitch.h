//
//  customSmallSwitch.h
//  Blinq
//
//  Created by zsk on 16/4/28.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class customSmallSwitch;

@protocol customSmallSwitchDelegate <NSObject>//协议命名:类名+Delegate

-(void)clickSwitch:(customSmallSwitch *)Switch withBOOL:(BOOL)isOn;

@end

@interface customSmallSwitch : UIView

@property(nonatomic,weak)id<customSmallSwitchDelegate>delegate;//选weak避免循环引用

@property (nonatomic, assign) BOOL isOn;

- (void)setOn:(BOOL)on;

@end
