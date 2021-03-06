//
//  SMContentViewController.m
//  Blinq
//
//  Created by zsk on 16/3/28.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "SMContentViewController.h"

#import "BTServer.h"

#import "AppConstant.h"

#import "SMContactNotificationsViewController.h"

#import "SMPlayViewController.h"

#import "SMSosEmergencyViewController.h"

#import "SMSettingViewController.h"

#import "SMStartupViewController.h"

#import "SMMainMenuViewController.h"

#import <AFNetworking.h>

#import "NSArray+decription.h"

#import "NSDictionary+decription.h"

#import "SMNotificationMainViewController.h"

#import "SMContactsDescriptionViewController.h"

#import "SMNetWorkState.h"

#import "SMHelpViewController.h"

#import "SKUserNotification.h"

#import "SKViewTransitionManager.h"

#import "SKFTPManager.h"

#import "SMlocationManager.h"

#import "AlidayuManager.h"

#import "contactModel.h"

#import "SMSosContactTool.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

#import "SMSOSDescribe.h"

#import "SMStepCounterPage.h"

#import "SMStepCounterDescribeInterface.h"

#define Screen_height [[UIScreen mainScreen] bounds].size.height
#define Screen_width [[UIScreen mainScreen] bounds].size.width

typedef NS_ENUM(NSInteger,location){
    
    SystemStartup = 0,
    UserStartup
    
};

location SMlocationStartup;

@interface SMContentViewController ()<CLLocationManagerDelegate,FBSDKSharingDelegate>

@property(nonatomic,strong)NSNotificationCenter *center;

@property(nonatomic,strong)BTServer *defaultBTServer;

// 视图相关
//@property(nonatomic,strong)UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property(nonatomic,strong)UIViewController *currentVC;

@property(nonatomic,strong)SMNotificationMainViewController *notification;

@property(nonatomic,strong)SMContactNotificationsViewController *contact;

@property(nonatomic,strong)SMPlayViewController *play;

@property(nonatomic,strong)SMSosEmergencyViewController *sos;

@property(nonatomic,strong)SMSettingViewController *setting;

//@property(nonatomic,strong)SMSRegisterViewController *registervc;

@property(nonnull,strong)SMHelpViewController *help;

@property(nonatomic,strong)UINavigationController *navNotification;
@property(nonatomic,strong)UINavigationController *navContact;
@property(nonatomic,strong)UINavigationController *navPlay;
@property(nonatomic,strong)UINavigationController *navSos;
@property(nonatomic,strong)UINavigationController *navSetting;
@property(nonatomic,strong)UINavigationController *navHelp;
@property(nonatomic,strong)UINavigationController *navStepCounter;



@property(nonatomic,assign)NSInteger vcCount;

@property(nonatomic,strong)NSString *sosAddress;

@property(nonatomic,strong)NSTimer *timer;

@property(nonatomic, unsafe_unretained)UIBackgroundTaskIdentifier backgroundTaskIdentifier;

@property(nonatomic,strong)SMStepCounterPage *stepCounter;

@end

static NSInteger checkCount;

@implementation SMContentViewController

- (NSNotificationCenter *)center{
    if (!_center) {
        _center = [NSNotificationCenter defaultCenter];
    }
    return _center;
}

- (void)viewWillAppear:(BOOL)animated{
    
    //[self setupNavigation];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveMessage:) name:@"update" object:nil];
    
    [SKNotificationCenter addObserver:self selector:@selector(batteryNotification:) name:@"batteryNotification" object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 紧急求救
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(sosAction:) name:NOTIFICATION_SOS object:nil];
    

    [self addSubControllers];

    
    
    SMlocationStartup = SystemStartup;
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"openSosFunc"]) {
        [self setupLocation];
    }
    
    //[self viewClickEvent];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
}

- (void)batteryNotification:(NSNotification*)obj{
    
    if ([obj.object isEqualToString:@"full"]) {
        [self showAlertController:NSLocalizedString(@"battery_charge_completion", nil) body:NSLocalizedString(@"battery_charge_completion_desc", nil) type:@"battery"];

    }else if([obj.object isEqualToString:@"low"]){
        [self showAlertController:NSLocalizedString(@"battery_low", nil) body:NSLocalizedString(@"battery_low_desc", nil) type:@"battery"];
    }
}

- (void)addSubControllers{
    
    self.notification = [[SMNotificationMainViewController alloc]initWithNibName:@"SMNotificationMainViewController" bundle:nil];
    self.navNotification = [[UINavigationController alloc]initWithRootViewController:self.notification];
    [self addChildViewController:self.navNotification];
    
    self.contact = [[SMContactNotificationsViewController alloc]initWithNibName:@"SMContactNotificationsViewController" bundle:nil];
    self.navContact = [[UINavigationController alloc]initWithRootViewController:self.contact];
    
    [self addChildViewController:self.navContact];
    
    self.play = [[SMPlayViewController alloc]initWithNibName:@"SMPlayViewController" bundle:nil];
    self.navPlay = [[UINavigationController alloc]initWithRootViewController:self.play];
    [self addChildViewController:self.navPlay];

    self.sos = [[SMSosEmergencyViewController alloc]initWithNibName:@"SMSosEmergencyViewController" bundle:nil];
    self.navSos = [[UINavigationController alloc]initWithRootViewController:self.sos];
    [self addChildViewController:self.navSos];
    
    self.stepCounter = [[SMStepCounterPage alloc]initWithNibName:@"SMStepCounterPage" bundle:nil];
    self.navStepCounter = [[UINavigationController alloc]initWithRootViewController:self.stepCounter];
    [self addChildViewController:self.navStepCounter];
    
    self.setting = [[SMSettingViewController alloc]initWithNibName:@"SMSettingViewController" bundle:nil];
    self.navSetting = [[UINavigationController alloc]initWithRootViewController:self.setting];
    [self addChildViewController:self.navSetting];
    
    self.help = [[SMHelpViewController alloc]initWithNibName:@"SMHelpViewController" bundle:nil];
    self.navHelp = [[UINavigationController alloc]initWithRootViewController:self.help];
    [self addChildViewController:self.navHelp];
    
    //调整子视图控制器的Frame已适应容器View
    [self fitFrameForChildViewController:self.navNotification];
    
    //设置默认显示在容器View的内容
    //self.navNotification.view.transform = CGAffineTransformMakeScale([UIScreen mainScreen].bounds.size.width / 375, [UIScreen mainScreen].bounds.size.width / 375);
    [self.contentView addSubview:self.navNotification.view];
    
    self.vcCount = 0;
    
    NSLog(@"contentView-%@",NSStringFromCGRect(self.contentView.frame));
    NSLog(@"notification-%@",NSStringFromCGRect(self.notification.view.frame));
    
    self.currentVC = self.navNotification;
    //[self addChildViewController:self.currentVC];
}

//- (void)viewClickEvent{ // 监听view的点击事件
//    
//    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(packupSidebar)];
//    
//    tapGesture.delegate = (id<UIGestureRecognizerDelegate>)self;;
//    
//    [self.view addGestureRecognizer:tapGesture];
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    
//    NSLog(@"%@", NSStringFromClass([touch.view class]));
//    
////    if ([NSStringFromClass([touch.view class])isEqualToString:@"UIWebBrowserView"]) {
////        [self packupSidebar];
////    }
////    
//    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
//    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellEditControl"]) {
//        return NO;
//    }
//    
////    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellEditControl"]) {
////        return NO;
////    }
//    
//    
//    return  YES;
//}


- (void)packupSidebar{// 点击界面收起侧边栏
    [self.center postNotificationName:@"packupSidebar" object:nil];
}

- (void)popupSidebar{ // 点击导航栏上的menu按钮推出侧边栏
    [self.center postNotificationName:@"popupSidebar" object:nil];
}

- (void)receiveMessage:(NSNotification *)notification{
    
    NSNumber *num = [notification object];
    
    NSUInteger item = [num integerValue];
    
    if (item == self.vcCount) {
        return;
    }
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"openSosFunc"] == NO) {
        [self offSosFuncState:item];
        self.vcCount = item;
        return;
    }
    
    switch (item) {
        case 0:
        {
            [self fitFrameForChildViewController:self.navNotification];
            
            [self transitionFromOldViewController:self.currentVC toNewViewController:self.navNotification];
            
        }
            break;
        case 1:
        {
            
            BOOL notification_contactVcTurnedOn = [SKUserDefaults boolForKey:@"main_contactVcTurnedOn"];
            
            if (notification_contactVcTurnedOn == NO) {
                SMContactsDescriptionViewController *description = [[SMContactsDescriptionViewController alloc]initWithNibName:@"SMContactsDescriptionViewController" bundle:nil];
                description.entrance = @"main";
                
                [SKViewTransitionManager presentModalViewControllerFrom:self to:description duration:0.3 transitionType:TransitionPush directionType:TransitionFromRight];
                
                description.returnBlock = ^(){
                    
                };
            }
            
            [self fitFrameForChildViewController:self.navContact];
            
            [self transitionFromOldViewController:_currentVC toNewViewController:self.navContact];
                        
        }
            break;
        case 2:
        {
            [self fitFrameForChildViewController:self.navPlay];
            
            [self transitionFromOldViewController:_currentVC toNewViewController:self.navPlay];
            
        }
            break;
        case 3:
        {            
            if ([SKUserDefaults boolForKey:@"isAccpetDisclaimer"]) {
                [self fitFrameForChildViewController:self.navSos];
                
                [self transitionFromOldViewController:_currentVC toNewViewController:self.navSos];
                
                //[self setupNavigationTitle:NSLocalizedString(@"nav_title_SOS_EMERGENCY", nil)];
            }else{
                SMSOSDescribe *describe = [[SMSOSDescribe alloc]initWithNibName:@"SMSOSDescribe" bundle:nil];
                [SKViewTransitionManager presentModalViewControllerFrom:self to:describe duration:0.3 transitionType:TransitionPush directionType:TransitionFromRight];
                
                describe.okBlock = ^{
                    [self fitFrameForChildViewController:self.navSos];
                    
                    [self transitionFromOldViewController:_currentVC toNewViewController:self.navSos];
                    
                    self.vcCount = item;

                };
                
                return;
            }

        }
            break;
            
        case 4:
        {
            
            BOOL stepVcTurnedOn = [SKUserDefaults boolForKey:@"stepVcTurnedOn"];
            
            if (stepVcTurnedOn == NO) {
                SMStepCounterDescribeInterface *description = [[SMStepCounterDescribeInterface alloc]initWithNibName:@"SMStepCounterDescribeInterface" bundle:nil];
                
                [SKViewTransitionManager presentModalViewControllerFrom:self to:description duration:0.3 transitionType:TransitionPush directionType:TransitionFromRight];
                
                description.returnBlock = ^(){
                    [self fitFrameForChildViewController:self.navStepCounter];
                    
                    [self transitionFromOldViewController:_currentVC toNewViewController:self.navStepCounter];
                };
            }else{
                [self fitFrameForChildViewController:self.navStepCounter];
                
                [self transitionFromOldViewController:_currentVC toNewViewController:self.navStepCounter];
            }
            
         
        }
            break;
        case 5:
        {
            [self fitFrameForChildViewController:self.navSetting];
            
            [self transitionFromOldViewController:_currentVC toNewViewController:self.navSetting];
        }
            break;
        case 6:
        {
            [self fitFrameForChildViewController:self.navHelp];
            
            [self transitionFromOldViewController:_currentVC toNewViewController:self.navHelp];
        }
            break;
        default:
            break;
    }
    
    self.vcCount = item;
    
}

- (void)offSosFuncState:(NSInteger)integer{
    switch (integer) {
        case 0:
        {
            [self fitFrameForChildViewController:self.notification];
            
            [self transitionFromOldViewController:self.currentVC toNewViewController:self.notification];
            
            //[self setupNavigationTitle:NSLocalizedString(@"nav_title_APP_NOTIFICATIONS", nil)];
            
        }
            break;
        case 1:
        {
            
            BOOL notification_contactVcTurnedOn = [SKUserDefaults boolForKey:@"main_contactVcTurnedOn"];
            
            if (notification_contactVcTurnedOn == NO) {
                SMContactsDescriptionViewController *description = [[SMContactsDescriptionViewController alloc]initWithNibName:@"SMContactsDescriptionViewController" bundle:nil];
                description.entrance = @"main";
                
                [SKViewTransitionManager presentModalViewControllerFrom:self to:description duration:0.3 transitionType:TransitionPush directionType:TransitionFromRight];
                
                description.returnBlock = ^(){
                    
                };
            }
            
            [self fitFrameForChildViewController:self.contact];
            
            [self transitionFromOldViewController:_currentVC toNewViewController:self.contact];
            
            //[self setupNavigationTitle:NSLocalizedString(@"nav_title_CONTACT_NOTIFICATIONS", nil)];
            
        }
            break;
        case 2:
        {
            [self fitFrameForChildViewController:self.play];
            
            [self transitionFromOldViewController:_currentVC toNewViewController:self.play];
            
            //[self setupNavigationTitle:NSLocalizedString(@"nav_title_PLAY", nil)];
            
        }
            break;
        case 3:
        {
            [self fitFrameForChildViewController:self.setting];
            
            [self transitionFromOldViewController:_currentVC toNewViewController:self.setting];
            
            //[self setupNavigationTitle:NSLocalizedString(@"nav_title_SETTINGS", nil)];
            
        }
            break;
            
            
        case 4:
        {
            [self fitFrameForChildViewController:self.help];
            
            [self transitionFromOldViewController:_currentVC toNewViewController:self.help];
            
            //[self setupNavigationTitle:NSLocalizedString(@"nav_title_help", nil)];
            
        }
            break;
        default:
            break;
    }

}

- (void)fitFrameForChildViewController:(UIViewController *)chileViewController{
    CGRect frame = self.contentView.frame;
    frame.origin.y = 0;
    chileViewController.view.frame = frame;
    NSLog(@"视图尺寸%@",NSStringFromCGRect(frame));
}

//转换子视图控制器
- (void)transitionFromOldViewController:(UIViewController *)oldViewController toNewViewController:(UIViewController *)newViewController{
    
    [self transitionFromViewController:oldViewController toViewController:newViewController duration:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        if (finished) {
            [newViewController didMoveToParentViewController:self];
            _currentVC = newViewController;
        }else{
            _currentVC = newViewController;
        }
    }];
}

//移除所有子视图控制器
- (void)removeAllChildViewControllers{
    for (UIViewController *vc in self.childViewControllers) {
        [vc willMoveToParentViewController:nil];
        [vc removeFromParentViewController];
    }
}



- (void)showAlertController:(NSString*)title body:(NSString*)body type:(NSString*)type{
    [self remorveNotification:type];
    
    UIApplication *app=[UIApplication sharedApplication];
    if (app.applicationState == UIApplicationStateBackground) {// 如果应用在后台发送通知
        
        if ([SKUserNotification judgeSystemVersionIsIos10]) {// 如果是IOS10
            [SKUserNotification addNotification:title body:body identifier:type];
        }else{
            
            UIUserNotificationSettings *notifySettings=[[UIApplication sharedApplication] currentUserNotificationSettings];
            if ((notifySettings.types & UIUserNotificationTypeAlert)!=0) {
                
                //定义本地通知对象
                UILocalNotification *notification=[[UILocalNotification alloc]init];
                //设置调用时间
                notification.fireDate=[NSDate dateWithTimeIntervalSinceNow:0];//通知触发的时间，10s以后
                notification.repeatInterval=2;//通知重复次数
                //notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
                
                //设置通知属性
                notification.alertTitle = title;
                notification.alertBody=body; //通知主体
                notification.applicationIconBadgeNumber=1;//应用程序图标右上角显示的消息数
                //notification.alertAction=@"打开应用"; //待机界面的滑动动作提示
                //notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
                //notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
                notification.soundName=@"msg.caf";//通知声音（需要真机才能听到声音）
                
                //设置用户信息
                notification.userInfo=@{@"id":@1,@"type":type};//绑定到通知上的其他附加信息
                
                //调用通知
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            }
        }
        
    }else{// 如果在前台提示警告框
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:body preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        
        [alertController addAction:okAction];
        
        if (![self isBlankString:title]) {
            [alertController setValue:[self setAlertControllerWithStrring:title fontSize:17 spacing:1.85] forKey:@"attributedTitle"];
        }
        
        if (![self isBlankString:body]) {
            [alertController setValue:[self setAlertControllerWithStrring:body fontSize:14 spacing:1.85]  forKey:@"attributedMessage"];;
        }

        
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
}

- (void)remorveNotification:(NSString*)type
{
    
    if ([SKUserNotification judgeSystemVersionIsIos10]) {
        [SKUserNotification removeNotification:type];
    }else{
        NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
        
        if (localNotifications) {
            for (UILocalNotification *noti in localNotifications) {
                NSDictionary *dict = noti.userInfo;
                
                NSLog(@"--通知:%@",noti);
                
                if (dict) {
                    NSString *inKey = [dict objectForKey:@"type"];
                    if ([inKey isEqualToString:type]) {
                        
                        [[UIApplication sharedApplication] cancelLocalNotification:noti];
                        //[[UIApplication sharedApplication]cancelAllLocalNotifications];
                        
                        break;
                    }
                }
            }
        }
    }
    

    
}

- (NSMutableAttributedString*)setAlertControllerWithStrring:(NSString*)string fontSize:(NSInteger)size spacing:(NSInteger)spacing{
    //修改message
    NSMutableAttributedString *alertControllerStrring = [[NSMutableAttributedString alloc] initWithString:string];
    [alertControllerStrring addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:size] range:NSMakeRange(0, string.length)];
    [alertControllerStrring addAttribute:NSKernAttributeName value:[NSNumber numberWithInteger:spacing] range:NSMakeRange(0, string.length)];
    
    return alertControllerStrring;
}

- (void)detectionAppVersion{
    
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc]init];
    [sessionManager POST:@"http://itunes.apple.com/lookup?id=1076083740" parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *array = responseObject[@"results"];
        NSDictionary *dict = [array lastObject];
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        
        NSString * serverVersion = dict[@"version"];
        
        NSString * localVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        
        NSLog(@"app store 版本为：%@，当前版本为：%@",serverVersion,localVersion);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}

- (void)viewWillDisappear:(BOOL)animated{
}

-(BOOL)isChinese:(NSString *)phoneNum
{
    // 只需要不是中文即可
    NSString *regex = @".{0,}[\u4E00-\u9FA5].{0,}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self matches %@",regex];
    BOOL res = [predicate evaluateWithObject:phoneNum];
    if (res == TRUE) {
        //NSLog(@"中文");
        return YES;
    }
    else
    {
        //NSLog(@"英文");
        return NO;
    }
}

- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

- (void)viewDidDisappear:(BOOL)animated{
 
}

#pragma mark - 紧急求救的触发方法
-(void)sosAction:(NSNotification *)notification{
    NSLog(@"----------紧急求救功能触发");
    
    SMlocationStartup = UserStartup;
    
    [self setupLocation];
    //[self setupLocationManager];
}

- (void)startBackgroundTask{
    
    UIApplication *app = [UIApplication sharedApplication];
    
    self.backgroundTaskIdentifier = [app beginBackgroundTaskWithExpirationHandler:^( void) {
        [self endBackgroundTask];
    }];
    
    
    NSLog(@"backgroundTaskIdentifier:%lu",(unsigned long)self.backgroundTaskIdentifier);
}

- (void)endBackgroundTask{
    [[UIApplication sharedApplication]endBackgroundTask:self.backgroundTaskIdentifier];
    // 销毁后台任务标识符
    self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
}

- (void)setupLocation{
    
    [self startBackgroundTask];
    
    SMlocationManager *helper= [SMlocationManager sharedLocationManager];
    
    helper.isReverseGeocodeLocation = YES;
    
    [helper startLocationAndGetPlaceInfo:^(BOOL results) {
        if (results == NO) {
            dispatch_queue_t queue = dispatch_get_main_queue();
            dispatch_async(queue, ^{
                
                
//                
//                if ([NSLocalizedString(@"language", nil)isEqualToString:@"German"]) {
//                    [self showAlertController:@"LOCATION SERVICES OFF" body:@"TURN ON LOCATION SERVICES IN SETTINGS > PRIVACY TO ALLOW BLINQ TO DETERMINE YOUR CURRENT LOCATION" type:@"sos"];
//
//                }else{
//                    [self showAlertController:@"LOCATION SERVICES OFF" body:@"TURN ON LOCATION SERVICES IN SETTINGS > PRIVACY TO ALLOW BLINQ TO DETERMINE YOUR CURRENT LOCATION" type:@"sos"];
//
//                }
                
                //                UIApplication *app=[UIApplication sharedApplication];
                //                if (app.applicationState == UIApplicationStateBackground) {
                //
                //                    UIUserNotificationSettings *notifySettings=[[UIApplication sharedApplication] currentUserNotificationSettings];
                //
                //                    if ((notifySettings.types & UIUserNotificationTypeAlert)!=0) {
                //
                //                        UILocalNotification *notification=[UILocalNotification new];
                //
                //                        notification.alertBody=@"TURN ON LOCATION SERVICES IN SETTINGS > PRIVACY TO ALLOW BLINQ TO DETERMINE YOUR CURRENT LOCATION";
                //
                //                        NSDictionary *infoDic = [NSDictionary dictionaryWithObject:@"name" forKey:@"key"];
                //
                //                        notification.userInfo = infoDic;
                //
                //                        [app presentLocalNotificationNow:notification];
                //                    }
                //                }else{
                //
                //                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"LOCATION SERVICES OFF" message:@"TURN ON LOCATION SERVICES IN SETTINGS > PRIVACY TO ALLOW BLINQ TO DETERMINE YOUR CURRENT LOCATION" preferredStyle:UIAlertControllerStyleAlert];
                //
                //                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //
                //                    }];
                //
                //
                //                    [alertController addAction:okAction];
                //
                //                    [self presentViewController:alertController animated:YES completion:nil];
                //
                //                }
                
            });
        }
    }];
    
    helper.returnBlock=^(NSMutableDictionary * addresss,CLLocationCoordinate2D currentUserCoordinate, BOOL isSuccessful){
        
        NSLog(@"returnBlock返回的地址信息：%@ --- 是否定位成功%@",addresss,isSuccessful?@"YES":@"NO");
        
        if ([addresss allKeys].count == 0 || isSuccessful == NO) {
            
            if (SMlocationStartup == UserStartup) {
                [self showAlertController:nil body:NSLocalizedString(@"sos_failed_to_locate_address", nil) type:@"sos"];
            }
            
            [self endBackgroundTask];

            NSLog(@"经纬度找不到") ;
        }else{
            
            
            if (SMlocationStartup == UserStartup) {
                
                checkCount = 0;
                [self.timer invalidate];
                self.timer = nil;
                
                // 紧急联系人
                SMContactModel *contact = [[SMSosContactTool contacts]lastObject];
                NSString *areaCode = contact.countryCode;
                NSString *phoneNum = contact.phoneNum;
                NSLog(@"紧急求救的号码%@",phoneNum);
                
                // 信息
                NSString *message = [[NSUserDefaults standardUserDefaults]objectForKey:@"sosTextMessage"];
                
                if ([self isBlankString:phoneNum] == NO) {
                    
                    //
                    if ([areaCode isEqualToString:@"86"]) {
                        
                        [AlidayuManager alidayMessageToContact:phoneNum address:addresss isSendSuccessful:^(BOOL isSendSuccessful) {
                            if (isSendSuccessful) {
                                NSLog(@"发送成功啦啦啦啦啦");
                                [self showAlertController:nil body:NSLocalizedString(@"sos_occurred_sent_message", nil) type:@"sos"];
                            }else{
                                NSLog(@"发送失败啊啊啊啊啊");
                                [self showAlertController:nil body:NSLocalizedString(@"sos_message_sent_failure", nil) type:@"sos"];
                            }
                        }];
                        
                    }else{
                        
                        // 紧急求救的短信发送
                        [AlidayuManager sendMessageToContact:phoneNum andAreaCode:areaCode message:message address:addresss isSendSuccessful:^(BOOL isSendSuccessful) {
                            if (isSendSuccessful) {
                                NSLog(@"发送成功啦啦啦啦啦");
                                [self showAlertController:nil body:NSLocalizedString(@"sos_occurred_sent_message", nil) type:@"sos"];
                            }else{
                                NSLog(@"发送失败啊啊啊啊啊");
                                [self showAlertController:nil body:NSLocalizedString(@"sos_message_sent_failure", nil) type:@"sos"];
                            }
                        }];
                    }
                    
                }
                
                
                // 用户的姓名
                NSString *name = [[NSString alloc]init];
                NSString *firstName = [SKUserDefaults objectForKey:@"firstName"];
                NSString *lastName = [SKUserDefaults objectForKey:@"lastName"];
                
                if (![self isBlankString:firstName] && ![self isBlankString:lastName]) {
                    name = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
                }
                
                
                //-----------------
                //faceBook
                NSString *description = [[NSString alloc]init];
                
                description = [NSString stringWithFormat:NSLocalizedString(@"facebook_message_content_template", nil)];
                
                NSString *url = [NSString stringWithFormat:@"https://maps.google.com/maps?q=%f,%f",currentUserCoordinate.latitude,currentUserCoordinate.longitude];
                
                NSString *title = NSLocalizedString(@"facebook_message_title", nil);
                
                
                NSString *locationString = [NSString stringWithFormat:@"Location(%f, %f)",currentUserCoordinate.latitude,currentUserCoordinate.longitude];
                
                [self shareLineContentUrl:url andTitle:title andDescription:description location:locationString];
                
            }
            
            [self endBackgroundTask];

        }
        
        
    };
}

- (void)shareLineContentUrl:(NSString*)url andTitle:(NSString*)title andDescription:(NSString*)description location:(NSString*)location{
    
    BOOL postToWallPower = [SKUserDefaults boolForKey:@"postToWallPower"];
    BOOL socialPower = [SKUserDefaults boolForKey:@"socialPower"];
    
    if (socialPower == NO) {
        NSLog(@"请确认功能开关及发布开关已开启");
        return;
    }
    
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
        
        FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
        content.contentURL = [NSURL URLWithString:url];
        content.contentTitle = title;
        content.contentDescription = location;
        
        FBSDKShareAPI *api = [[FBSDKShareAPI alloc]init];
        if(api != nil){
            api.message = description;
            api.shareContent = content;
            api.delegate = self;
            [api share];
        }
        
    }else {
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logInWithPublishPermissions:@[@"publish_actions"]
                               fromViewController:self
                                          handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                              //TODO: process error or result.
                                          }];
    }
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error{
    NSLog(@"发送失败%@",error);
}

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results{
    
    NSLog(@"发送成功%@",results);
    [self showAlertController:nil body:NSLocalizedString(@"sos_occurred_post_to_facebook", nil) type:@"faceBook"];
}

- (void)startTheTimer{
    
    if (!self.timer) {
        dispatch_queue_t queue = dispatch_get_main_queue();
        dispatch_async(queue, ^{
            self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(againStartUpdatingLocation) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        });
    }
}


- (void)againStartUpdatingLocation{
    
    if (checkCount < 3) {
        NSLog(@"再次尝试定位%ld",checkCount);
        [[SMlocationManager sharedLocationManager]startUpdatingLocation];
        checkCount++;
    }else{
        checkCount = 0;
        [self.timer invalidate];
        self.timer = nil;
        NSLog(@"无法定位");
        
        [self showAlertController:nil body:NSLocalizedString(@"sos_failed_to_locate_address", nil) type:@"sos"];
    }
    
}



@end
