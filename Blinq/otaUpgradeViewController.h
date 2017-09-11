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

typedef void(^xmlBlock)(NSString *version,NSString *name, NSString *url);

@property char memoryType;
@property int memoryBank;
@property UInt16 blockSize;

@property int i2cAddress;
@property char i2cSDAAddress;
@property char i2cSCLAddress;

@property char spiMOSIAddress;
@property char spiMISOAddress;
@property char spiCSAddress;
@property char spiSCKAddress;

+ (BOOL)detectionRingVersion;

+ (void)checkFirmwareVersion:(void(^)(NSString *url,NSString *version))need notNeed:(void(^)(void))notNeed;



@end
