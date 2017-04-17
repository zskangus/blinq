//
//  SMBaseTableViewController.m
//  Blinq
//
//  Created by zsk on 16/8/8.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "SMBaseTableViewController.h"
#import "otaUpgradeViewController.h"
#import "otaUpdateAvailableViewController.h"

@interface SMBaseTableViewController ()

@end

@implementation SMBaseTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewTransform];
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
        
        if ([otaUpgradeViewController detectionRingVersion]) {
            NSLog(@"otashengji%@",isDetect?@"YES":@"NO");
            if (isDetect) {
                
                dispatch_queue_t queue = dispatch_get_main_queue();
                dispatch_async(queue, ^{
                    
                    otaUpdateAvailableViewController *updateAvailableView = [[otaUpdateAvailableViewController alloc]initWithNibName:@"otaUpdateAvailableViewController" bundle:nil];
                    
                    [self presentViewController:updateAvailableView animated:YES completion:nil];
                    
                });
                
            }
            
        }
        
    });
    
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

@end
