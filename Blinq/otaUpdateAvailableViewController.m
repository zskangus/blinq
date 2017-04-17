//
//  otaUpdateAvailableViewController.m
//  Blinq
//
//  Created by zsk on 16/8/4.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "otaUpdateAvailableViewController.h"
#import "otaUpgradeViewController.h"

@interface otaUpdateAvailableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@property (weak, nonatomic) IBOutlet UIButton *notNowButton;

@end

@implementation otaUpdateAvailableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUi];
}

- (void)setupUi{
    [SKAttributeString setLabelFontContent:self.titleLabel title:@"UPDATE AVAILABLE" font:Avenir_Black Size:32 spacing:4.8 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent:self.label title:@"PLEASE MAKE SURE YOUR RING IS CONNECTED TO THE CHARGER BEFORE YOU UPDATE TO ENSURE THAT IT STAYS CONNECTED." font:Avenir_Heavy Size:12 spacing:3.6 color:[UIColor whiteColor]];
    
    [SKAttributeString setButtonFontContent:self.updateButton title:@"UPDATE NOW" font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [SKAttributeString setButtonFontContent:self.notNowButton title:@"NOT NOW" font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (IBAction)updateButton:(id)sender {
    otaUpgradeViewController *ota = [[otaUpgradeViewController alloc]initWithNibName:@"otaUpgradeViewController" bundle:nil];
    [self presentViewController:ota animated:YES completion:nil]; 
}

- (IBAction)notNow:(id)sender {
    
    [SKUserDefaults setBool:NO forKey:@"whetherNeedToRremindTheUserUpdate"];
    
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