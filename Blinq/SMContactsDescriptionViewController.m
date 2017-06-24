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
    
    
    if ([NSLocalizedString(@"language", nil)isEqualToString:@"German"]) {
        [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"contacts_page_title", nil) font:Avenir_Black Size:40 spacing:6.6 color:[UIColor whiteColor]];
    }else{
        [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"contacts_page_title", nil) font:Avenir_Black Size:44 spacing:6.6 color:[UIColor whiteColor]];
    }
    
    [SKAttributeString setLabelFontContent:self.label1 title:NSLocalizedString(@"contacts_page_label1", nil) font:Avenir_Heavy Size:13 spacing:3.9 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent:self.label2 title:NSLocalizedString(@"contacts_page_label2", nil) font:Avenir_Heavy Size:15 spacing:4.5 color:[UIColor whiteColor]];
    
    [SKAttributeString setButtonFontContent:self.okButton title:NSLocalizedString(@"contacts_page_buttonTitle", nil) font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    if ([NSLocalizedString(@"language", nil)isEqualToString:@"German"]) {
        [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"contacts_page_title", nil) font:Avenir_Black Size:40 spacing:6.6 color:[UIColor whiteColor]];

        [SKAttributeString setLabelFontContent:self.label1 title:NSLocalizedString(@"contacts_page_label1", nil) font:Avenir_Heavy Size:13 spacing:3.9 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent:self.label2 title:NSLocalizedString(@"contacts_page_label2", nil) font:Avenir_Heavy Size:15 spacing:4.5 color:[UIColor whiteColor]];
        
        [SKAttributeString setButtonFontContent:self.okButton title:NSLocalizedString(@"contacts_page_buttonTitle", nil) font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
    }else if ([NSLocalizedString(@"language", nil)isEqualToString:@"中文"]){
        [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"contacts_page_title", nil) font:Avenir_Black Size:44 spacing:6.6 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent:self.label1 title:NSLocalizedString(@"contacts_page_label1", nil) font:Avenir_Heavy Size:18 spacing:5 color:[UIColor whiteColor]];
        
        CGRect label1Frame = self.label1.frame;
        label1Frame.size.width += 50;
        label1Frame.origin.x -= 25;
        self.label1.frame = label1Frame;
        
        
        [SKAttributeString setLabelFontContent:self.label2 title:NSLocalizedString(@"contacts_page_label2", nil) font:Avenir_Heavy Size:18 spacing:5 color:[UIColor whiteColor]];
        
        [SKAttributeString setButtonFontContent:self.okButton title:NSLocalizedString(@"contacts_page_buttonTitle", nil) font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"contacts_page_title", nil) font:Avenir_Black Size:44 spacing:6.6 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent:self.label1 title:NSLocalizedString(@"contacts_page_label1", nil) font:Avenir_Heavy Size:13 spacing:3.9 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent:self.label2 title:NSLocalizedString(@"contacts_page_label2", nil) font:Avenir_Heavy Size:15 spacing:4.5 color:[UIColor whiteColor]];
        
        [SKAttributeString setButtonFontContent:self.okButton title:NSLocalizedString(@"contacts_page_buttonTitle", nil) font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
    }
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
