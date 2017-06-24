//
//  BackgroundViewController.m
//  Blinq
//
//  Created by zsk on 16/10/11.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "BackgroundViewController.h"
#import "SMRegisterViewController.h"

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
    
    if (screenHeight == 480) {
        SMRegisterViewController *registervc = [[SMRegisterViewController alloc]initWithNibName:@"SMRegisterViewController_ip4" bundle:nil];
        
        [self presentViewController:registervc animated:YES completion:nil];
    }else{
        SMRegisterViewController *registervc = [[SMRegisterViewController alloc]initWithNibName:@"SMRegisterViewController" bundle:nil];
        
        [self presentViewController:registervc animated:YES completion:nil];
    }
    

}

@end
