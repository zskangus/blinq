//
//  固件信息模块
//  cjj
//
//  Created by 聂晶 on 15/11/14.
//  Copyright © 2015年 cjj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModuleClass.h"

typedef void(^stringBlock)(NSString* string);

@interface FirmwareInfoModule : ModuleClass

@property NSInteger cmdId;
@property NSInteger errcode;
@property NSData* userId;
@property NSData* token;




/**
 **根据errcode,modId,UserID封装数据
 **/
-(void)build:(NSInteger) err andCmdID:(NSInteger)cmdID andUserID:(NSData *) userId;

/**
 **根据errCode,modId封装数据
 **/
-(void)build:(NSInteger) err andCmdID:(NSInteger) cmdID;

-(NSData *) toBytes;

/**
 * 解析数据
 *
 **/
-(void)parse:(NSData *)reqBytes strBlock:(stringBlock)string;


//绑定
-(BOOL)bindDevice;
//确认绑定
-(BOOL)confrimBindState;

//-(BOOL)ackBindState;
//根据userid验证
-(BOOL)takeAutho;

//-(BOOL) takeAutho:(NSData*)token;

//用户敲击返回敲击的次数
-(void)userKnock;
//设置系统时间
-(void)setSystemTime;
//获取系统时间
-(void)getSystemTime;


@end
