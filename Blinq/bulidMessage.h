//
//  bulidMessage.h
//  Blinq
//
//  Created by zsk on 16/4/12.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SMAppModel.h"

@interface bulidMessage : NSObject


-(void)appInfo:(SMAppModel *)info isOn:(BOOL)isOn;

-(void)appInfo:(SMAppModel *)info SetupColor:(Byte)color;

@end
