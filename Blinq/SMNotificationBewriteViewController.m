//
//  SMNotificationBewriteViewController.m
//  Blinq
//
//  Created by zsk on 16/9/28.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "SMNotificationBewriteViewController.h"
#import "SMLocationViewController.h"
#import "BackgroundViewController.h"

@interface SMNotificationBewriteViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation SMNotificationBewriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SKAttributeString setLabelFontContent:self.titleLabel title:@"NOTIFICATIONS" font:Avenir_Black Size:30 spacing:4.5 color:[UIColor whiteColor]];
    [SKAttributeString setLabelFontContent:self.label1 title:@"IN ORDER FOR YOUR SMART RING TO WORK WE NEED TO SEND YOU NOTIFICATIONS." font:Avenir_Heavy Size:13 spacing:3.9 color:[UIColor whiteColor]];
    [SKAttributeString setLabelFontContent:self.label2 title:@"MAKE SURE YOU ENABLE NOTIFICATIONS SO YOUR RING WORKS PROPERLY" font:Avenir_Heavy Size:18 spacing:5.4 color:[UIColor whiteColor]];
    [SKAttributeString setButtonFontContent:self.nextButton title:@"NEXT" font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
}
- (IBAction)goVc:(id)sender {
    

    
    if (screenHeight == 480) {
        BackgroundViewController *binding = [[BackgroundViewController alloc]initWithNibName:@"BackgroundViewController_ip4" bundle:nil];
        
        [self presentViewController:binding animated:YES completion:nil];
        
    }else{
        BackgroundViewController *binding = [[BackgroundViewController alloc]initWithNibName:@"BackgroundViewController" bundle:nil];
        
        [self presentViewController:binding animated:YES completion:nil];
    }

}

@end
