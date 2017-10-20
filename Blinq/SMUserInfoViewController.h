//
//  SMUserInfoViewController.h
//  Blinq
//
//  Created by zsk on 2017/10/15.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import "SMBaseViewController.h"

typedef void(^ReturnBlock)(void);

@interface SMUserInfoViewController : SMBaseViewController

@property(nonatomic,strong)NSString *bottomButtonTitle;

@property(nonatomic,copy)ReturnBlock returnBlock;

@end
