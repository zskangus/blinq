//
//  otaUpToDateViewController.m
//  Blinq
//
//  Created by zsk on 16/9/12.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "otaUpToDateViewController.h"
#import "SKAttributeString.h"

@interface otaUpToDateViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation otaUpToDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUi];
}

- (void)setupUi{
    
    [SKAttributeString setLabelFontContent:self.titleLabel title:@"UP TO DATE" font:Avenir_Black Size:38 spacing:4 color:[UIColor whiteColor]];
    [SKAttributeString setLabelFontContent3:self.label title:@"YOUR RING HAS ALREADY BEEN\nUPDATED AND UPGRADED TO THE\nLATEST AND GREATEST SOFTWARE. " font:Avenir_Heavy Size:12 spacing:3.6 color:[UIColor whiteColor]];
    
    [SKAttributeString setButtonFontContent:self.doneButton title:@"DONE" font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (IBAction)doneButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
