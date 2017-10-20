//
//  SMStepCounterDescribeInterface.h
//  Blinq
//
//  Created by zsk on 2017/10/15.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import "SMBaseViewController.h"

typedef void(^CReturnBlock)(void);

@interface SMStepCounterDescribeInterface : SMBaseViewController

@property(nonatomic,copy)CReturnBlock returnBlock;

@end
