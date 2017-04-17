//
//  TopPlayManager.h
//  cjj
//
//  Created by 聂晶 on 15/11/26.
//  Copyright © 2015年 cjj. All rights reserved.
//

#import "SmartDeviceManager.h"

@interface TopPlayManager : SmartDeviceManager

-(void)writerMsgDataTopPlayColor:(NSInteger)modId data:(NSData *)color;

-(void)writerMsgDataTopPlayVibrate:(NSInteger)modId data:(NSData *)level;

-(void)parseMsgDataForTopPlay:(NSData *)reqBytes;
@end
