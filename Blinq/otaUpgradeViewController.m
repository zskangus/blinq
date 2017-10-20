//
//  otaUpgradeViewController.m
//  cjj
//
//  Created by zsk on 16/6/29.
//  Copyright © 2016年 cjj. All rights reserved.
//

#import "otaUpgradeViewController.h"
#import "BTServer.h"
#import "Defines.h"
#import "otaUpdateProgress.h"
#import "otaUpdateSuccessfulViewController.h"
#import "otaUpdateFaildViewController.h"
#import "XMLParsing.h"
#import "SMOTAUpdateServic.h"
#import "SKTimerManager.h"

//
typedef NS_ENUM(NSInteger,DisconnectType){
    DisconnectTypeOther,
    DisconnectTypeOTA
};

@interface otaUpgradeViewController ()
{
    int step, nextStep;
    int expectedValue;
    
    int chunkSize;
    int blockStartByte;
}

@property(nonatomic,strong)BTServer *ble;

@property(nonatomic,strong)NSMutableData *fileData;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet UIView *progressView;

@property(nonatomic,strong)UILabel *progressLabel;

@property(nonatomic,strong)SMOTAUpdateServic *otaServic;


// 进度条的四个圈
@property(nonatomic,strong)otaUpdateProgress *progress1;
@property(nonatomic,strong)otaUpdateProgress *progress2;
@property(nonatomic,strong)otaUpdateProgress *progress3;
@property(nonatomic,strong)otaUpdateProgress *progress4;

@property(nonatomic,assign)BOOL isOtaDiconnect;

@property(nonatomic,strong)NSTimer *timer;

@property(nonatomic,strong)SKTimerManager *otaTimer;



@end

static NSString *_url;

@implementation otaUpgradeViewController


- (void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(otaPagebleStatus:) name:@"otaPagebleConnectStatus" object:nil];
    
    [self setOtaProgressValue:0.0];
    
    [self performSelector:@selector(otaFunc) withObject:nil afterDelay:3];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUi];
    
    [self setupotaUpdateProgressUi];
    
    //[self setOtaProgressValue:0.5];
    
    self.ble = [BTServer sharedBluetooth];
}

- (void)setupUi{
    
    if ([NSLocalizedString(@"language", nil)isEqualToString:@"German"]) {
        [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"updating_jewelry_page_title", nil) font:Avenir_Black Size:20 spacing:4 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent:self.label title:NSLocalizedString(@"updating_jewelry_page_describe", nil) font:Avenir_Heavy Size:12 spacing:4.2 color:[UIColor whiteColor]];
    }else if ([NSLocalizedString(@"language", nil)isEqualToString:@"中文"]){
    
        [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"updating_jewelry_page_title", nil) font:Avenir_Black Size:32 spacing:5.4 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent:self.label title:NSLocalizedString(@"updating_jewelry_page_describe", nil) font:Avenir_Heavy Size:18 spacing:0 color:[UIColor whiteColor]];
        
        self.label.textAlignment = NSTextAlignmentCenter;
        
        CGRect labelFrame = self.label.frame;
        labelFrame.origin.x = 0;
        labelFrame.size.width = 375;
        self.label.frame = labelFrame;
        
        
    }else{
        [SKAttributeString setLabelFontContent:self.titleLabel title:NSLocalizedString(@"updating_jewelry_page_title", nil) font:Avenir_Black Size:32 spacing:5.4 color:[UIColor whiteColor]];
        
        [SKAttributeString setLabelFontContent:self.label title:NSLocalizedString(@"updating_jewelry_page_describe", nil) font:Avenir_Heavy Size:14 spacing:4.2 color:[UIColor whiteColor]];
    }

}

- (void)setupotaUpdateProgressUi{
    
    CGFloat progressSize = 215;
    
    self.progress1 = [[otaUpdateProgress alloc]initWithFrame:CGRectMake(0, 0, progressSize, progressSize)];
    self.progress1.progresscolor = RGB_COLOR(80, 210, 194);
    [self.progressView addSubview:self.progress1];
    
    self.progress2 = [[otaUpdateProgress alloc]initWithFrame:CGRectMake(0, 0, progressSize*0.8, progressSize*0.8)];
    self.progress2.progresscolor = RGB_COLOR(210, 80, 170);
    self.progress2.center = self.progress1.center;
    [self.progressView addSubview:self.progress2];
    
    self.progress3 = [[otaUpdateProgress alloc]initWithFrame:CGRectMake(0, 0, progressSize*0.6, progressSize*0.6)];
    self.progress3.progresscolor = RGB_COLOR(74, 144, 226);
    self.progress3.center = self.progress1.center;
    [self.progressView addSubview:self.progress3];
    
    self.progress4 = [[otaUpdateProgress alloc]initWithFrame:CGRectMake(0, 0, progressSize*0.4, progressSize*0.4)];
    self.progress4.progresscolor = RGB_COLOR(206, 139, 212);
    self.progress4.center = self.progress1.center;
    [self.progressView addSubview:self.progress4];
}

- (void)setOtaProgressValue:(double)value{
    self.progress1.progressvalue = value*1.7;
    self.progress2.progressvalue = value*1.5;
    self.progress3.progressvalue = value*1.3;
    self.progress4.progressvalue = value;
}

static NSInteger reupdateCount = 0;

- (void)otaFunc{
    
    [self.otaServic performOTAUpdateFromFileUrl:[SMBlinqInfo ringFirmwareUpdateFileUrl] successful:^{
        
        otaUpdateSuccessfulViewController *otaUpdateSuccessful = [[otaUpdateSuccessfulViewController alloc] initWithNibName:@"otaUpdateSuccessfulViewController" bundle:nil];
        
        [self presentViewController:otaUpdateSuccessful animated:YES completion:nil];
        
        
    } failure:^(NSError *error) {
        if (error.code == 1) {
            otaUpdateFaildViewController *failed = [[otaUpdateFaildViewController alloc]initWithNibName:@"otaUpdateFaildViewController" bundle:nil];
            
            [self presentViewController:failed animated:NO completion:nil];
        }else{

        }
        
        if (error.code == 3 && reupdateCount <2) {
            
            reupdateCount++;
            
            self.isOtaDiconnect = YES;
            NSLog(@"OTA升级时连接断开");
            
            self.otaTimer = [[SKTimerManager alloc]init];
            
            [self.otaTimer createTimerWithType:TimerType_create_open updateInterval:15 repeatCount:1 update:^{
                otaUpdateFaildViewController *failed = [[otaUpdateFaildViewController alloc]initWithNibName:@"otaUpdateFaildViewController" bundle:nil];
                
                [self presentViewController:failed animated:NO completion:nil];
            }];
            
        }else{
            
            reupdateCount = 0;
            
            otaUpdateFaildViewController *failed = [[otaUpdateFaildViewController alloc]initWithNibName:@"otaUpdateFaildViewController" bundle:nil];
            
            [self presentViewController:failed animated:NO completion:nil];
        }
                
    } progress:^(double progress) {
        
        [self setOtaProgressValue:progress];
    }];
    
    
}

- (void)otaPagebleStatus:(NSNotification*)status{
    
    BOOL connectState = [status.object boolValue];
    
    if (connectState == YES && self.isOtaDiconnect == YES) {
        [self.otaTimer stopTimer];
        self.otaServic = nil;
        //[self otaFunc];
        [self performSelector:@selector(otaFunc) withObject:nil afterDelay:3];
        self.isOtaDiconnect = NO;
    }
}


#define SERVICE_PATH @"http://www.sharemoretech.com/update/blinq/firmware/version_"

#define test @"http://www.sharemoretech.com/update/blinq/test/firmware/version_"
#define test1 @"http://www.sharemoretech.com/update/sharemorering/test/firmware/version_"

#define SSSERVICE_PATH @"http://www.sharemoretech.com/update/sharemorering/firmware/version_"

#pragma mark -检测是否需要升级-

+ (BOOL)detectionRingVersion{
    
    __block BOOL isUpdata = NO;
    
    XMLParsing *xml = [[XMLParsing alloc]init];
    
    NSString *hw_version = [[NSUserDefaults standardUserDefaults]objectForKey:@"HW_VERSION"];
    
    if (!hw_version) {
        return NO;
    }
    
    NSString* appendStr = @".xml";
    NSString* str = [hw_version stringByAppendingString:appendStr];
    NSString *urlString = [SERVICE_PATH stringByAppendingString:str];
    
    //urlString = @"http://www.sharemoretech.com/update/blinq/firmware/version_SMPRO_1.5.0.xml";
    
    NSLog(@"path=========:%@",urlString);

    [xml parsingXMLWith:urlString xmlInfo:^(NSString *version, NSString *name, NSString *url) {
        NSLog(@"--info -%@--%@--%@",version,name,url);
        
        _url = url;
        NSString * serverVersion = version;
        
        NSString * localVersion = [[NSUserDefaults standardUserDefaults]objectForKey:@"version"];
        
        serverVersion = [[serverVersion componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet]] componentsJoinedByString:@""];
        
        localVersion = [[localVersion componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet]] componentsJoinedByString:@""];
        
        //以"."分隔数字然后分配到不同数组
        NSArray * serverArray = [serverVersion componentsSeparatedByString:@"."];
        
        NSArray * localArray = [localVersion componentsSeparatedByString:@"."];
        
        NSLog(@"软件版本为%@，当前最新版本为%@",localVersion,version);
        
        for (int i = 0; i < serverArray.count; i++) {
            
            NSLog(@"%d--%d",[serverArray[i] intValue],[localArray[i] intValue]);
            
            //以服务器版本为基准，判断本地版本位数小于服务器版本时，直接返回（并且判断为新版本，比如服务器1.5.1 本地为1.5）
            if(i > (localArray.count -1)){
                NSLog(@"需要更新，软件版本为%@，当前最新版本为%@",localVersion,version);
                isUpdata = YES;
                _url = url;
                [SMBlinqInfo setRingFirmwareUpdateFileUrl:url];
                break;
            }
            //有新版本，服务器版本对应数字大于本地
            if ( [serverArray[i] intValue] > [localArray[i] intValue]) {
                NSLog(@"需要更新，软件版本为%@，当前最新版本为%@",localVersion,version);
                isUpdata = YES;
                _url = url;
                [SMBlinqInfo setRingFirmwareUpdateFileUrl:url];
                break;
            }else if([serverArray[i] intValue] < [localArray[i] intValue]){
                isUpdata = YES;
                break;
            }
        }
    }];
    
    if (isUpdata) {
        NSLog(@"需要更新戒指固件");
    }else{
        NSLog(@"不需要更新戒指固件");
    }
    
    return isUpdata;
}


+ (void)checkFirmwareVersion:(void(^)(NSString *url,NSString *version))need notNeed:(void(^)(void))notNeed{
    
    XMLParsing *xml = [[XMLParsing alloc]init];
    
    NSString *hw_version = [[NSUserDefaults standardUserDefaults]objectForKey:@"HW_VERSION"];

    if (hw_version.length == 0 || hw_version == nil) {
        notNeed();
        return;
    }
    
    
    NSString *urlString = ({
        NSString *appendStr = @".xml";
        NSString *str = [hw_version stringByAppendingString:appendStr];
        [SERVICE_PATH stringByAppendingString:str];
    });
    
    NSLog(@"path=========:%@",urlString);
    
    [xml parsingXMLWith:urlString xmlInfo:^(NSString *version, NSString *name, NSString *url) {
        NSLog(@"--info -%@--%@--%@",version,name,url);
        
        
        NSString * serverVersion = version;
        
        NSString * localVersion = [[NSUserDefaults standardUserDefaults]objectForKey:@"version"];

        serverVersion = [[serverVersion componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet]] componentsJoinedByString:@""];
        
        localVersion = [[localVersion componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet]] componentsJoinedByString:@""];
        
        if ([serverVersion isEqualToString:localVersion]) {
            notNeed();
            return;
        }
        
        //以"."分隔数字然后分配到不同数组
        NSArray * serverArray = [serverVersion componentsSeparatedByString:@"."];
        
        NSArray * localArray = [localVersion componentsSeparatedByString:@"."];
        
        for (int i = 0; i < serverArray.count; i++) {
            
            //以服务器版本为基准，判断本地版本位数小于服务器版本时，直接返回（并且判断为新版本，比如服务器1.5.1 本地为1.5）
            if(i > (localArray.count -1)){
                NSLog(@"需要更新，当前最新版本为%@",version);
                need(url,version);
                break;
            }
            //有新版本，服务器版本对应数字大于本地
            if ( [serverArray[i] intValue] > [localArray[i] intValue]) {
                NSLog(@"需要更新，软件版本为%@，当前最新版本为%@",localVersion,version);
                need(url,version);
                break;
            }else if([serverArray[i] intValue] < [localArray[i] intValue]){
                notNeed();
                break;
            }
        }
    }];
    
}


#pragma mark - 懒加载
- (SMOTAUpdateServic *)otaServic{
    if (!_otaServic) {
        _otaServic = [[SMOTAUpdateServic alloc]init];
    }
    return _otaServic;
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
