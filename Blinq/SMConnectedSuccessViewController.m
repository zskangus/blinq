//
//  SMConnectedSuccessViewController.m
//  Blinq
//
//  Created by zsk on 16/3/25.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "SMConnectedSuccessViewController.h"
#import "SMConnectionFailureViewController.h"
#import "SKNotificationIntroduce.h"
#import "BTServer.h"
#import "CustomProgress.h"


@interface SMConnectedSuccessViewController ()

//---------- 获取手机APP信息 --------


// 存放app配置信息的数组 (从戒指里获取到的信息)
@property(nonatomic,strong)CustomProgress *customProgress;

@property (weak, nonatomic) IBOutlet UILabel *batteryLabel;

@property (weak, nonatomic) IBOutlet UIView *batteryView;

@property (weak, nonatomic) IBOutlet UIButton *getStarted;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIImageView *batteryState;
@property (weak, nonatomic) IBOutlet UIImageView *batteryBox;
@property (weak, nonatomic) IBOutlet UILabel *batteryLoading;

@property(nonatomic,strong)BTServer *ble;

@end

@implementation SMConnectedSuccessViewController

- (BTServer *)ble{
    if (_ble == nil) {
        _ble = [BTServer sharedBluetooth];
    }
    return _ble;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [SKNotificationCenter addObserver:self selector:@selector(batteryLevelUpdated) name:@"batteryLevelUpdated" object:nil];
    
    [SKNotificationCenter addObserver:self selector:@selector(batteryLevelUpdated) name:@"batteryChargerStateChanged" object:nil];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupBatteryProgressUI];
    
    [self batteryLevelUpdated];
    
    [SKAttributeString setLabelFontContent:self.label1 title:@"YOUR RING IS NOW" font:Avenir_Heavy Size:12 spacing:3.6 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent:self.label2 title:@"CONNECTED" font:Avenir_Heavy Size:24 spacing:3.6 color:[UIColor whiteColor]];

    [SKAttributeString setButtonFontContent:self.getStarted title:@"GET STARTED" font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
    NSLog(@"进入链接成功界面");

}


- (void)batteryLevelUpdated{
    
    BOOL batteryCheckState = [SKUserDefaults boolForKey:@"batteryCheckState"];
    
    // 是否是充电状态
    BOOL batteryState = [SKUserDefaults boolForKey:@"batteryStatus"];
    
    NSNumber *battery = [SKUserDefaults objectForKey:@"defaultBattery"];
    
    NSInteger batteryLevel = [battery integerValue];
    
    if (batteryCheckState == NO) {// 如果在电量检查没通过还在检查中
        self.batteryView.hidden = YES;
        self.batteryLabel.hidden = YES;
        self.batteryState.hidden = YES;
        self.batteryLoading.hidden = NO;
        
        [SKAttributeString setLabelFontContent:self.batteryLoading title:@"LOADING" font:Avenir_Heavy Size:12 spacing:3.6 color:[UIColor whiteColor]];
    }else{
        
        self.batteryView.hidden = NO;
        self.batteryLabel.hidden = NO;
        self.batteryLoading.hidden = YES;
        
        self.batteryLabel.text = [NSString stringWithFormat: @"%ld%%", batteryLevel];
        
        self.batteryState.hidden = !batteryState;
        
        [self.customProgress setProgressValue:batteryLevel];
    }
}


- (void)setupBatteryProgressUI{
    
    self.customProgress = [[CustomProgress alloc] initWithFrame:CGRectMake(0.75f, 0.75f, 21, 8)];
    
    self.customProgress.maxValue = 100;
    
    [self.batteryView addSubview:self.customProgress];
    
}

- (IBAction)started:(id)sender {
    
    SKNotificationIntroduce *introduce = [[SKNotificationIntroduce alloc]initWithNibName:@"SKNotificationIntroduce" bundle:nil];
    [self presentViewController:introduce animated:YES completion:nil];
    
}

@end
