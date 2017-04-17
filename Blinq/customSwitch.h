//
//  customSwitch.h
//  Blinq
//
//  Created by zsk on 16/4/2.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class customSwitch;

@protocol customSwitchDelegate <NSObject>//协议命名:类名+Delegate

-(void)clickSwitch:(customSwitch *)Switch withBOOL:(BOOL)isOn;

@end

@interface customSwitch : UIView

@property(nonatomic,weak)id<customSwitchDelegate>delegate;//选weak避免循环引用

@property (nonatomic, assign) BOOL isOn;

@property(nonatomic,assign)BOOL isDisable;

- (void)setOn:(BOOL)on;



@end
