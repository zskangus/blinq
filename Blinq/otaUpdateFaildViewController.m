//
//  otaUpdateFaildViewController.m
//  Blinq
//
//  Created by zsk on 16/8/8.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "otaUpdateFaildViewController.h"

@interface otaUpdateFaildViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *labelOne;
@property (weak, nonatomic) IBOutlet UILabel *labelTwo;
@property (weak, nonatomic) IBOutlet UILabel *labelThree;
@property (weak, nonatomic) IBOutlet UIButton *tryAgainButton;
@property (weak, nonatomic) IBOutlet UIButton *notNowButton;

@end

@implementation otaUpdateFaildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUi];
}

- (void)setupUi{
    
    if ([NSLocalizedString(@"language", nil)isEqualToString:@"German"]) {
        [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"update_failed_page_title", nil) font:Avenir_Black Size:25 spacing:4.8 color:[UIColor whiteColor]];
        
        CGRect frame = self.titleLabel.frame;
        frame.size.width += 100;
        frame.origin.x -= 50;
        self.titleLabel.frame = frame;
        
        [SKAttributeString setLabelFontContent:self.labelOne title:NSLocalizedString(@"update_failed__page_describe", nil) font:Avenir_Heavy Size:11 spacing:3.3 color:[UIColor whiteColor]];
        
        CGRect labelOneFrame = self.labelOne.frame;
        labelOneFrame.size.width += 50;
        labelOneFrame.origin.x -= 25;
        self.labelOne.frame = labelOneFrame;
        
        [SKAttributeString setLabelFontContent:self.labelTwo title:NSLocalizedString(@"update_failed_page_label1", nil) font:Avenir_Heavy Size:12 spacing:3.5 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent2:self.labelThree title:NSLocalizedString(@"update_failed_page_label2", nil) font:Avenir_Heavy Size:12 spacing:3.5 color:[UIColor whiteColor]];
        
        [SKAttributeString setButtonFontContent:self.tryAgainButton title:NSLocalizedString(@"update_failed_page_button1", nil) font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
        [SKAttributeString setButtonFontContent:self.notNowButton title:NSLocalizedString(@"update_failed_page_button2", nil) font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }else if ([NSLocalizedString(@"language", nil)isEqualToString:@"中文"]){
        
        [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"update_failed_page_title", nil) font:Avenir_Black Size:32 spacing:4.8 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent:self.labelOne title:NSLocalizedString(@"update_failed__page_describe", nil) font:Avenir_Heavy Size:18 spacing:3.3 color:[UIColor whiteColor]];
        self.labelOne.textAlignment = NSTextAlignmentCenter;
        
        [SKAttributeString setLabelFontContent:self.labelTwo title:NSLocalizedString(@"update_failed_page_label1", nil) font:Avenir_Heavy Size:18 spacing:3.5 color:[UIColor whiteColor]];
        self.labelTwo.textAlignment = NSTextAlignmentCenter;
        
        [SKAttributeString setLabelFontContent2:self.labelThree title:NSLocalizedString(@"update_failed_page_label2", nil) font:Avenir_Heavy Size:18 spacing:3.5 color:[UIColor whiteColor]];
        self.labelThree.textAlignment = NSTextAlignmentCenter;

        
        [SKAttributeString setButtonFontContent:self.tryAgainButton title:NSLocalizedString(@"update_failed_page_button1", nil) font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
        [SKAttributeString setButtonFontContent:self.notNowButton title:NSLocalizedString(@"update_failed_page_button2", nil) font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"update_failed_page_title", nil) font:Avenir_Black Size:32 spacing:4.8 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent:self.labelOne title:NSLocalizedString(@"update_failed__page_describe", nil) font:Avenir_Heavy Size:11 spacing:3.3 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent:self.labelTwo title:NSLocalizedString(@"update_failed_page_label1", nil) font:Avenir_Heavy Size:12 spacing:3.5 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent2:self.labelThree title:NSLocalizedString(@"update_failed_page_label2", nil) font:Avenir_Heavy Size:12 spacing:3.5 color:[UIColor whiteColor]];
        
        [SKAttributeString setButtonFontContent:self.tryAgainButton title:NSLocalizedString(@"update_failed_page_button1", nil) font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
        [SKAttributeString setButtonFontContent:self.notNowButton title:NSLocalizedString(@"update_failed_page_button2", nil) font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
    }

}

- (IBAction)tryAgain:(id)sender {
    
    BOOL connectStatus = [SKUserDefaults boolForKey:@"connectStatus"];
    
    if (connectStatus) {// 如果还在连接状态
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        
        NSString *message = NSLocalizedString(@"tip_disconnect", nil);
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"warning", nil) message:[message uppercaseString] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
                //[self dismissViewController];
            
        }];
        
        [alertController addAction:okAction];
        
        [alertController setValue:[self setAlertControllerWithStrring:NSLocalizedString(@"warning", nil) fontSize:17 spacing:1.85] forKey:@"attributedTitle"];
        
        [alertController setValue:[self setAlertControllerWithStrring:message fontSize:14 spacing:1.85]  forKey:@"attributedMessage"];
        
        [self presentViewController:alertController animated:YES completion:nil];
    
    }
    

}
- (IBAction)notNow:(id)sender {
    
    [self dismissViewController];
    
}

- (void)dismissViewController{
    [SKUserDefaults setBool:NO forKey:@"whetherNeedToRremindTheUserUpdate"];
    
    UIViewController *vc = self;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
        NSLog(@"当前控制器%@",vc.title);
        
        if ([vc.title isEqualToString:@"sidebar"]) {
            
            [vc dismissViewControllerAnimated:YES completion:nil];
            
            return;
        }
    }
    [vc dismissViewControllerAnimated:YES completion:nil];
}

@end
