//
//  SMRegisterSuccessfullyViewController.m
//  Blinq
//
//  Created by zsk on 2016/12/27.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "SMRegisterSuccessfullyViewController.h"
#import "SMBindingViewController.h"

@interface SMRegisterSuccessfullyViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation SMRegisterSuccessfullyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"register_successful_page_title", nil) font:Avenir_Black Size:38 spacing:5.7 color:[UIColor whiteColor]];
    
    if ([NSLocalizedString(@"language", nil)isEqualToString:@"German"]) {
        [SKAttributeString setLabelFontContent2:self.label title:NSLocalizedString(@"register_successful_page_label", nil) font:Avenir_Heavy Size:13 spacing:3 color:[UIColor whiteColor]];

    }else{
        [SKAttributeString setLabelFontContent2:self.label title:NSLocalizedString(@"register_successful_page_label", nil) font:Avenir_Heavy Size:13 spacing:3.9 color:[UIColor whiteColor]];
    }
    
    [SKAttributeString setButtonFontContent:self.button title:NSLocalizedString(@"register_successful_page_buttonTitle", nil) font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
}
- (IBAction)buttonTouchEvent:(id)sender {
    
    if (screenHeight == 480) {
        SMBindingViewController *bind = [[SMBindingViewController alloc]initWithNibName:@"SMBindingViewController_ip4" bundle:nil];
        [self presentViewController:bind animated:YES completion:nil];
    }else{
        SMBindingViewController *bind = [[SMBindingViewController alloc]initWithNibName:@"SMBindingViewController" bundle:nil];
        [self presentViewController:bind animated:YES completion:nil];
    }
}

@end
