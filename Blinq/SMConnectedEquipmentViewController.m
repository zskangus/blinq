//
//  SMConnectedEquipmentViewController.m
//  Blinq
//
//  Created by zsk on 16/3/25.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "SMConnectedEquipmentViewController.h"
#import "SMConnectedSuccessViewController.h"
#import "SMConnectionFailureViewController.h"

#import "BTServer.h"
#import "AppConstant.h"
#import "PeriperalInfo.h"
#import "NSUserDefaultsHelper.h"

#import "otaUpdateProgress.h"

@interface SMConnectedEquipmentViewController ()
{
    
    PeriperalInfo * currentinfo;
}

@property (weak, nonatomic) IBOutlet UIView *chart;

@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)BTServer *ble;
@property (weak, nonatomic) IBOutlet UILabel *lebel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

// 进度条的四个圈
@property(nonatomic,strong)otaUpdateProgress *progress1;
@property(nonatomic,strong)otaUpdateProgress *progress2;
@property(nonatomic,strong)otaUpdateProgress *progress3;
@property(nonatomic,strong)otaUpdateProgress *progress4;

@end

@implementation SMConnectedEquipmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ble = [BTServer sharedBluetooth];
    [self.ble initBLE];
    
    if ([self.ble isNeedReConnect]) {
        [self.ble reConnectPeripheral];
    }else{
        [self.ble scan];
    }
    
    [SKAttributeString setLabelFontContent:self.titleLabel title:@"PLEASE WAIT" font:Avenir_Black Size:36 spacing:5.4 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent:self.lebel title:@"WE ARE ATTEMPTING TO PAIR YOUR DEVICE. MAKE SURE YOUR RING IS CHARGED AND WITHIN RANGE." font:Avenir_Heavy Size:12 spacing:3.6 color:[UIColor whiteColor]];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pageJump:) name:@"connectStateNotifcation" object:nil];
    
    [self setupotaUpdateProgressUi];
    
    //每隔0.01秒刷新一次页面
    
    _seconds = 0;
    
    _timer=[NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(runAction) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)pageJump:(NSNotification*)notification{
    [self performSelector:@selector(delayPageJump:) withObject:[notification object] afterDelay:1.0f];
}

- (void)delayPageJump:(NSNumber*)obj{
    
    NSNumber *boolNum = obj;
    
    BOOL isConnect = [boolNum boolValue];
    
    if (isConnect) {
        // 连接成功进入 成功界面
        NSLog(@"跳转到连接成功界面");
        SMConnectedSuccessViewController *success = [[SMConnectedSuccessViewController alloc]initWithNibName:@"SMConnectedSuccessViewController" bundle:nil];
        [self presentViewController:success animated:YES completion:nil];
    }else{
        // 连接失败进图 失败界面
        NSLog(@"跳转到连接失败界面");
        SMConnectionFailureViewController *failure = [[SMConnectionFailureViewController alloc]initWithNibName:@"SMConnectionFailureViewController" bundle:nil];
        [self presentViewController:failure animated:YES completion:nil];
    }
}

#pragma mark - runAction
static NSInteger _seconds;
- (void) runAction

{
    _seconds++;
    
    //动态改变开始时间
    
    NSString * startTime=[NSString stringWithFormat:@"%02li.%02li",_seconds/100%60,_seconds%100];

    double progress = [startTime floatValue]/30;
    
    //NSLog(@"%f",progress);

    if (progress < 1) {
        [self setOtaProgressValue:progress];
    }else{
        
        [self.timer setFireDate:[NSDate distantFuture]];
        self.timer = nil;
        
        // 连接失败进图 失败界面
        
        if (screenHeight == 480) {
            SMConnectionFailureViewController *failure = [[SMConnectionFailureViewController alloc]initWithNibName:@"SMConnectionFailureViewController_ip4" bundle:nil];
            [self presentViewController:failure animated:YES completion:nil];

        }else{
            SMConnectionFailureViewController *failure = [[SMConnectionFailureViewController alloc]initWithNibName:@"SMConnectionFailureViewController" bundle:nil];
            [self presentViewController:failure animated:YES completion:nil];

        }
    }
    
    
}

- (void)setupotaUpdateProgressUi{
    
    CGFloat progressSize = 0;
    
    if (screenHeight == 480) {
        progressSize = 155;
    }else{
        progressSize = 215;
    }
    

    
    self.progress1 = [[otaUpdateProgress alloc]initWithFrame:CGRectMake(0, 0, progressSize, progressSize)];
    self.progress1.progresscolor = RGB_COLOR(80, 210, 194);
    [self.chart addSubview:self.progress1];
    
    self.progress2 = [[otaUpdateProgress alloc]initWithFrame:CGRectMake(0, 0, progressSize*0.8, progressSize*0.8)];
    self.progress2.progresscolor = RGB_COLOR(210, 80, 170);
    self.progress2.center = self.progress1.center;
    [self.chart addSubview:self.progress2];
    
    self.progress3 = [[otaUpdateProgress alloc]initWithFrame:CGRectMake(0, 0, progressSize*0.6, progressSize*0.6)];
    self.progress3.progresscolor = RGB_COLOR(74, 144, 226);
    self.progress3.center = self.progress1.center;
    [self.chart addSubview:self.progress3];
    
    self.progress4 = [[otaUpdateProgress alloc]initWithFrame:CGRectMake(0, 0, progressSize*0.4, progressSize*0.4)];
    self.progress4.progresscolor = RGB_COLOR(206, 139, 212);
    self.progress4.center = self.progress1.center;
    [self.chart addSubview:self.progress4];
}

- (void)setOtaProgressValue:(double)value{
    self.progress1.progressvalue = value*1.7;
    self.progress2.progressvalue = value*1.5;
    self.progress3.progressvalue = value*1.3;
    self.progress4.progressvalue = value;
}

//页面消失，进入后台不显示该页面，关闭定时器
-(void)viewDidDisappear:(BOOL)animated
{
    //关闭定时器
    [self.timer invalidate];
    self.timer = nil;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



@end
