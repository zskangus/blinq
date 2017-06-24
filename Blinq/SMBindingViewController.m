//
//  SMBindingViewController.m
//  Blinq
//
//  Created by zsk on 16/3/25.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "SMBindingViewController.h"

#import "BTServer.h"
#import "AppConstant.h"
#import "TopPlayManager.h"
#import "SMConnectedEquipmentViewController.h"


@interface SMBindingViewController ()
@property (weak, nonatomic) IBOutlet UIButton *putRingHere;

@property(nonatomic,strong)BTServer *defaultBTServer;

@property(nonatomic,strong)SMConnectedEquipmentViewController *connectedEQ;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *pairBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation SMBindingViewController

- (SMConnectedEquipmentViewController *)connectedEQ{

    if (!_connectedEQ) {
        _connectedEQ = [[SMConnectedEquipmentViewController alloc]initWithNibName:@"SMConnectedEquipmentViewController" bundle:nil];
    }
    return _connectedEQ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"binding_page_title", nil) font:Avenir_Heavy Size:24 spacing:4.2 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent2:self.label title:NSLocalizedString(@"binding_page_describe", nil) font:Avenir_Heavy Size:14 spacing:4.2 color:[UIColor whiteColor]];
    
    if ([NSLocalizedString(@"language", nil)isEqualToString:@"中文"]) {
        [SKAttributeString setLabelFontContent2:self.label title:NSLocalizedString(@"binding_page_describe", nil) font:Avenir_Heavy Size:18 spacing:5 color:[UIColor whiteColor]];

        self.label.textAlignment = NSTextAlignmentCenter;
        
        self.titleLabel.frame = self.putRingHere.frame;
    }
    
    [SKAttributeString setButtonFontContent:self.pairBtn title:NSLocalizedString(@"binding_page_buttonTitle", nil) font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
    

}

- (IBAction)pairNow:(id)sender {
    
    if (screenHeight == 480) {
        SMConnectedEquipmentViewController *connectEq = [[SMConnectedEquipmentViewController alloc]initWithNibName:@"SMConnectedEquipmentViewController_ip4" bundle:nil];
        [self presentViewController:connectEq animated:YES completion:nil];

    }else{
        SMConnectedEquipmentViewController *connectEq = [[SMConnectedEquipmentViewController alloc]initWithNibName:@"SMConnectedEquipmentViewController" bundle:nil];
        [self presentViewController:connectEq animated:YES completion:nil];
    }
    
}


- (void)EstablishConnection{
    
    self.defaultBTServer = [BTServer sharedBluetooth];
    [self.defaultBTServer initBLE];
}


- (void)viewDidDisappear:(BOOL)animated{
    


}



@end
