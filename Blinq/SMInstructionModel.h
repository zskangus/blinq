//
//  SMInstructionModel.h
//  Blinq
//
//  Created by zsk on 2016/12/13.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMInstructionModel : NSObject

@property(nonatomic,assign)Byte commandId;

@property(nonatomic,assign)Byte modId;

@property(nonatomic,assign)Byte errorCode;

@property(nonatomic,assign)Byte dely;

@property(nonatomic,assign)Byte type;

@property(nonatomic,assign)Byte color;

@property(nonatomic,assign)Byte count;

@end
