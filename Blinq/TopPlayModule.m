//
//  TopPlayModule.m
//  cjj
//
//  Created by 聂晶 on 15/12/16.
//  Copyright © 2015年 cjj. All rights reserved.
//

#import "TopPlayModule.h"
#import "TopPlayData.h"

@implementation TopPlayModule



+(TopPlayData *)setConfigsCOLOR:(NSData*)data reqAck:(BOOL)reqAck{
    Byte cmdId = reqAck ? COMMAND_ID_COLOR_SET_REQ : COMMAND_ID_COLOR_SET_NACK;
    
    return [TopPlayData build:cmdId andPlay:data];
    

}

+(TopPlayData *)setConfigsVIB:(NSData*)data reqAck:(BOOL)reqAck{
    Byte cmdId = reqAck ? COMMAND_ID_VIB_SET_REQ : COMMAND_ID_VIB_SET_NACK;
    
    return [TopPlayData build:cmdId andPlay:data];
   
}



//-(void) getDeviceLightColor {
//    TopPlayData* module = [[TopPlayData alloc]init];
//    [module build:COMMAND_ID_COLOR_GET_REQ andPlay:nil];
//    
//}

@end
