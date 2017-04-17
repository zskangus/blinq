//
//  TopPlayModule.h
//  cjj
//
//  Created by 聂晶 on 15/12/16.
//  Copyright © 2015年 cjj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TopPlayData.h"

@interface TopPlayModule : NSObject

//设置color
+(TopPlayData *)setConfigsCOLOR:(NSData*)data reqAck:(BOOL)reqAck;
//设置震动
+(TopPlayData *)setConfigsVIB:(NSData*)data reqAck:(BOOL)reqAck;

@end
