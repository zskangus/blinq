//
//  otaUpgradeViewController.h
//  cjj
//
//  Created by zsk on 16/6/29.
//  Copyright © 2016年 cjj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMBaseViewController.h"

@interface otaUpgradeViewController : SMBaseViewController

+ (BOOL)detectionRingVersion;

+ (void)checkFirmwareVersion:(void(^)(NSString *url,NSString *version))need notNeed:(void(^)(void))notNeed;



@end
