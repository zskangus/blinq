//
//  BackgroundViewController.m
//  Blinq
//
//  Created by zsk on 16/10/11.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "BackgroundViewController.h"
#import "SMRegisterViewController.h"
#import "SMBindingViewController.h"

@interface BackgroundViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation BackgroundViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    if ([NSLocalizedString(@"language", nil)isEqualToString:@"German"]) {
        [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"bewrite_background_title", nil) font:Avenir_Black Size:30 spacing:5.1 color:[UIColor whiteColor]];
        [SKAttributeString setLabelFontContent:self.label1 title:NSLocalizedString(@"bewrite_background_label1", nil) font:Avenir_Heavy Size:13 spacing:3.9 color:[UIColor whiteColor]];
        [SKAttributeString setLabelFontContent:self.label2 title:NSLocalizedString(@"bewrite_background_label2", nil) font:Avenir_Heavy Size:18 spacing:5.4 color:[UIColor whiteColor]];
        [SKAttributeString setButtonFontContent:self.nextButton title:NSLocalizedString(@"bewrite_background_buttontTitle", nil) font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
    }else if ([NSLocalizedString(@"language", nil)isEqualToString:@"中文"]){
        [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"bewrite_background_title", nil) font:Avenir_Black Size:30 spacing:5.1 color:[UIColor whiteColor]];
        [SKAttributeString setLabelFontContent:self.label1 title:NSLocalizedString(@"bewrite_background_label1", nil) font:Avenir_Heavy Size:18 spacing:5.4 color:[UIColor whiteColor]];
        [SKAttributeString setLabelFontContent:self.label2 title:NSLocalizedString(@"bewrite_background_label2", nil) font:Avenir_Heavy Size:18 spacing:5.4 color:[UIColor whiteColor]];
        [SKAttributeString setButtonFontContent:self.nextButton title:NSLocalizedString(@"bewrite_background_buttontTitle", nil) font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"bewrite_background_title", nil) font:Avenir_Black Size:34 spacing:5.1 color:[UIColor whiteColor]];
        [SKAttributeString setLabelFontContent:self.label1 title:NSLocalizedString(@"bewrite_background_label1", nil) font:Avenir_Heavy Size:13 spacing:3.9 color:[UIColor whiteColor]];
        [SKAttributeString setLabelFontContent:self.label2 title:NSLocalizedString(@"bewrite_background_label2", nil) font:Avenir_Heavy Size:18 spacing:5.4 color:[UIColor whiteColor]];
        [SKAttributeString setButtonFontContent:self.nextButton title:NSLocalizedString(@"bewrite_background_buttontTitle", nil) font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (IBAction)goVc:(id)sender {
    
    SMPersonalModel *userInfo = [[SMPersonalModel alloc]init];
//    userInfo.familyName = firstName;
//    userInfo.givenName = lastName;
    userInfo.heightString = @"6'0\"";
    userInfo.heightRow = 58;
    userInfo.heightComponent = 0;
    userInfo.weight = 150;
    userInfo.weightRow = 119;
    userInfo.weightComponent = 0;
    userInfo.birthday = @"2000-1-1";
    userInfo.age = 17;
    
    [SMBlinqInfo setUserInfo:userInfo];
    
    [SMBlinqInfo setIsFirstTimeInStepPage:YES];
    
    SMBindingViewController *bind = [[SMBindingViewController alloc]initWithNibName:@"SMBindingViewController" bundle:nil];
    [self presentViewController:bind animated:YES completion:nil];

}

@end
