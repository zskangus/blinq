//
//  SMSosDescriptionViewController.m
//  Blinq
//
//  Created by zsk on 2016/11/7.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "SMSosDescriptionViewController.h"

@interface SMSosDescriptionViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation SMSosDescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"bewrite_sos_title", nil) font:Avenir_Black Size:30 spacing:4.5 color:[UIColor whiteColor]];
    
    if ([NSLocalizedString(@"language", nil)isEqualToString:@"German"]) {
        [SKAttributeString setLabelFontContent:self.label1 title:NSLocalizedString(@"bewrite_sos_label1", nil) font:Avenir_Heavy Size:12 spacing:3.5 color:[UIColor whiteColor]];

    }else{
        [SKAttributeString setLabelFontContent:self.label1 title:NSLocalizedString(@"bewrite_sos_label1", nil) font:Avenir_Heavy Size:14 spacing:4.2 color:[UIColor whiteColor]];
    }
    
    [SKAttributeString setLabelFontContent:self.label2 title:NSLocalizedString(@"bewrite_sos_label2", nil) font:Avenir_Heavy Size:10 spacing:3 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent:self.label3 title:NSLocalizedString(@"bewrite_sos_label3", nil) font:Avenir_Heavy Size:10 spacing:3 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent:self.label4 title:NSLocalizedString(@"bewrite_sos_label4", nil) font:Avenir_Light Size:10 spacing:3 color:[UIColor whiteColor]];
    
    [SKAttributeString setButtonFontContent:self.nextButton title:NSLocalizedString(@"bewrite_sos_buttontTitle", nil) font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
    
}
- (IBAction)nextBtn:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    self.returnBlock();
}

@end
