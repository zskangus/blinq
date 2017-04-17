//
//  NotificationInfo.h
//  cjj
//
//  Created by 聂晶 on 15/11/29.
//  Copyright © 2015年 cjj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SmartRemindData.h"

@interface NotificationInfo : NSObject

@property (nonatomic,strong) SmartRemindData *srd;
@property UInt64 config;
@property int number;
@property (nonatomic,strong) NSData *data;




@property(nonatomic,strong)NSString* sendPackageName;
@property(nonatomic,strong)NSString* sendAppName;
@property(nonatomic,strong)NSString* sendAppContext;


@end
