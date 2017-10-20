//
//  SMSosDescriptionViewController.m
//  Blinq
//
//  Created by zsk on 2016/11/7.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "SMSosDescriptionViewController.h"
#import "SMUserInfoViewController.h"
#import "SKViewTransitionManager.h"

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
    
    if ([NSLocalizedString(@"language", nil)isEqualToString:@"German"]) {
        
        [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"bewrite_sos_title", nil) font:Avenir_Black Size:30 spacing:4.5 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent:self.label1 title:NSLocalizedString(@"bewrite_sos_label1", nil) font:Avenir_Heavy Size:12 spacing:3.5 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent:self.label2 title:NSLocalizedString(@"bewrite_sos_label2", nil) font:Avenir_Heavy Size:10 spacing:3 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent:self.label3 title:NSLocalizedString(@"bewrite_sos_label3", nil) font:Avenir_Heavy Size:10 spacing:3 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent:self.label4 title:NSLocalizedString(@"bewrite_sos_label4", nil) font:Avenir_Light Size:10 spacing:3 color:[UIColor whiteColor]];
        
        [SKAttributeString setButtonFontContent:self.nextButton title:NSLocalizedString(@"bewrite_notification_buttontTitle", nil) font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];


    }else if ([NSLocalizedString(@"language", nil)isEqualToString:@"中文"]){
    
        [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"bewrite_sos_title", nil) font:Avenir_Black Size:30 spacing:4.5 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent:self.label1 title:NSLocalizedString(@"bewrite_sos_label1", nil) font:Avenir_Heavy Size:18 spacing:0 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent:self.label2 title:NSLocalizedString(@"bewrite_sos_label2", nil) font:Avenir_Heavy Size:18 spacing:0 color:[UIColor whiteColor]];
        
        CGRect label2Frame = self.label2.frame;
        label2Frame.size.width += 20;
        label2Frame.origin.x -= 10;
        self.label2.frame = label2Frame;
        
        [SKAttributeString setLabelFontContent:self.label3 title:NSLocalizedString(@"bewrite_sos_label3", nil) font:Avenir_Heavy Size:18 spacing:0 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent:self.label4 title:NSLocalizedString(@"bewrite_sos_label4", nil) font:Avenir_Light Size:18 spacing:2 color:[UIColor whiteColor]];
        
        [SKAttributeString setButtonFontContent:self.nextButton title:self.bottomButtonTitle font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }else{
        [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"bewrite_sos_title", nil) font:Avenir_Black Size:30 spacing:4.5 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent:self.label1 title:NSLocalizedString(@"bewrite_sos_label1", nil) font:Avenir_Heavy Size:14 spacing:4.2 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent:self.label2 title:NSLocalizedString(@"bewrite_sos_label2", nil) font:Avenir_Heavy Size:10 spacing:3 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent:self.label3 title:NSLocalizedString(@"bewrite_sos_label3", nil) font:Avenir_Heavy Size:10 spacing:3 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent:self.label4 title:NSLocalizedString(@"bewrite_sos_label4", nil) font:Avenir_Light Size:10 spacing:3 color:[UIColor whiteColor]];
        
        [SKAttributeString setButtonFontContent:self.nextButton title:self.bottomButtonTitle font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
}
- (IBAction)nextBtn:(id)sender {
    
    SMUserInfoViewController *userInfo = [[SMUserInfoViewController alloc]initWithNibName:@"SMUserInfoViewController" bundle:nil];
    
    userInfo.bottomButtonTitle = self.bottomButtonTitle;
    
    [SKViewTransitionManager presentModalViewControllerFrom:self to:userInfo duration:0.3 transitionType:TransitionPush directionType:TransitionFromRight];
    

    userInfo.returnBlock = ^(){
            [self dismissViewControllerAnimated:NO completion:nil];
            self.returnBlock();
    };
//
    
}

@end
