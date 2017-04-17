//
//  SMContactsDescriptionViewController.m
//  Blinq
//
//  Created by zsk on 2016/11/7.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "SMContactsDescriptionViewController.h"

@interface SMContactsDescriptionViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

@end

@implementation SMContactsDescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SKAttributeString setLabelFontContent:self.titleLabel title:@"CONTACTS" font:Avenir_Black Size:44 spacing:6.6 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent:self.label1 title:@"BLINQ LETS YOU CREATE DIFFERENT SETS OF ALERTS FOR CALLS AND TEXT MESSAGES THAT COME FROM SELECTED CONTACTS." font:Avenir_Heavy Size:13 spacing:3.9 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent:self.label2 title:@"INCOMING ALERTS FROM THE FOLLOWING CONTACTS WILL LIGHT UP THE GEMSTONE FOR 5 SECONDS." font:Avenir_Heavy Size:15 spacing:4.5 color:[UIColor whiteColor]];
    
    [SKAttributeString setButtonFontContent:self.okButton title:@"OK" font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
    
}

- (IBAction)goBack:(id)sender {
    
    if ([self.entrance isEqualToString:@"notification"]) {
        [SKUserDefaults setBool:YES forKey:@"notification_contactVcTurnedOn"];
    }else{
        [SKUserDefaults setBool:YES forKey:@"main_contactVcTurnedOn"];
    }
    
    [SKViewTransitionManager dismissViewController:self duration:0.3 transitionType:TransitionPush directionType:TransitionFromLeft];
    
    self.returnBlock();
}

@end
