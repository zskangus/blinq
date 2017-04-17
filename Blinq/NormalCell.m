//
//  NormalCell.m
//  Blinq
//
//  Created by zsk on 16/3/28.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "NormalCell.h"

#import "RemindNoticeInfo.h"

#import "BTServer.h"

#import "RemindNoticeManager.h"

#import "SmartRemindData.h"

#import "SmartRemindManager.h"

#import "NotificationConfig.h"

#import "bulidMessage.h"

#import "SMAppTool.h"

#import "SMPlayViewController.h"

#import "SMInstructionsClass.h"

@interface NormalCell()<customSwitchDelegate>

@property(nonatomic,strong)BTServer *defaultBTServer;

@property(nonatomic,strong)RemindNoticeManager *rnm;

@property(nonatomic,strong)NotificationConfig *noticeConfig;

@property(nonatomic,strong)SMPlayViewController *play;

@property(nonatomic,copy)NSString *colorStr;

@end


@implementation NormalCell

- (NotificationConfig *)noticeConfig{
    if (!_noticeConfig) {
        _noticeConfig = [[NotificationConfig alloc]init];
    }
    return _noticeConfig;
}

- (BTServer *)defaultBTServer{
    if (!_defaultBTServer) {
        _defaultBTServer = [[BTServer alloc]init];
    }
    return _defaultBTServer;
}

-(RemindNoticeManager *)rnm{
    if (!_rnm) {
        _rnm = [[RemindNoticeManager alloc]init];
    }
    return _rnm;
}

- (SMPlayViewController *)play{
    if (!_play) {
        _play = [[SMPlayViewController alloc]init];
    }
    return _play;
}

- (void)awakeFromNib {

    self.customSwitch.delegate = self;
    if (!self.colorStr) {
        //self.colorStr = @"circleRed";
    }
    
}

-(void)clickSwitch:(customSwitch *)Switch withBOOL:(BOOL)isOn{
    //bulidMessage *bmg = [[bulidMessage alloc]init];
    
    if (isOn) {
        self.circle.hidden = NO;
        //[bmg appInfo:self.dicInfo SetupColor:Color_RED];
                
        //[self setCircleColor:Color_RED];
    }else{
        self.circle.hidden = YES;
    }
    
    // 修改数据库中保存的开关值
    [SMAppTool updataApp:self.app.title power:isOn];
    
    //[bmg appInfo:self.app isOn:isOn];
    
    [self.delegate cell:self];
}


-(void)setCircleColor:(NSInteger)color{
    
    
    switch (color) {
        case 1:
            self.colorStr = @"circleRed";
            break;
        case 2:
            self.colorStr = @"circleChing";
            break;
        case 4:
            self.colorStr = @"circleBlue";
            break;
        case 5:
            self.colorStr = @"circlePurple";
            break;
        default:
            self.colorStr = @"circleRed";
            break;
    }
    
    [self.circle setImage:[UIImage imageNamed:self.colorStr] forState:UIControlStateNormal];
}



- (IBAction)circle:(id)sender {
    
    Byte colorByte;
    
    NSArray *circleColorArray = @[@"circleChing",@"circleBlue",@"circlePurple",@"circleRed"];
    
    NSUInteger typeNO = [circleColorArray indexOfObject:self.colorStr];
    
    typeNO++;
    
    if (typeNO > 3) {
        typeNO = 0;
    }
    
    switch (typeNO) {
        case 0:
            colorByte = Color_GREEN;
            break;
        case 1:
            colorByte = Color_BLUE;
            break;
        case 2:
            colorByte = Color_PURPLE;
            break;
        case 3:
            colorByte = Color_RED;
            break;
        default:
            break;
    }
    
    
    self.colorStr = circleColorArray[typeNO];
    
    [self.circle setImage:[UIImage imageNamed:self.colorStr] forState:UIControlStateNormal];
    
    // 点击换色
    [SMInstructionsClass notificationChangeColor:colorByte];
    
    // 修改数据库中保存的颜色值
    [SMAppTool updataApp:self.app.title color:colorByte];
    
    NSLog(@"修改APP:%@响应颜色为:%@",self.app.title,self.colorStr);
    
    [self.delegate cell:self];
    
}



- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
