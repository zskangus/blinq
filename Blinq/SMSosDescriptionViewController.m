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
    [SKAttributeString setLabelFontContent:self.titleLabel title:@"TAP TAP TAP" font:Avenir_Black Size:30 spacing:4.5 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent:self.label1 title:@"TAP THE RING REPEATEDLY UNTIL VIBRATION IS FELT TO SEND AN EMERGENCY MESSAGE" font:Avenir_Heavy Size:14 spacing:4.2 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent:self.label2 title:@"IN THE EVENT OF AN EMERGENCY THE S.O.S. FEATURE ALLOWS YOU TO SEND A TEXT MESSAGE WITH YOUR LOCATION TO ANY PRESELECTED CONTACT." font:Avenir_Heavy Size:10 spacing:3 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent:self.label3 title:@"BLINQ IS NOT A SUBSTITUTE FOR 911 OR ANY EMERGENCY SERVICES. BLINQ IS AN EXTRA LAYER OF SECURITY AND PEACE OF MIND." font:Avenir_Heavy Size:10 spacing:3 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent:self.label4 title:@"NORMAL CARRIER RATES APPLY" font:Avenir_Light Size:10 spacing:3 color:[UIColor whiteColor]];
    
    [SKAttributeString setButtonFontContent:self.nextButton title:self.bottomButtonTitle font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
}
- (IBAction)nextBtn:(id)sender {
    
    
    
    [self dismissViewControllerAnimated:NO completion:nil];
    self.returnBlock();
}

@end
