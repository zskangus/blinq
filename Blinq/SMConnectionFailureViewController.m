//
//  SMConnectionFailureViewController.m
//  Blinq
//
//  Created by zsk on 16/3/25.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "SMConnectionFailureViewController.h"

#import "SMConnectedEquipmentViewController.h"
#import "BTServer.h"


@interface SMConnectionFailureViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *labelThree;
@property (weak, nonatomic) IBOutlet UILabel *labelOne;
@property (weak, nonatomic) IBOutlet UILabel *labelTwo;
@property (weak, nonatomic) IBOutlet UIButton *tryAginBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;
@property (weak, nonatomic) IBOutlet UILabel *labelFour;

@property(nonatomic,strong)BTServer *ble;

@end

@implementation SMConnectionFailureViewController

- (void)viewWillAppear:(BOOL)animated{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ble = [BTServer sharedBluetooth];
    [self.ble removeBinding];
    
    [self setupUI];
}

//连接失败界面

- (void)setupUI{
    [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"connect_failure_page_title1", nil) font:Avenir_Black Size:36 spacing:5.4 color:[UIColor whiteColor]];
        
    [SKAttributeString setLabelFontContent:self.titleLabel2 title:NSLocalizedString(@"connect_failure_page_title2", nil) font:Avenir_Black Size:20 spacing:6.5 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent2:self.labelOne title:NSLocalizedString(@"connect_failure_page_describe1", nil) font:Avenir_Heavy Size:11.5 spacing:3.45 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent2:self.labelTwo title:NSLocalizedString(@"connect_failure_page_describe2", nil) font:Avenir_Heavy Size:12 spacing:3.5 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent2:self.labelThree title:NSLocalizedString(@"connect_failure_page_describe3", nil) font:Avenir_Heavy Size:13 spacing:3.9 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent2:self.labelFour title:NSLocalizedString(@"connect_failure_page_describe4", nil) font:Avenir_Heavy Size:11 spacing:3.3 color:[UIColor whiteColor]];
    
    [SKAttributeString setButtonFontContent:self.tryAginBtn title:NSLocalizedString(@"connect_failure_page_buttonTitle", nil) font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if ([NSLocalizedString(@"language", nil)isEqualToString:@"German"]) {
        
        [SKAttributeString setLabelFontContent:self.titleLabel2 title:NSLocalizedString(@"connect_failure_page_title2", nil) font:Avenir_Black Size:18 spacing:4 color:[UIColor whiteColor]];

        
        CGRect labelOneframe = self.labelOne.frame;
        labelOneframe.size.height += 20;
        labelOneframe.size.width += 30;
        labelOneframe.origin.x -= 15;
        self.labelOne.frame = labelOneframe;
 
        CGRect labelTwoframe = self.labelTwo.frame;
        labelTwoframe.size.width += 40;
        labelTwoframe.origin.x -= 15;
        self.labelTwo.frame = labelTwoframe;
        
        [SKAttributeString setLabelFontContent:self.labelThree title:NSLocalizedString(@"connect_failure_page_describe3", nil) font:Avenir_Heavy Size:11 spacing:3.5 color:[UIColor whiteColor]];
        
        CGRect labelThreeFrame = self.labelThree.frame;
        labelThreeFrame.size.width += 40;
        //labelThreeFrame.size.height += 20;
        labelThreeFrame.origin.x -= 15;
        self.labelThree.frame = labelThreeFrame;
        
        CGRect labelFourFrame = self.labelFour.frame;
        labelFourFrame.size.width += 40;
        labelFourFrame.origin.x -= 15;
        self.labelFour.frame = labelFourFrame;
        
        [SKAttributeString setLabelFontContent2:self.labelFour title:NSLocalizedString(@"connect_failure_page_describe4", nil) font:Avenir_Heavy Size:10.5 spacing:3.3 color:[UIColor whiteColor]];

        [SKAttributeString setButtonFontContent:self.tryAginBtn title:NSLocalizedString(@"connect_failure_page_buttonTitle", nil) font:Avenir_Light Size:15 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (IBAction)tryAgain:(id)sender {
    
    if (screenHeight == 480) {
        SMConnectedEquipmentViewController *connected = [[SMConnectedEquipmentViewController alloc]initWithNibName:@"SMConnectedEquipmentViewController_ip4" bundle:nil];
        [self presentViewController:connected animated:YES completion:nil];
    }else{
        SMConnectedEquipmentViewController *connected = [[SMConnectedEquipmentViewController alloc]initWithNibName:@"SMConnectedEquipmentViewController" bundle:nil];
        [self presentViewController:connected animated:YES completion:nil];
    }
}


@end
