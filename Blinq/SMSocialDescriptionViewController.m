//
//  SMSocialDescriptionViewController.m
//  Blinq
//
//  Created by zsk on 2016/11/7.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "SMSocialDescriptionViewController.h"
#import "SMSocialViewController.h"

@interface SMSocialDescriptionViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

@end

@implementation SMSocialDescriptionViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self setNavigationController];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"bewrite_social_sos_title", nil) font:Avenir_Black Size:30 spacing:4.5 color:[UIColor whiteColor]];
    
    if ([NSLocalizedString(@"language", nil)isEqualToString:@"German"]) {
        
        [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"bewrite_social_sos_title", nil) font:Avenir_Black Size:30 spacing:4.5 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent:self.label1 title:NSLocalizedString(@"bewrite_social_sos_label1", nil) font:Avenir_Heavy Size:13 spacing:4 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent:self.label2 title:NSLocalizedString(@"bewrite_social_sos_label2", nil) font:Avenir_Heavy Size:13 spacing:3 color:[UIColor whiteColor]];
        
        [SKAttributeString setButtonFontContent:self.okButton title:NSLocalizedString(@"notifications_page_buttonTitle", nil) font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }else if ([NSLocalizedString(@"language", nil)isEqualToString:@"中文"]){
        
        [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"bewrite_social_sos_title", nil) font:Avenir_Black Size:30 spacing:4.5 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent:self.label1 title:NSLocalizedString(@"bewrite_social_sos_label1", nil) font:Avenir_Heavy Size:18 spacing:2 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent:self.label2 title:NSLocalizedString(@"bewrite_social_sos_label2", nil) font:Avenir_Heavy Size:18 spacing:2 color:[UIColor whiteColor]];
        
        [SKAttributeString setButtonFontContent:self.okButton title:NSLocalizedString(@"notifications_page_buttonTitle", nil) font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }else{
        
        [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"bewrite_social_sos_title", nil) font:Avenir_Black Size:30 spacing:4.5 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent:self.label1 title:NSLocalizedString(@"bewrite_social_sos_label1", nil) font:Avenir_Heavy Size:16 spacing:4.8 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent:self.label2 title:NSLocalizedString(@"bewrite_social_sos_label2", nil) font:Avenir_Heavy Size:13 spacing:3.9 color:[UIColor whiteColor]];
        
        [SKAttributeString setButtonFontContent:self.okButton title:NSLocalizedString(@"notifications_page_buttonTitle", nil) font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];

    }
    
}

- (void)setNavigationController{
    // 设置背景颜色
    //[self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    // 设置导航栏半透明
    //self.navigationController.navigationBar.translucent = true;
    // 设置导航栏背景图片
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    // 设置导航栏阴影图片
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
}

- (IBAction)gotoSocailVc:(id)sender {
    
    [SKUserDefaults setBool:YES forKey:@"socialTurnedOn"];
    
    [SKViewTransitionManager dismissViewController:self duration:0.3 transitionType:TransitionPush directionType:TransitionFromLeft];
    
//    SMSocialViewController *ic = [[SMSocialViewController alloc]initWithNibName:@"SMSocialViewController" bundle:nil];
//    [self.navigationController pushViewController:ic animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
