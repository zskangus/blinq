//
//  ReceiveNotificationCell.m
//  Blinq
//
//  Created by zsk on 16/3/28.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "ReceiveNotificationCell.h"
#import "SKAttributeString.h"
#import "SMContactTool.h"

@interface ReceiveNotificationCell()<customSmallSwitchDelegate>

@property (weak, nonatomic) IBOutlet UILabel *latel;

@property(nonatomic,assign)BOOL switchisOn;

@end

@implementation ReceiveNotificationCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
       self.customSmallSwitch.delegate = self;
    
    
    if ([NSLocalizedString(@"language", nil)isEqualToString:@"German"]) {
        
        self.latel.text = @"";
        
        UILabel *label = [[UILabel alloc]initWithFrame:self.latel.frame];
        label.numberOfLines = 0;
        CGRect frame = label.frame;
        frame.size.width += 35;
        label.frame = frame;
        [self addSubview:label];
        
        [SKAttributeString setLabelFontContent:label title:NSLocalizedString(@"notifications_page_vipSwitch_describe", nil) font:Avenir_Heavy Size:8 spacing:2.46 color:[UIColor whiteColor]];

        
    }else if ([NSLocalizedString(@"language", nil)isEqualToString:@"中文"]){
        [SKAttributeString setLabelFontContent:self.latel title:NSLocalizedString(@"notifications_page_vipSwitch_describe", nil) font:Avenir_Heavy Size:12 spacing:2 color:[UIColor whiteColor]];
    }else{
        [SKAttributeString setLabelFontContent:self.latel title:NSLocalizedString(@"notifications_page_vipSwitch_describe", nil) font:Avenir_Heavy Size:9 spacing:2.46 color:[UIColor whiteColor]];
    }
    
    BOOL Power =  [[NSUserDefaults standardUserDefaults]boolForKey:@"contactPower"];
    
    [self.customSmallSwitch setOn:Power];
    NSLog(@"设置VIP联系人开关%@",Power?@"YES":@"NO");
    
}

-(void)clickSwitch:(customSmallSwitch *)Switch withBOOL:(BOOL)isOn{
    
    NSUserDefaults *powerInfo = [NSUserDefaults standardUserDefaults];
    
    if ([SMContactTool contacts].count == 0 && isOn == YES) {
        
    self.button();
    [self.customSmallSwitch setOn:NO];
    [powerInfo setBool:NO forKey:@"contactPower"];
        return;
    }
    
    NSLog(@"vip联系人开关%@",isOn?@"YES":@"NO");
    
    [powerInfo setBool:isOn forKey:@"contactPower"];
    
    [powerInfo synchronize];
}

- (void)handlerButtonAction:(receiveBlockButton)block{
    self.button = block;
}

@end
