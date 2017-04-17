//
//  SKNotificationIntroduce.m
//  Blinq
//
//  Created by zsk on 2017/1/20.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import "SKNotificationIntroduce.h"
#import "SMSSidebarViewController.h"
#import "SMMainMenuViewController.h"
#import "SMContentViewController.h"

@interface SKNotificationIntroduce ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIButton *okButton;


@end

@implementation SKNotificationIntroduce

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [SKAttributeString setLabelFontContent:self.titleLabel title:@"NOTIFICATIONS" font:Avenir_Black Size:30 spacing:4.5 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent2:self.label1 title:@"PHONE, TEXT AND APP NOTIFICATIONS WILL BLINK THE RING 3 TIMES." font:Avenir_Heavy Size:15 spacing:4.5 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent2:self.label2 title:@"SELECTED CONTACT ALERTS WILL LIGHT UP THE GEMSTONE FOR 5 SECONDS AT A TIME." font:Avenir_Heavy Size:15 spacing:4.5 color:[UIColor whiteColor]];
    
    [SKAttributeString setButtonFontContent:self.okButton title:@"NEXT" font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
}
- (IBAction)goVc:(id)sender {
    
    SMMainMenuViewController *mainMenu = [[SMMainMenuViewController alloc]initWithNibName:@"SMMainMenuViewController" bundle:nil];
    
    SMContentViewController *contentVie = [[SMContentViewController alloc]init];
    
    UINavigationController *nvcMenu = [[UINavigationController alloc]initWithRootViewController:mainMenu];
    
    UINavigationController *nvcsidebar = [[UINavigationController alloc]initWithRootViewController:contentVie];
    
    SMSSidebarViewController *sidebar = [[SMSSidebarViewController alloc]initWithCenterController:nvcsidebar leftController:nvcMenu];
    
    [self presentViewController:sidebar animated:YES completion:nil];
}



@end
