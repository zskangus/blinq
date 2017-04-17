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
    
    [SKAttributeString setLabelFontContent:self.titleLabel title:@"UPDATE FAILED" font:Avenir_Black Size:32 spacing:4.8 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent:self.labelOne title:@"LOOKS LIKE THERE WAS AN ISSUE WITH THE UPDATE. PLEASE ENSURE YOUR RING IS CONNECTED AND THAT YOU ARE ONLINE." font:Avenir_Heavy Size:11 spacing:3.3 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent:self.labelTwo title:@"IS YOUR RING CHARGED?" font:Avenir_Heavy Size:12 spacing:3.5 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent2:self.labelThree title:@"IS YOUR BLUETOOTH ON AND YOUR RING WITHIN RANGE?" font:Avenir_Heavy Size:12 spacing:3.5 color:[UIColor whiteColor]];
    
    [SKAttributeString setButtonFontContent:self.tryAgainButton title:@"TRY AGAIN" font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
    [SKAttributeString setButtonFontContent:self.notNowButton title:@"NOT NOW" font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (IBAction)tryAgain:(id)sender {
    
    BOOL connectStatus = [SKUserDefaults boolForKey:@"connectStatus"];
    
    if (connectStatus) {// 如果还在连接状态
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        
        NSString *message = @"your ring is disconnected. You may need to forget the paired ring in 'settings->bluetooth' and try again when it is reconnected.";
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"WARNING" message:[message uppercaseString] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
                //[self dismissViewController];
            
        }];
        
        [alertController addAction:okAction];
        
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
