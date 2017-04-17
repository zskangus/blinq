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

- (void)setupUI{
    [SKAttributeString setLabelFontContent:self.titleLabel title:@"UH OH!" font:Avenir_Black Size:36 spacing:5.4 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent:self.labelOne title:@"LOOKS LIKE WE AREN’T ABLE TO CONNECT TO YOUR DEVICE." font:Avenir_Heavy Size:12 spacing:3.6 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent:self.labelTwo title:@"DID YOU CHARGE YOUR RING?" font:Avenir_Heavy Size:12 spacing:3.5 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent2:self.labelThree title:@"IS YOUR BLUETOOTH ON AND YOUR RING WITHIN RANGE?" font:Avenir_Heavy Size:12 spacing:3.6 color:[UIColor whiteColor]];
    
    [SKAttributeString setButtonFontContent:self.tryAginBtn title:@"TRY AGAIN" font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
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
