//
//  SmartRemindManager.h
//  cjj
//
//  Created by 聂晶 on 15/11/26.
//  Copyright © 2015年 cjj. All rights reserved.
//

#import "SmartDeviceManager.h"
#import "BTServer.h"

@interface SmartRemindManager : SmartDeviceManager


-(void)writerMsgData:(NSInteger)modId type:(NSInteger)tagType;

-(void)parseMsgDataForSmartRemind:(NSData *)reqBytes;

-(void)writerPowerData:(NSInteger)modId reqData:(SmartRemindData *)reqdata;

-(void)writerData:(NSInteger)modId reqData:(Byte *)reqdata length: (Byte)len;

@end
