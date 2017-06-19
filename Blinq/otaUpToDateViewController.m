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
    
    [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"upToDate_page_title", nil) font:Avenir_Black Size:38 spacing:4 color:[UIColor whiteColor]];
    [SKAttributeString setLabelFontContent3:self.label title:NSLocalizedString(@"upToDate_page_describe", nil) font:Avenir_Heavy Size:12 spacing:3.6 color:[UIColor whiteColor]];
    
    [SKAttributeString setButtonFontContent:self.doneButton title:NSLocalizedString(@"upToDate_page_buttonTitle", nil) font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
    
//    upToDate_page_title = "AKTUELL";
//    upToDate_page_describe = "IHR RING WURDE BEREITS AUF DIE AKTUELLSTE UND BESTE SOFTWAREVERSION UPGEDATET UND UPGEGRADET.";
//    upToDate_page_buttonTitle = "ERLEDIGT";
}

- (IBAction)doneButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
