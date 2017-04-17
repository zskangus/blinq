//
//  ModuleClass.m
//  cjj
//
//  Created by 聂晶 on 15/11/14.
//  Copyright © 2015年 cjj. All rights reserved.
//

#import "ModuleClass.h"

@implementation ModuleClass



-(BOOL)isERRCode:(int)error{
    BOOL falg = false;
    switch (error) {
        case ERR_CODE_OK:
            NSLog(@"ERROR--->无错误");
            falg = true;
            break;
        case ERR_CODE_INVALID_DATA_LENGTH:
            NSLog(@"ERR_CODE_INVALID_DATA_LENGTH--->验证数据长度错误");
            break;
        case ERR_CODE_READ_MEM_FAILED:
            NSLog(@"ERR_CODE_READ_MEM_FAILED--->错误");
            break;
        case ERR_CODE_WRITE_MEM_FAILED:
            NSLog(@"ERR_CODE_WRITE_MEM_FAILED--->错误");
            break;
        case ERR_CODE_MALLOC_MEM_FAILED:
            NSLog(@"ERR_CODE_MALLOC_MEM_FAILED--->错误");
            break;
        case ERR_CODE_NO_NTF_SETTINGS:
            NSLog(@"ERR_CODE_NO_NTF_SETTINGS--->错误");
            break;
        case ERR_CODE_INVALID_MOD_TAG:
            NSLog(@"ERR_CODE_INVALID_MOD_TAG--->错误");
            break;
        case ERR_CODE_INVALID_MOD_DATA:
            NSLog(@"ERR_CODE_INVALID_MOD_DATA--->错误");
            break;
        case ERR_CODE_INVALID_CMD:
            NSLog(@"ERR_CODE_INVALID_CMD--->错误");
            break;
        case ERR_CODE_COMMAND_DISALLOWED:
            NSLog(@"ERR_CODE_COMMAND_DISALLOWED--->错误");
            break;
        case ERR_CODE_DEVICE_NOT_BONDED:
            NSLog(@"ERR_CODE_DEVICE_NOT_BONDED--->错误");
            break;
        case ERR_CODE_CURR_STATE_DISALLOWED:
            NSLog(@"ERR_CODE_CURR_STATE_DISALLOWED--->错误");
            break;
            
        default:
            break;
    }
    return falg;
}


@end
