//
//  SMLocationViewController.m
//  Blinq
//
//  Created by zsk on 16/9/28.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "SMLocationViewController.h"
#import "BackgroundViewController.h"
#import "SMlocationManager.h"
#import "SMNetWorkState.h"

@interface SMLocationViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation SMLocationViewController

- (void)viewWillAppear:(BOOL)animated{
    
    //增加监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appLicationDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SKAttributeString setLabelFontContent:self.titleLabel title:@"LOCATION" font:Avenir_Black Size:44 spacing:6.6 color:[UIColor whiteColor]];
    [SKAttributeString setLabelFontContent:self.label1 title:@"WE NEED TO HAVE ACCESS TO YOUR LOCATION IN ORDER FOR YOUR EMERGENCY S.O.S. ALERT TO WORK" font:Avenir_Heavy Size:13 spacing:3.9 color:[UIColor whiteColor]];
    [SKAttributeString setLabelFontContent:self.label2 title:@"ENABLE ACCESS TO YOUR DEVICE’S LOCATION SO YOUR RING WORKS PROPERLY" font:Avenir_Heavy Size:16 spacing:4.8 color:[UIColor whiteColor]];
    [SKAttributeString setButtonFontContent:self.nextButton title:@"NEXT" font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (IBAction)goVc:(id)sender {
    
    
    if ([SMNetWorkState state] == NO) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"WARNING" message:@"NETWORK UNAVAILABLE.CHECK NETWORK" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    
    SMlocationManager *location = [SMlocationManager sharedLocationManager];
    
    location.isReverseGeocodeLocation = NO;
    
    [location startLocationAndGetPlaceInfo:^(BOOL results) {
        
        if (results == NO) {
            BackgroundViewController *binding = [[BackgroundViewController alloc]initWithNibName:@"BackgroundViewController" bundle:nil];
            
            [self presentViewController:binding animated:YES completion:nil];
        }
        
        
    }];
    location.returnBlock = ^(NSMutableDictionary * addresss,CLLocationCoordinate2D currentUserCoordinate,BOOL isSuccessful){

        BackgroundViewController *binding = [[BackgroundViewController alloc]initWithNibName:@"BackgroundViewController" bundle:nil];
        
        [self presentViewController:binding animated:YES completion:nil];
        
    };


}

- (void)appLicationDidBecomeActive{


}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

@end
