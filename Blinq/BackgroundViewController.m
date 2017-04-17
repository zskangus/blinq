//
//  BackgroundViewController.m
//  Blinq
//
//  Created by zsk on 16/10/11.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "BackgroundViewController.h"
#import "SMRegisterViewController.h"

@interface BackgroundViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation BackgroundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SKAttributeString setLabelFontContent:self.titleLabel title:@"BACKGROUND" font:Avenir_Black Size:34 spacing:5.1 color:[UIColor whiteColor]];
    [SKAttributeString setLabelFontContent:self.label1 title:@"BLINQ NEEDS TO RUN IN THE BACKGROUND IN ORDER TO SEND RING NOTIFICATIONS." font:Avenir_Heavy Size:13 spacing:3.9 color:[UIColor whiteColor]];
    [SKAttributeString setLabelFontContent:self.label2 title:@"MAKE SURE YOU DON’T MANUALLY QUIT THE BLINQ APP" font:Avenir_Heavy Size:18 spacing:5.4 color:[UIColor whiteColor]];
    [SKAttributeString setButtonFontContent:self.nextButton title:@"NEXT" font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (IBAction)goVc:(id)sender {
    
    if (screenHeight == 480) {
        SMRegisterViewController *registervc = [[SMRegisterViewController alloc]initWithNibName:@"SMRegisterViewController_ip4" bundle:nil];
        
        [self presentViewController:registervc animated:YES completion:nil];
    }else{
        SMRegisterViewController *registervc = [[SMRegisterViewController alloc]initWithNibName:@"SMRegisterViewController" bundle:nil];
        
        [self presentViewController:registervc animated:YES completion:nil];
    }
    

}

@end
