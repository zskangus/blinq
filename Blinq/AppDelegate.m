//
//  AppDelegate.m
//  Blinq
//
//  Created by zsk on 16/3/25.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "AppDelegate.h"

#import "SMMainMenuViewController.h"

#import "SMSSidebarViewController.h"

#import "SMContentViewController.h"

#import "AppConstant.h"

#import "NotificationInfo.h"

#import "APPSManager.h"

#import "SmartRemindManager.h"

#import "SMContactNotificationsViewController.h"

#import "SMMessageManager.h"

#import "logMessage.h"

#import "BTServer.h"

#import "SMSosEmergencyViewController.h"

#import <AVFoundation/AVFoundation.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import "SMStartupViewController.h"

#import "BackgroundViewController.h"

#import "SMBindingViewController.h"

#import "SMContactsDescriptionViewController.h"

#import "SMSosDescriptionViewController.h"

#import "SMSocialDescriptionViewController.h"

#import "SKUserNotification.h"

#import "SMNetWorkState.h"

#import "SKFTPManager.h"

#import "SMRegisterViewController.h"

#import "SMMailchimp.h"

#import "SKNotificationIntroduce.h"

#import "SMSOSCheckAlgorithmService.h"

#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>


@interface AppDelegate ()

@property(nonatomic,strong)BTServer *defaultBTServer;

@property(nonatomic,strong)SKFTPManager *ftp;

@property (nonatomic, strong) CTCallCenter *callCenter;


@end

@implementation AppDelegate

static NSTimeInterval inComingCallTime = 0;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [SMNetWorkState whetherTheNetworkIsAvailable];
    
    [self setSosLevel];
    
    // faceBook相关
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    if ([SKUserNotification judgeSystemVersionIsIos10]) {
        [SKUserNotification requestNotificationAndSetDelegate:self];
    }else{
        if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert categories:nil]];
        }
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onUserClickEvent:) name:@"onUserClickEvent" object:nil];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    NSLog(@"屏幕宽：%f,高：%f",[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
    
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    [[AVAudioSession sharedInstance]setCategory: AVAudioSessionCategoryPlayback error: &setCategoryErr];
    [[AVAudioSession sharedInstance]setActive: YES error: &activationErr];
    
    SMMainMenuViewController *mainMenu = [[SMMainMenuViewController alloc]initWithNibName:@"SMMainMenuViewController" bundle:nil];
    
    SMContentViewController *contentVie = [[SMContentViewController alloc]init];
    
    UINavigationController *nvcMenu = [[UINavigationController alloc]initWithRootViewController:mainMenu];
    
    UINavigationController *nvcsidebar = [[UINavigationController alloc]initWithRootViewController:contentVie];
    
    SMSSidebarViewController *sidebar = [[SMSSidebarViewController alloc]initWithCenterController:nvcsidebar leftController:nvcMenu];
    
    BOOL isBinding = [SKUserDefaults boolForKey:@"isBinding"];
    
    if (isBinding) {
        
        self.defaultBTServer = [BTServer sharedBluetooth];
        
        [self.defaultBTServer initBLE];
        
        [self.defaultBTServer reConnectPeripheral];
        
        self.window.rootViewController = sidebar;
    }else{
        
        if (screenHeight == 480) {
            SMStartupViewController *startup = [[SMStartupViewController alloc]initWithNibName:@"SMStartupViewController_ip4" bundle:nil];
            self.window.rootViewController = startup;
            
        }else{
            SMStartupViewController *startup = [[SMStartupViewController alloc]initWithNibName:@"SMStartupViewController" bundle:nil];
            self.window.rootViewController = startup;
        }
        
    };
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self createCallCenter];
        
    });
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)createCallCenter{
    self.callCenter = [[CTCallCenter alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        self.callCenter.callEventHandler = ^(CTCall* call) {
            
            
            if ([call.callState isEqualToString:CTCallStateDisconnected])
            {
                NSLog(@"挂断了电话咯Call has been disconnected");
                
                Byte dely = 0;
                Byte catId = 1;
                Byte color = 0xff;
                Byte appId = 0;
                Byte configs[]= {COMMAND_ID_NTF_REMOVED, TYPE_TAG_NOTIFICATIONS, CONFIG_ERR_CODE_OK, dely,catId,color,appId};
                
                inComingCallTime = 0;
                //发送一条通知
                SmartRemindManager *manager = [[SmartRemindManager alloc]init];
                [manager writerData:ModID_Remind reqData:configs length:7];
                
            }
            else if ([call.callState isEqualToString:CTCallStateConnected])
            {
                NSLog(@"挂断了电话咯Call has been disconnected");
                
                Byte dely = 0;
                Byte catId = 1;
                Byte color = 0xff;
                Byte appId = 0;
                Byte configs[]= {COMMAND_ID_NTF_REMOVED, TYPE_TAG_NOTIFICATIONS, CONFIG_ERR_CODE_OK, dely,catId,color,appId};
                
                inComingCallTime = 0;
                //发送一条通知
                SmartRemindManager *manager = [[SmartRemindManager alloc]init];
                [manager writerData:ModID_Remind reqData:configs length:7];
            }
            else if([call.callState isEqualToString:CTCallStateIncoming])
            {
                inComingCallTime = [[NSDate dateWithTimeIntervalSinceNow:0]timeIntervalSince1970];
                NSLog(@"来电话了Call is incoming");
            }
            else if ([call.callState isEqualToString:CTCallStateDialing])
            {
                NSLog(@"正在播出电话call is dialing");
            }
            else
            {
                NSLog(@"嘛都没做Nothing is done");
            }
            
        };
        
    });
    
    
}

- (void)onUserClickEvent:(NSNotification*)obj{
    
#define COMMAND_ID_NTF_ACTION             0x30
    
    NSNumber *count = obj.object;
    NSTimeInterval currentTime = [[NSDate dateWithTimeIntervalSinceNow:0]timeIntervalSince1970];
    
    NSLog(@"AppDelegate onUserClickEvent: %@", count);
    
    if (inComingCallTime && currentTime - inComingCallTime > 3 && count && count.unsignedIntegerValue == 2) {
        Byte configs[]= {COMMAND_ID_NTF_ACTION, TYPE_TAG_SMARTREMIND, CONFIG_ERR_CODE_OK, 0x01, 0x01};
        
        //发送一条通知
        SmartRemindManager *manager = [[SmartRemindManager alloc]init];
        [manager writerData:ModID_Remind reqData:configs length:5];
    }
}

- (void)setSosLevel{
    
    NSUserDefaults *sensitivityInfo = [NSUserDefaults standardUserDefaults];
    
    NSInteger sensitivityLevel = [sensitivityInfo integerForKey:@"sensitivityLevel"];
    
    SOSLevel level;
    
    level.TLimit = 500;
    level.TWindow = 0;
    
    switch (sensitivityLevel) {
        case 0:
            level.Count = 15;
            level.DPercent = 12.0 / 15;
            break;
        case 1:
            level.Count = 14;
            level.DPercent = 12.0 / 14;
            break;
        case 2:
            level.Count = 13;
            level.DPercent = 10.0 / 13;
            break;
        case 3:
            level.Count = 12;
            level.DPercent = 10.0 / 12;
            break;
        case 4:
            level.Count = 11;
            level.DPercent = 8.0 / 11;
            break;
        case 5:
            level.Count = 10;
            level.DPercent = 8.0 / 10;
            break;
        case 6:
            level.Count = 9;
            level.DPercent = 8.0 / 9;
            break;
        case 7:
            level.Count = 8;
            level.DPercent = 6.0 / 8;
            break;
        case 8:
            level.Count = 7;
            level.DPercent = 6.0 / 7;
            break;
        case 9:
            level.Count = 6;
            level.DPercent = 4.0 / 6;
            break;
        case 10:
            level.Count = 5;
            level.DPercent = 4.0 / 5;
            break;
        default:
            break;
    }

    NSLog(@"灵敏度等级%d -- 百分比%f",level.Count,level.DPercent);

    [[SMSOSCheckAlgorithmService sharedSMSOSCheckAlgorithmService]setLevel:level];
    
}

void UncaughtExceptionHandler(NSException *exception) {
    NSArray *arr = [exception callStackSymbols];//得到当前调用栈信息
    NSString *reason = [exception reason];//非常重要，就是崩溃的原因
    NSString *name = [exception name];//异常类型
    
    NSLog(@"exception type : %@ \n crash reason : %@ \n call stack info : %@", name, reason, arr);
    
}

static NSString *server = @"ftp://sharemoretech.gotoftp5.com";
static NSString *userName = @"sharemoretech";
static NSString *passWord = @"s3T6m7K6";

- (void)registerUserInfo{
    NSString *firstName = [SKUserDefaults objectForKey:@"firstName"];
    NSString *lastName = [SKUserDefaults objectForKey:@"lastName"];
    NSString *emailAddress = [SKUserDefaults objectForKey:@"emailAddress"];
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"blinq.txt"];

    
    self.ftp = [[SKFTPManager alloc]initWithServerPath:server withName:userName withPass:passWord];
    
    __weak typeof(SKFTPManager) *weakBlock = self.ftp;
    
    
    [self.ftp FtpDownLoadFileWithPath:server fileName:@"blinq.txt" storagePath:filePath];
    
    self.ftp.ftpResultsString = ^(NSString *reee){
        
        NSLog(@"文件-%@",reee);
        
        if ([reee isEqualToString:@"下载成功"]) {
            
            //打开文件
            NSFileHandle  *outFile;
            NSData *buffer;
            
            outFile = [NSFileHandle fileHandleForWritingAtPath:filePath];
            
            if(outFile == nil)
            {
                NSLog(@"打开的文件编写失败了");
            }
            
            //找到并定位到outFile的末尾位置(在此后追加文件)
            [outFile seekToEndOfFile];
            
            //读取inFile并且将其内容写到outFile中
            NSString *bs = [NSString stringWithFormat:@"%@,%@,%@\r",firstName,lastName,emailAddress];
            buffer = [bs dataUsingEncoding:NSUTF8StringEncoding];
            
            [outFile writeData:buffer];
            
            //关闭读写文件
            [outFile closeFile];
            
            [weakBlock FtpUploadFileWithPath:filePath];
            
        }else if ([reee isEqualToString:@"上传成功"]){
            
            [SKUserDefaults setBool:YES forKey:@"isUploadSuccessful"];
            
        }else{
            
            [SKUserDefaults setBool:NO forKey:@"isUploadSuccessful"];
            
        };
        
    };
    
    
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    NSLog(@"程序进入后台");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    NSLog(@"程序进入前台");
    
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];//进入前台取消应用消息图标
    
    BOOL isBinding = [SKUserDefaults boolForKey:@"isBinding"];
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        if (isBinding) {
            [SMMessageManager obtainNotificationInfo];
            NSLog(@"程序进入前台,通知应用设置界面刷新数据");
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ReloadView" object:nil];
            
            if ([SKUserDefaults boolForKey:@"connectStatus"] == NO) {
                [self.defaultBTServer reConnectPeripheral];
            }
        }
    });
    

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"程序意外终止");
    
    NSUserDefaults *connectStatus = [NSUserDefaults standardUserDefaults];
    [connectStatus setBool:NO forKey:@"connectStatus"];
    [connectStatus synchronize];
    
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    NSLog(@"系统内存不足，需要进行清理工作");
}

#pragma mark faceBook相关方法
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}



- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                    ];
    // 在此添加任意自定义逻辑。
    return handled;
}

@end
