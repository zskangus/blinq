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
    
//    CATransition * animation = [CATransition animation];
//    
//    animation.duration = 0.3;    //  时间
//    
//    /**  type：动画类型
//     *  pageCurl       向上翻一页
//     *  pageUnCurl     向下翻一页
//     *  rippleEffect   水滴
//     *  suckEffect     收缩
//     *  cube           方块
//     *  oglFlip        上下翻转
//     */
//    //animation.type = @"pageCurl";
//    
//    /**  type：页面转换类型
//     *  kCATransitionFade       淡出
//     *  kCATransitionMoveIn     覆盖
//     *  kCATransitionReveal     底部显示
//     *  kCATransitionPush       推出
//     */
//    animation.type = kCATransitionPush;
//    
//    //PS：type 更多效果请 搜索： CATransition
//    
//    /**  subtype：出现的方向
//     *  kCATransitionFromRight       右
//     *  kCATransitionFromLeft        左
//     *  kCATransitionFromTop         上
//     *  kCATransitionFromBottom      下
//     */
//    animation.subtype = kCATransitionFromLeft;
//    
//    [self.view.window.layer addAnimation:animation forKey:nil];
//    
//    [self dismissViewControllerAnimated:NO completion:nil];
    
    SMSocialViewController *ic = [[SMSocialViewController alloc]initWithNibName:@"SMSocialViewController" bundle:nil];
    [self.navigationController pushViewController:ic animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
