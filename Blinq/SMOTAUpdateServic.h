//
//  SMOTAUpdateServic.h
//  SmartRing
//
//  Created by zsk on 2017/7/19.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLParsing.h"

typedef void(^updateProgress)(double progress);

typedef void(^updateSuccessful)(void);

typedef void(^updateFailure)(NSError *error);

@interface SMOTAUpdateServic : NSObject

- (void)performOTAUpdateFromFileUrl:(NSURL *)url successful:(updateSuccessful)successful failure:(updateFailure)failure progress:(updateProgress)progress;

+ (void)checkFirmwareVersion:(void(^)(NSString *url,NSString *version))need notNeed:(void(^)(void))notNeed;

@end
