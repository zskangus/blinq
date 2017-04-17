//
//  SMNetWorkState.m
//  Blinq
//
//  Created by zsk on 2016/11/2.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "SMNetWorkState.h"
#import <AFNetworking.h>

static BOOL netWorkstate;

@implementation SMNetWorkState

+ (void)whetherTheNetworkIsAvailable{
    
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态发生改变的时候调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                netWorkstate = YES;
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"自带网络");
                netWorkstate = YES;
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                netWorkstate = NO;
                break;
                
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                netWorkstate = YES;
                break;
            default:
                break;
        }
    }];
    // 开始监控
    [mgr startMonitoring];
}

+ (BOOL)state{
    return netWorkstate;
}

@end
