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

    if ([NSLocalizedString(@"language", nil)isEqualToString:@"German"]) {
        [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"update_available_page_title", nil) font:Avenir_Black Size:32 spacing:4.8 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent:self.label title:NSLocalizedString(@"update_available_page_lable", nil) font:Avenir_Heavy Size:12 spacing:3.6 color:[UIColor whiteColor]];
        
        CGRect frame = self.label.frame;
        frame.size.height += 40;
        self.label.frame = frame;
        
        [SKAttributeString setButtonFontContent:self.updateButton title:NSLocalizedString(@"update_available_page_buttonTitle1", nil) font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [SKAttributeString setButtonFontContent:self.notNowButton title:NSLocalizedString(@"update_available_page_buttonTitle2", nil) font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }else if ([NSLocalizedString(@"language", nil)isEqualToString:@"中文"]){
        [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"update_available_page_title", nil) font:Avenir_Black Size:32 spacing:4.8 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent:self.label title:NSLocalizedString(@"update_available_page_lable", nil) font:Avenir_Heavy Size:18 spacing:1 color:[UIColor whiteColor]];
        
        [SKAttributeString setButtonFontContent:self.updateButton title:NSLocalizedString(@"update_available_page_buttonTitle1", nil) font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [SKAttributeString setButtonFontContent:self.notNowButton title:NSLocalizedString(@"update_available_page_buttonTitle2", nil) font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"update_available_page_title", nil) font:Avenir_Black Size:32 spacing:4.8 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent:self.label title:NSLocalizedString(@"update_available_page_lable", nil) font:Avenir_Heavy Size:12 spacing:3.6 color:[UIColor whiteColor]];
        
        [SKAttributeString setButtonFontContent:self.updateButton title:NSLocalizedString(@"update_available_page_buttonTitle1", nil) font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [SKAttributeString setButtonFontContent:self.notNowButton title:NSLocalizedString(@"update_available_page_buttonTitle2", nil) font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
    }

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
