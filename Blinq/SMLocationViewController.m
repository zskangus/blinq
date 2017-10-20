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
    
    BOOL isHaveAppliedForAuthorization = [[NSUserDefaults standardUserDefaults]boolForKey:@"IsHaveAppliedForAuthorization"];
    
    
    if (isHaveAppliedForAuthorization) {
        
        if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways){
            BackgroundViewController *binding = [[BackgroundViewController alloc]initWithNibName:@"BackgroundViewController" bundle:nil];
            
            [self presentViewController:binding animated:YES completion:nil];
        }else{
            [self showAuthorizationHintAlertController];
        }
    }else{
        SMlocationManager *location = [SMlocationManager sharedLocationManager];
        
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"IsHaveAppliedForAuthorization"];
        
        [location requestAlwaysAuthorization:^(CLAuthorizationStatus status) {
            
            switch (status) {
                case kCLAuthorizationStatusAuthorizedAlways:
                {
                    BackgroundViewController *binding = [[BackgroundViewController alloc]initWithNibName:@"BackgroundViewController" bundle:nil];
                    
                    [self presentViewController:binding animated:YES completion:nil];
                }
                    break;
                case kCLAuthorizationStatusNotDetermined:
                    break;
                case kCLAuthorizationStatusDenied:
                case kCLAuthorizationStatusRestricted:
                case kCLAuthorizationStatusAuthorizedWhenInUse:
                {
                    [self showAuthorizationHintAlertController];
                }
                    
                    break;
                default:
                    break;
            }
            
            //        二、第二个枚举值：kCLAuthorizationStatusRestricted的意思是：定位服务授权状态是受限制的。可能是由于活动限制定位服务，用户不能改变。这个状态可能不是用户拒绝的定位服务。
            //        三、第三个枚举值：kCLAuthorizationStatusDenied的意思是：定位服务授权状态已经被用户明确禁止，或者在设置里的定位服务中关闭。
            //        四、第四个枚举值：kCLAuthorizationStatusAuthorizedAlways的意思是：定位服务授权状态已经被用户允许在任何状态下获取位置信息。包括监测区域、访问区域、或者在有显著的位置变化的时候。
            //        五、第五个枚举值：kCLAuthorizationStatusAuthorizedWhenInUse的意思是：定位服务授权状态仅被允许在使用应用程序的时候。
            //        六、第六个枚举值：kCLAuthorizationStatusAuthorized的意思是：这个枚举值已经被废弃了。他相当于
            //        kCLAuthorizationStatusAuthorizedAlways这个值。
            
        }];
    }
    

    
//    location.isReverseGeocodeLocation = NO;
//
//    [location startLocationAndGetPlaceInfo:^(BOOL results) {
//
//        if (results == NO) {
//            BackgroundViewController *binding = [[BackgroundViewController alloc]initWithNibName:@"BackgroundViewController" bundle:nil];
//
//            [self presentViewController:binding animated:YES completion:nil];
//        }
//
//
//    }];
//    location.returnBlock=^(NSMutableDictionary * addresss,CLLocationCoordinate2D currentUserCoordinate, BOOL isSuccessful){
//
//        BackgroundViewController *binding = [[BackgroundViewController alloc]initWithNibName:@"BackgroundViewController" bundle:nil];
//
//        [self presentViewController:binding animated:YES completion:nil];
//
//    };


}

- (void)showAuthorizationHintAlertController{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"", nil) message:NSLocalizedString(@"location_services_switch", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *settingAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"setting_title", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            
            [[UIApplication sharedApplication] openURL:url];
            
        }
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"update_available_page_buttonTitle2", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        BackgroundViewController *binding = [[BackgroundViewController alloc]initWithNibName:@"BackgroundViewController" bundle:nil];
        
        [self presentViewController:binding animated:YES completion:nil];
    }];
    
    //[alertController setValue:[self setAlertControllerWithStrring:NSLocalizedString(@"tip_fill_text", nil) fontSize:14 spacing:1.85]  forKey:@"attributedMessage"];
    [alertController addAction:settingAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)appLicationDidBecomeActive{
    BOOL isHaveAppliedForAuthorization = [[NSUserDefaults standardUserDefaults]boolForKey:@"IsHaveAppliedForAuthorization"];
    
    if (isHaveAppliedForAuthorization == YES && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
        
        BackgroundViewController *binding = [[BackgroundViewController alloc]initWithNibName:@"BackgroundViewController" bundle:nil];
        
        [self presentViewController:binding animated:YES completion:nil];
    }else if(isHaveAppliedForAuthorization == YES && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways){
        [self showAuthorizationHintAlertController];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

@end
