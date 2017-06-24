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
    
    if ([NSLocalizedString(@"language", nil)isEqualToString:@"German"]) {
        
        [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"loaction_title", nil) font:Avenir_Black Size:44 spacing:6.6 color:[UIColor whiteColor]];
        [SKAttributeString setLabelFontContent:self.label1 title:NSLocalizedString(@"location_describe1", nil) font:Avenir_Heavy Size:13 spacing:3.9 color:[UIColor whiteColor]];
        [SKAttributeString setLabelFontContent:self.label2 title:NSLocalizedString(@"location_describe2", nil) font:Avenir_Heavy Size:16 spacing:4.8 color:[UIColor whiteColor]];
        [SKAttributeString setButtonFontContent:self.nextButton title:NSLocalizedString(@"location_buttonTitle", nil) font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }else if ([NSLocalizedString(@"language", nil)isEqualToString:@"中文"]){
        
        [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"loaction_title", nil) font:Avenir_Black Size:30 spacing:6.6 color:[UIColor whiteColor]];
        [SKAttributeString setLabelFontContent:self.label1 title:NSLocalizedString(@"location_describe1", nil) font:Avenir_Heavy Size:18 spacing:3.9 color:[UIColor whiteColor]];
        [SKAttributeString setLabelFontContent:self.label2 title:NSLocalizedString(@"location_describe2", nil) font:Avenir_Heavy Size:18 spacing:3.9 color:[UIColor whiteColor]];
        
        CGRect label1Frame = self.label2.frame;
        label1Frame.origin.y= self.label1.frame.origin.y-30;
        self.label1.frame = label1Frame;
        
        [SKAttributeString setButtonFontContent:self.nextButton title:NSLocalizedString(@"location_buttonTitle", nil) font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }else{
        
        [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"loaction_title", nil) font:Avenir_Black Size:44 spacing:6.6 color:[UIColor whiteColor]];
        [SKAttributeString setLabelFontContent:self.label1 title:NSLocalizedString(@"location_describe1", nil) font:Avenir_Heavy Size:13 spacing:3.9 color:[UIColor whiteColor]];
        [SKAttributeString setLabelFontContent:self.label2 title:NSLocalizedString(@"location_describe2", nil) font:Avenir_Heavy Size:16 spacing:4.8 color:[UIColor whiteColor]];
        [SKAttributeString setButtonFontContent:self.nextButton title:NSLocalizedString(@"location_buttonTitle", nil) font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    

}

- (IBAction)goVc:(id)sender {
    
    
    if ([SMNetWorkState state] == NO) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"warning", nil) message:NSLocalizedString(@"tip_network", nil) preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertController addAction:okAction];
        
        [alertController setValue:[self setAlertControllerWithStrring:NSLocalizedString(@"warning", nil) fontSize:17 spacing:1.85] forKey:@"attributedTitle"];
        
        [alertController setValue:[self setAlertControllerWithStrring:NSLocalizedString(@"tip_network", nil) fontSize:14 spacing:1.85]  forKey:@"attributedMessage"];
        
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
    location.returnBlock=^(NSMutableDictionary * addresss,CLLocationCoordinate2D currentUserCoordinate, BOOL isSuccessful){

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
