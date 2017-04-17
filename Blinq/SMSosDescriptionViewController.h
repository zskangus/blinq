//
//  SMSosDescriptionViewController.h
//  Blinq
//
//  Created by zsk on 2016/11/7.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "SMBaseViewController.h"

typedef void(^ReturnBlock)(void);

@interface SMSosDescriptionViewController : SMBaseViewController

@property(nonatomic,strong)NSString *bottomButtonTitle;

@property(nonatomic,copy)ReturnBlock returnBlock;

@end
