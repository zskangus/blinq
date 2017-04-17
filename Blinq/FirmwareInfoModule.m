//
//  固件信息模块
//  cjj
//
//  Created by 聂晶 on 15/11/14.
//  Copyright © 2015年 cjj. All rights reserved.
//

#import "FirmwareInfoModule.h"
#import "Message.h"
#import "MessageHead.h"
#import "AppConstant.h"
#import "BTServer.h"

#import "SMPlayViewController.h"

@interface FirmwareInfoModule()

@property (strong,nonatomic)BTServer *defaultBTServer;

@end

@implementation FirmwareInfoModule

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.defaultBTServer = [BTServer sharedBluetooth];

    }
    return self;
}


-(void)build:(NSInteger) err andCmdID:(NSInteger)cmdID andUserID:(NSData *) userId {
    self.errcode = err;
    self.cmdId = cmdID;
    if(userId != nil) {
        self.userId = userId;
    }
}

-(void)build:(NSInteger) err andCmdID:(NSInteger)cmdID {
    [self build:err andCmdID:cmdID andUserID:nil];
}

-(NSData *) toBytes{
    NSMutableData *buff = [[NSMutableData alloc]init];
    Byte *fixed[2];
    fixed[0] = self.cmdId;
    fixed[1] = self.errcode;
    [buff appendBytes:fixed length:(2)];
    if(self.userId != nil) {
        [buff appendData:self.userId];
    }
    return buff;
}

-(void)parse:(NSData *)reqBytes strBlock:(stringBlock)string{
    if (reqBytes == nil || reqBytes.length <= DATA_MIN_LENGTH)
        return;
    
    Byte *buff = (Byte *)[reqBytes bytes];
    self.cmdId = buff[0];
    self.errcode = buff[1];
    if (reqBytes.length>DATA_MIN_LENGTH) {
        NSData *sendData = [reqBytes subdataWithRange:NSMakeRange(2, reqBytes.length - 2)];
        self.token = sendData;
        switch (self.cmdId) {
            case COMMAND_ID_BOND_ACK:
                break;
            case COMMAND_ID_BOND_STATUS_ACK:
                break;
            case COMMAND_ID_AUTH_ACK:{
                NSString* errorstatus;
                if (self.errcode) {
                    errorstatus = AUTH_ERRCODEFAILED;
                }else{
                    errorstatus = AUTH_ERRCODESUCCESS;
                }
                
                string(errorstatus);
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_AUTH object:errorstatus];
                break;
            }
                //用户点击动作
            case EVENT_ID_USER_CLICK_ACTION:{
                //                    Byte *count =  (Byte *)[sendData bytes];
                //                    NSLog(@"count:%@",count);
                //                    if([self isKindOfClass:[KnockViewController class]]){
                //                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USER_CLICK object:[sendData bytes]];
                //
                //                    }
                break;
            }
            case COMMAND_ID_GET_SYS_TIME_ACK:
            {
                
            }
            default:
                break;
        }
        
    }
    
}

Byte USER_ID[] = { 0x08, 0x02, 0x02, 0x01, 0x01, 0x02, 0x03, 0x04,
    0x01, 0x03, 0x02, 0x01, 0x01, 0x01, 0x01, 0x01 };


//请求绑定
-(BOOL)bindDevice{
    BOOL states;
    FirmwareInfoModule* data = [[FirmwareInfoModule alloc]init];
    NSData* userNSData = [[NSData alloc] initWithBytes:USER_ID length:sizeof(USER_ID)];
    [data build:ERR_CODE_OK andCmdID:COMMAND_ID_BOND_REQ andUserID:userNSData];
    NSData *body = [data toBytes];
    
    NSLog(@"请求绑定的数据%@",body);
    
    Message *msg = [[Message alloc]init];
    [msg build:ModID_deviceInfo and:body];
    NSData *req = [msg bytes2NSData];
    [Utils printfData2Byte:req and:@"bind"];

    NSLog(@"发送请求绑定的数据%@",req);
    [self.defaultBTServer writedidWriteData:req];
    
    return states;
    

    
}

//确认绑定
-(BOOL)confrimBindState{
    BOOL states;
    FirmwareInfoModule* data = [[FirmwareInfoModule alloc]init];
    [data build:ERR_CODE_OK andCmdID:COMMAND_ID_BOND_STATUS_ACK];
    NSData *body = [data toBytes];
    [Utils printfData2Byte:body and:@"确认绑定绑定body"];

    Message *msg = [[Message alloc]init];
    [msg build:ModID_deviceInfo and:body];
    NSData *sendData = [msg bytes2NSData];
    [Utils printfData2Byte:sendData and:@"确认绑定绑定"];
    
    NSLog(@"发送确认绑定的数据");
    [self.defaultBTServer writedidWriteData:sendData];
    
    return states;
}
//请求验证2
-(BOOL) takeAutho{
    //self.tokenNSData = token;
    BOOL status = false;
    FirmwareInfoModule* data = [[FirmwareInfoModule alloc]init];
    NSData *adata = [[NSData alloc] initWithBytes:USER_ID length:16];
    [data build:ERR_CODE_OK andCmdID:COMMAND_ID_AUTH_REQ andUserID:adata];
    NSData *body = [data toBytes];
    Message *msg = [[Message alloc]init];
    [msg build:ModID_deviceInfo and:body];
    NSData *sendData = [msg bytes2NSData];
    
    NSLog(@"发送请求验证的数据");
    [self.defaultBTServer writedidWriteData:sendData];
    
    return YES;
}
////请求验证
//-(BOOL) takeAutho:(NSData*)token{
//    [Utils printfData2Byte:token and:@"请求验证>>>>>>>>token:"];
//    //self.tokenNSData = token;
//    [Utils setToKenNSData:token];
//    BOOL status = false;
//    FirmwareInfoModule* data = [[FirmwareInfoModule alloc]init];
//    [data build:ERR_CODE_OK andCmdID:COMMAND_ID_AUTH_REQ andUserID:token];
//    NSData *body = [data toBytes];
//    Message *msg = [[Message alloc]init];
//    [msg build:ModID_deviceInfo and:body];
//    NSData *sendData = [msg bytes2NSData];
//    //存储数据
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *string = @"成功绑定";
//    [userDefaults setObject:string forKey:@"isBinding"];
//    //强制保存到硬盘中
//    [userDefaults synchronize];
//    return status;
//}

@end
