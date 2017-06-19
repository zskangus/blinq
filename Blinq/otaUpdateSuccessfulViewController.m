//
//  otaUpdateSuccessfulViewController.m
//  Blinq
//
//  Created by zsk on 16/8/5.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "otaUpdateSuccessfulViewController.h"
#import "CustomProgress.h"

@interface otaUpdateSuccessfulViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *connectStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UIButton *pairButton;


// 电池相关
@property (weak, nonatomic) IBOutlet UIView *batteryView;
@property (weak, nonatomic) IBOutlet UILabel *batteryLevel;
@property (weak, nonatomic) IBOutlet UIView *batteryProgress;
@property (weak, nonatomic) IBOutlet UIImageView *batteryState;
@property (weak, nonatomic) IBOutlet UIImageView *batteryBox;
@property(nonatomic,strong)CustomProgress *customProgress;

@end

@implementation otaUpdateSuccessfulViewController

- (void)viewWillAppear:(BOOL)animated{
    //[SKNotificationCenter addObserver:self selector:@selector(setupOTAUpdateSuccessfulViewBattery) name:batteryStatus object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUi];
    //[self setupOTAUpdateSuccessfulViewBattery];
}

- (void)setupUi{

    
    if ([NSLocalizedString(@"language", nil)isEqualToString:@"German"]) {
        [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"update_successful_page_title", nil) font:Avenir_Black Size:36 spacing:5 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent:self.label1 title:NSLocalizedString(@"update_failed_page_label", nil) font:Avenir_Heavy Size:10 spacing:2 color:[UIColor whiteColor]];
    }else{
        [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"update_successful_page_title", nil) font:Avenir_Black Size:36 spacing:5.4 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent:self.label1 title:NSLocalizedString(@"update_failed_page_label", nil) font:Avenir_Heavy Size:12 spacing:2.6 color:[UIColor whiteColor]];
    }
    
//    [SKAttributeString setLabelFontContent:self.label2 title:@"YOUR RING IS NOW" font:Avenir_Heavy Size:12 spacing:3.6 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent:self.label3 title:NSLocalizedString(@"update_successful_page_describe", nil) font:Avenir_Heavy Size:12 spacing:3.6 color:[UIColor whiteColor]];
    
//    [SKAttributeString setLabelFontContent:self.connectStateLabel title:@"CONNECTED" font:Avenir_Heavy Size:24 spacing:3.6 color:[UIColor whiteColor]];
    
    [SKAttributeString setButtonFontContent:self.pairButton title:NSLocalizedString(@"update_failed_page_button", nil) font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
    
//    update_successful_page_title = "ERFOLGREICH";
//    update_failed_page_label = "IHR RING IST JETZT AUF DEM NEUESTEN STAND";
//    update_successful_page_describe = "IHR RING WURDE AUF DIE AKTUELLSTE UND BESTE SOFTWAREVERSION AKTUALISIERT.";
//    update_failed_page_button = "ERLEDIGT";
}


- (void)setupOTAUpdateSuccessfulViewBattery{
    
//    BOOL batteryState = [[NSUserDefaults standardUserDefaults]boolForKey:@"batteryStatus"];
//    
//    self.batteryState.hidden = !batteryState;
//    
//    NSNumber *battery = [[NSUserDefaults standardUserDefaults]objectForKey:@"battery"];
//    
//    NSInteger batteryLevel = [battery integerValue];
//    
//    NSLog(@"设置界面电量%ld",batteryLevel);
//    
//    self.batteryBox.image =[self.batteryBox.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    
//    if (batteryLevel <= 5) {
//        self.batteryBox.tintColor = [UIColor redColor];
//    }else{
//        self.batteryBox.tintColor = [UIColor whiteColor];
//    }
//    
//    self.customProgress = [[CustomProgress alloc] initWithFrame:CGRectMake(0.75f, 0.75f, 21, 8)];
//    
//    self.customProgress.maxValue = 100;
//    
//    self.batteryLevel.text = [NSString stringWithFormat: @"%ld%%", batteryLevel];
//    
//    [self.customProgress setProgressValue:batteryLevel];
//    
//    [self.batteryView addSubview:self.customProgress];
}

- (IBAction)pairRing:(id)sender {
    
    UIViewController *vc = self;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
        NSLog(@"当前控制器%@",vc.title);
        
        if ([vc.title isEqualToString:@"sidebar"]) {
            
            [vc dismissViewControllerAnimated:YES completion:nil];
            
            return;
        }
    }
    [vc dismissViewControllerAnimated:YES completion:nil];
}

@end
