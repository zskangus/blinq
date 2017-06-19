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
    [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"notifications_page_title", nil) font:Avenir_Black Size:30 spacing:4.5 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent2:self.label1 title:NSLocalizedString(@"notifications_page_label1", nil) font:Avenir_Heavy Size:15 spacing:4.5 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent2:self.label2 title:NSLocalizedString(@"notifications_page_label2", nil) font:Avenir_Heavy Size:15 spacing:4.5 color:[UIColor whiteColor]];
    
    [SKAttributeString setButtonFontContent:self.okButton title:NSLocalizedString(@"notifications_page_buttonTitle", nil) font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if ([NSLocalizedString(@"language", nil)isEqualToString:@"German"]) {
        [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"notifications_page_title", nil) font:Avenir_Black Size:18 spacing:4.5 color:[UIColor whiteColor]];

        
        CGRect label1frame = self.label1.frame;
        label1frame.size.height += 20;
        self.label1.frame = label1frame;
        
        [SKAttributeString setLabelFontContent2:self.label2 title:NSLocalizedString(@"notifications_page_label2", nil) font:Avenir_Heavy Size:13 spacing:4 color:[UIColor whiteColor]];
        
        CGRect label2 = self.label2.frame;
        label2.size.width += 10;
        label2.origin.x -= 5;
        self.label2.frame = label2;
        
        //self.label2.backgroundColor =[UIColor redColor];

    }
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
