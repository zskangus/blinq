//
//  SMSOSDescribe.h
//  Blinq
//
//  Created by zsk on 2017/6/29.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMBaseViewController.h"

typedef void(^okBlock)(void);

@interface SMSOSDescribe : SMBaseViewController

@property(nonatomic,copy)okBlock okBlock;

@end
