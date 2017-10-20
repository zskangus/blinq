//
//  SMBaseViewController.m
//  Blinq
//
//  Created by zsk on 16/8/3.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "SMBaseViewController.h"
#import "otaUpgradeViewController.h"
#import "otaUpdateAvailableViewController.h"
#import <AFNetworking.h>
#import "NSDate+Tool.h"

@interface SMBaseViewController ()

@end

@implementation SMBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (screenHeight != 480) {
        [self viewTransform];
    }
    
    [self setupNavigation];
}

- (void)setupNavigation{
    
//    // 设置导航栏title的显示效果
//    NSDictionary *TitleDict = @{NSFontAttributeName:[UIFont fontWithName: @"Avenir" size:16],
//                                NSForegroundColorAttributeName:[UIColor whiteColor],
//                                NSKernAttributeName:@2.46};
//    
//    [[UINavigationBar appearance]setTitleTextAttributes:TitleDict];
    
    // 避免内容被导航条遮挡
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    //self.extendedLayoutIncludesOpaqueBars = NO;
    //self.modalPresentationCapturesStatusBarAppearance = NO;
    

}

- (void)popupSidebar{ // 点击导航栏上的menu按钮推出侧边栏
    [SKNotificationCenter postNotificationName:@"popupSidebar" object:nil];
}

- (void)setupNavigationTitle:(NSString *)string isHiddenBar:(BOOL)hidden{
    
    if (hidden == NO) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg-navBar"] forBarMetrics:UIBarMetricsDefault];
    }else{
        // 设置背景颜色
        [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
        // 设置导航栏半透明
        self.navigationController.navigationBar.translucent = true;
        // 设置导航栏背景图片
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        // 设置导航栏阴影图片
        self.navigationController.navigationBar.shadowImage = [UIImage new];
    }
    
    // 注意需要将图片Render AS选项设置为orignal image选项，保证图片是没有经过渲染的原图。在图片管理器的第三选项卡
    UIBarButtonItem *logoItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStyleDone target:self action:@selector(popupSidebar)];
    
    self.navigationItem.leftBarButtonItem = logoItem;

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 200, 44)];

    titleLabel.backgroundColor = [UIColor clearColor];

    titleLabel.text = string;

    if (![string isEqualToString:@"CONTACT NOTIFICATIONS"]) {
        titleLabel.font = [UIFont fontWithName: @"Avenir-Book" size:16];
    }else{

        if (self.view.frame.size.width == 320) {
            titleLabel.font = [UIFont fontWithName: @"Avenir-Book" size:12];
        }else{
            titleLabel.font = [UIFont fontWithName: @"Avenir-Book" size:15];
        }


        NSLog(@"pingmukuandu%@",NSStringFromCGRect(self.view.frame));
    }

    if ([string isEqualToString:@"APP-BENACHRICHTIGUNGEN"]) {
        titleLabel.font = [UIFont fontWithName: @"Avenir-Book" size:14];
    }

    if ([string isEqualToString:@"KONTAKT-BENACHRICHTIGUNGEN"]) {
        titleLabel.font = [UIFont fontWithName: @"Avenir-Book" size:11];
    }

    titleLabel.textAlignment = NSTextAlignmentCenter;

    NSRange range = NSMakeRange(0, titleLabel.text.length);

    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc]initWithString:titleLabel.text];

    // 设置文字颜色
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:range];

    CGFloat floatNum = 2.46f;
    NSNumber *num = [NSNumber numberWithFloat:floatNum];

    // 设置文字间距
    [attribute addAttribute:NSKernAttributeName value:num range:range];

    titleLabel.attributedText = attribute;

    self.navigationItem.titleView = titleLabel;
}


- (void)viewTransform{
    self.view.transform = CGAffineTransformMakeScale([UIScreen mainScreen].bounds.size.width / 375, [UIScreen mainScreen].bounds.size.width / 375);
}

- (void)autoDetectionRingVersion{
    
    NSUserDefaults *setUserDefaults = SKUserDefaults;
    
    BOOL power = [setUserDefaults boolForKey:@"connectStatus"];
    
    if (power) {
        BOOL isFirstTime = [setUserDefaults boolForKey:@"isFirstTime"];
        
        NSString *date = [setUserDefaults objectForKey:@"date"];
        
        // 第一次绑定-检测
        if (isFirstTime) {
            [setUserDefaults setBool:YES forKey:@"whetherNeedToRremindTheUserUpdate"];
            [self detection];
            [setUserDefaults setBool:NO forKey:@"isFirstTime"];
            
            [setUserDefaults setObject:[self getTheDate] forKey:@"date"];
            NSLog(@"第一次绑定进行OTA检测，是否需要升级戒指版本");
            return;
        }
        
        //获取现在的时间-如果日期不同，重置是否弹出更新提示的条件
        NSString *nowDate = [self getTheDate];
        
//        if ([date isEqualToString:nowDate]) {
//            NSLog(@"时间相同不执行执行OTA检测,保存的时间%@，现在的时间%@",date,nowDate);
//            return;
//        }else{
//            NSLog(@"时间不相同执行OTA检测,保存的时间%@，现在的时间%@",date,nowDate);
//            [setUserDefaults setBool:YES forKey:@"whetherNeedToRremindTheUserUpdate"];
//            [setUserDefaults setObject:nowDate forKey:@"date"];
//        }
        
        if (![date isEqualToString:nowDate]){
            NSLog(@"时间不相同执行OTA检测,保存的时间%@，现在的时间%@",date,nowDate);
            [setUserDefaults setBool:YES forKey:@"whetherNeedToRremindTheUserUpdate"];
            [setUserDefaults setObject:nowDate forKey:@"date"];
        }
        
        [setUserDefaults synchronize];
        
        [self detection];
    }
}

- (void)detection{
    
    NSUserDefaults *user = SKUserDefaults;
    
    BOOL isDetect = [user boolForKey:@"whetherNeedToRremindTheUserUpdate"];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        [otaUpgradeViewController checkFirmwareVersion:^(NSString *url, NSString *version) {
            if (isDetect) {
                
                [SMBlinqInfo setRingFirmwareUpdateFileUrl:url];
                
                dispatch_queue_t queue = dispatch_get_main_queue();
                dispatch_async(queue, ^{
                    
                    otaUpdateAvailableViewController *updateAvailableView = [[otaUpdateAvailableViewController alloc]initWithNibName:@"otaUpdateAvailableViewController" bundle:nil];
                    
                    [self presentViewController:updateAvailableView animated:YES completion:nil];
                    
                });
                
            }
        } notNeed:^{
            
        }];
        
    });
    
}

- (void)autoCheckAppVersion{
    
    NSDate *nowDate = [NSDate getStartTimeWithDate:[NSDate date]];
    
    NSString *nowDateString = [NSDate stringFormDate:nowDate withDateFormat:@"yyyy-MM-dd"];
    
    NSString *appOldDateString = [SMBlinqInfo timeOfTheLastHintAppNewVersion];
    
    if ([nowDateString isEqualToString:appOldDateString]) {
        return;
    }
    
    GCD_GLOBAL(^{
        [self checkAppVersion:^(NSString *appServerVersion) {
            
            
            // 蓝牙的取消
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"find_new_title", nil)  message:NSLocalizedString(@"find_new_version", nil) preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"no", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [SMBlinqInfo setTimeOfTheLastHintNewAppVersionWithDate:nowDateString];
            }];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"yes", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [SMBlinqInfo setTimeOfTheLastHintNewAppVersionWithDate:nowDateString];

                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1112810994"]];
            }];
            
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        } notNeed:^{
            
        }];
        
    });
    
}

- (void)checkAppVersion:(void(^)(NSString *appServerVersion))need notNeed:(void(^)(void))notNeed{
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc]init];
    [sessionManager POST:@"http://itunes.apple.com/lookup?id=1112810994" parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *array = responseObject[@"results"];
        NSDictionary *dict = [array lastObject];
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        
        NSString *appServerVersion = dict[@"version"];
        
        NSString * localVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        
        NSLog(@"app store 版本为：%@，当前版本为：%@",appServerVersion,localVersion);
        
        appServerVersion = [[appServerVersion componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet]] componentsJoinedByString:@""];
        
        localVersion = [[localVersion componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet]] componentsJoinedByString:@""];
        
        if ([appServerVersion isEqualToString:localVersion]) {
            notNeed();
            return;
        }
        
        //以"."分隔数字然后分配到不同数组
        NSArray * serverArray = [appServerVersion componentsSeparatedByString:@"."];
        
        NSArray * localArray = [localVersion componentsSeparatedByString:@"."];
        
        for (int i = 0; i < serverArray.count; i++) {
            
            //以服务器版本为基准，判断本地版本位数小于服务器版本时，直接返回（并且判断为新版本，比如服务器1.5.1 本地为1.5）
            if(i > (localArray.count -1)){
                NSLog(@"需要更新，当前最新版本为%@",appServerVersion);
                need(appServerVersion);
                break;
            }
            //有新版本，服务器版本对应数字大于本地
            if ( [serverArray[i] intValue] > [localArray[i] intValue]) {
                NSLog(@"需要更新，软件版本为%@，当前最新版本为%@",localVersion,appServerVersion);
                need(appServerVersion);
                break;
            }else if([serverArray[i] intValue] < [localArray[i] intValue]){
                notNeed();
                break;
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (CGRect)getScreenSize{
    
    CGRect frame = CGRectZero;
    
    if (IS_IPHONE_5) {
        frame = CGRectMake(0, 0, 320, 568);
    }
    
    if (IS_IPHONE_6_7) {
        frame = CGRectMake(0, 0, 375, 667);
    }
    
    if (IS_IPHONE_6P_7P) {
        frame = CGRectMake(0, 0, 414, 736);
    }
    
    return frame;
}


- (NSString*)getTheDate{
    
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    NSLog(@"现在的时间%@",dateString);
    
    return dateString;
}

- (BOOL)isBlankString:(NSString *)string {
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

- (NSMutableAttributedString*)setAlertControllerWithStrring:(NSString*)string fontSize:(NSInteger)size spacing:(NSInteger)spacing{
    //修改message
    NSMutableAttributedString *alertControllerStrring = [[NSMutableAttributedString alloc] initWithString:string];
    [alertControllerStrring addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:size] range:NSMakeRange(0, string.length)];
    [alertControllerStrring addAttribute:NSKernAttributeName value:[NSNumber numberWithInteger:spacing] range:NSMakeRange(0, string.length)];
    
    return alertControllerStrring;
}

- (NSDateComponents*)getCurrentDate{
    // 获取代表公历的NSCalendar对象
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    // 获取当前日期
    NSDate* dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour |  NSCalendarUnitMinute |
    NSCalendarUnitSecond | NSCalendarUnitWeekday;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components: unitFlags
                                          fromDate:dt];
    
    return comp;
}

@end
