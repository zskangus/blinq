//
//  RemindNoticeManager.h
//  cjj
//
//  Created by 聂晶 on 16/4/2.
//  Copyright © 2016年 cjj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SmartRemindConfig.h"
#import "RemindNoticeInfo.h"

@interface RemindNoticeManager : NSObject

@property NSMutableArray *selected;//已选择
@property NSMutableArray *unselected;//未选择
@property NSArray *alls;
@property NSArray *lights;

@property SmartRemindConfig *powerConfig;

-(void)readInfo;
-(void)updateArray;
-(void)updateInfo:(NSNotification*) notification;
-(void)change:(RemindNoticeInfo *)info;

@end
